{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../pkgs/default.nix
    inputs.dms.nixosModules.dank-material-shell
  ];

  hardware.enableAllFirmware = true;
  xdg.portal.enable = true;

  boot = {
    #    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
    #    extraModulePackages = with config.boot.kernelPackages; [
    #      rtw88
    #    ];
    #    blacklistedKernelModules = [
    #      "rtw88_8821ce"
    #    ];
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
    initrd.verbose = false;
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

  # Nnetworking:
  networking = {
    networkmanager.enable = true;

    # Disable NetworkManager's internal DNS resolution
    networkmanager.dns = "none";

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
    ];
    extraHosts = ''
      192.168.122.44 		KALI
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
    # inputs.nix-cachyos-kernel.overlays.pinned
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
        # insecure-registries = "";
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

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

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
    dms-shell = {
      enable = true;

      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      # Core features
      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;
    };

    # misc-programs:
    kdeconnect.enable = true;
    nm-applet.enable = true;
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

    # snap:
    snap.enable = true;

    # enable fingerprint
    fprintd.enable = false;

    # picom
    picom.enable = true;

    blueman = {
      enable = true;
      # withApplet = true;
    };

    # Enable touchpad
    libinput.enable = true;

    # auto-mount and external disk management:
    udisks2.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    # Display manager:
    displayManager.ly.enable = true;

    # misc virtualization
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;

    # Tailscale
    tailscale = {
      # Enable tailscale at startup
      enable = false;
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
    #    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
    inputs.burpsuitepro.packages.${system}.default

    neovim
    kitty
    rofi
    tmux
    polybar
    ayugram-desktop
    vesktop
    keepassxc
    arandr
    feh
    flameshot
    picom
    thunar
    #    obs-studio
    #    chromium
    #    vlc
    pavucontrol
    pulseaudio
    dunst
    bluez
    lxappearance
    bluez-tools
    font-awesome
    nerd-fonts.jetbrains-mono
    cachix

  ];

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

  nix = {
    channel.enable = false;

    # High-level NixOS definitions (evaluated by modules)
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Daemon settings (written to /etc/nix/nix.conf)
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      warn-dirty = false;

      auto-optimise-store = true;
      flake-registry = "";
      tarball-ttl = 604800; # 7 days in seconds

      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
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

  system.stateVersion = "26.05";
}
