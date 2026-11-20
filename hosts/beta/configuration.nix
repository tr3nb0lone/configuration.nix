{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../pkgs/default.nix
    inputs.dms.nixosModules.dank-material-shell
  ];

  # security.pki.certificateFiles = [ ./mssp-dev-ca.crt ];
  hardware.enableAllFirmware = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  boot = {
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = with pkgs; [
        nixos-bgrt-plymouth
      ];
    };

    # https://wiki.nixos.org/wiki/Plymouth
    # Enable "Silent boot"
    consoleLogLevel = 3;
    # initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "plymouth.ignore-serial-consoles"
      "udev.log_priority=0" # set to =3 if you want udev error logs
    ];

    loader.timeout = 0;
    loader.systemd-boot.consoleMode = "max";
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
  };

  # Clean /tmp on reboot
  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
    tmpfsSize = "300%";
  };

  # Networking:
  networking = {
    networkmanager.enable = true;

    # Disable NetworkManager's internal DNS resolution
    networkmanager.dns = lib.mkForce "none";

    # These options are unnecessary when managing DNS ourselves
    useDHCP = false;
    dhcpcd.enable = false;

    # Configure DNS servers manually (Cloudflare and Google DNS)
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "100.100.100.100" # tailscale
    ];

    # but I trust everything!
    firewall.trustedInterfaces = [
      "virbr0"
      "tun0"
      "enp0s31f6"
      "wlp0s20f3"
      "tailscale0"
    ];
    firewall.enable = true;
    extraHosts = ''
      192.168.122.241 	     KALI
      192.168.1.2               zeru.beta
      192.168.1.3               henok.beta
      192.168.1.6               eden.beta
      192.168.1.41 	     keycloak.betatechhub.com enroll.siem-pilot.betatechhub.com 
      192.168.1.41              enroll.siem-pilot.betatechhub.com siem-pilot.betatechhub.com siem.beta 
    '';
  };

  # YAY! you now know where I live.
  time.timeZone = "Africa/Addis_Ababa";

  # general nixpkgs config
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnsupportedSystem = true;
    microsoftVisualStudioLicenseAccepted = true;
    android_sdk.accept_license = true;

    # get `deprecated / insecure / unmaintained` packages:
    permittedInsecurePackages = [
      "python-2.7.18.8"
      "python-2.7.18.12"
    ];

  };

  # misc overlays:
  nixpkgs.overlays = [
    inputs.go-overlay.overlays.default
    inputs.claude-desktop.overlays.default
    (import ../../overlays/burpsuite.nix)
  ];

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # User config:
  users.users.tr3n = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "podman"
      "audio"
      "nordvpn"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  # main shell:
  users.defaultUserShell = pkgs.zsh;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  # Docker:
  virtualisation.docker = {
    enable = false; # Consider disabling the system wide Docker daemon, prevent easy privesc dummy.
    rootless = {
      enable = true;
      setSocketVariable = true;
      # Optionally customize rootless Docker daemon settings
      daemon.settings = {
        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        max-concurrent-downloads = 3;
        max-concurrent-uploads = 3;
        # insecure-registries = [ "" ];
      };
    };
  };

  programs = {
    spicetify =
      # modded spotify
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
        ];

        theme = {
          name = "text";
          src = pkgs.fetchFromGitHub {
            owner = "tr3nb0lone";
            repo = "spicetify-theme";
            rev = "a7b9980667b445b28596dcac6f63190615bbfcff";
            hash = "sha256-aS4Gv0FYDMWk649v3CiDDFku2HstaQSWwT46Do03Fg4=";
          };
        };
      };

    # nvim
    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    # Direnv:
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      loadInNixShell = true;
      settings = builtins.fromTOML ''
        [global]
        log_format = "\u001B[2mdirenv: %s\u001B[0m"
        hide_env_diff = true
      '';
    };

    nh = {
      enable = true;
      clean.enable = true;
      # clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/tr3n/configuration.nix/";
    };

    # Hypr
    hyprland = {
      enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;

      withUWSM = true;
      xwayland.enable = true;
    };

    zsh = {
      enable = true;
      shellInit = ''
                eval "$(zoxide init zsh)"
        	eval "$(fzf --zsh)"
        	eval "$(direnv hook zsh)"
        	bindkey -s ^f "sessionizer.sh\n"
      '';
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    # DMS
    dux-shell = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
        restartIfChanged = true;
      };
    };

    # misc-programs:
    nm-applet.enable = false;
    virt-manager.enable = true;
  };

  # Virtualization:
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };

  services = {
    # List services that you want to enable:

    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      windowManager.i3.enable = true;
      desktopManager.xfce.enable = true;
      displayManager.startx.enable = true;
    };

    # Configure keymap(s) in X11
    xserver.xkb.layout = "us";
    xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      jack.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    # enable fingerprint
    fprintd.enable = false;
    picom.enable = false;

    blueman.enable = false;

    # Enable touchpad
    libinput.enable = true;

    # auto-mount and external disk management:
    udisks2.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    # Display manager:
    displayManager.ly = {
      enable = true;
      settings = {
        bg = "0x000c0c0c";
        fg = "0x00ffffff";
        border_fg = "0x00353535";
        error_bg = "0x00080808";
        error_fg = "0x01ffffff";
        full_color = true;
        animation = "matrix";
        clock = "%H:%M";
        edge_margin = 1;
      };
    };

    nordvpn.enable = true;

    # misc virtualization
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;

    # Tailscale
    tailscale = {
      # Enable tailscale at startup
      enable = true;
      extraUpFlags = [
        "--ssh"
        "--accept-routes"
      ];
    };

  };

  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;

  # Allow VM management
  users.groups.libvirtd.members = [ "tr3n" ];
  users.groups.kvm.members = [ "tr3n" ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    claude-desktop

    kitty
    rofi
    tmux
    polybar
    ayugram-desktop
    vesktop
    keepassxc
    arandr
    feh
    picom
    thunar
    obs-studio
    chromium
    vlc
    mpv
    pavucontrol
    pulseaudio
    bluez
    lxappearance
    bluez-tools
    font-awesome
    nerd-fonts.jetbrains-mono
    cachix
    obsidian
    nordvpn
    herdr

  ];

  environment.sessionVariables = {
    # Forces Qt apps to use wayland
    QT_QPA_PLATFORM = "wayland;xcb";

    # Fixes pixelation/blur in Qt apps by letting them handle fractional scaling natively
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";

    # Forces GTK apps to use wayland
    GDK_BACKEND = "wayland,x11";

    # Fixes blank screens/pixelation in Java GUI apps (like like Burp.)
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # font setting:
  fonts = {
    packages = with pkgs; [
      inter
      proggyfonts
      material-design-icons
      material-icons
      corefonts
      powerline

    ];
    fontDir.enable = true;
    fontconfig.defaultFonts = {
      monospace = [ "Iosevka Semibold" ];
      serif = [ "Iosevka Nerd Font Mono" ];
    };
  };

  # systemd units:
  systemd.user.services = {
    dsh-web = {
      description = "DeepSeek Harness web service";
      after = [
        "network.target"
        "systemd-tmpfiles-setup.service"
      ];
      wantedBy = [ "multi-user.target" ];
      # environment = {
      #   # DSH_HOME = "/home/tr3n/tmp/";
      # };
      path = [
        pkgs.deepseek-harness
      ];

      serviceConfig = {
        ExecStart = "${pkgs.deepseek-harness}/bin/dsh --profile web --no-open";
        Restart = "on-failure";
        RestartSec = "5s";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };

  nix = {
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Daemon settings (written to /etc/nix/nix.conf)
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      warn-dirty = false;

      keep-going = true;

      auto-optimise-store = true;
      flake-registry = "";
      tarball-ttl = 604800; # 7 days in seconds

      substituters = [
        # "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # misc etc:
  # environment.etc."ly/blackhole.dur".source = ../../dots/blackhole.dur;
  system.stateVersion = "26.11";
}
