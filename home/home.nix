{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

# dotfiles mania
let
  dotfiles = "${config.home.homeDirectory}/configuration.nix/dots";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    i3 = "i3";
    nvim = "nvim";
    wezterm = "wezterm";
    i3-autodisplay = "i3-autodisplay";
    rofi = "rofi";
    kitty = "kitty";
    ghostty = "ghostty";
    alacritty = "alacritty";
    picom = "picom";
    hypr = "hypr";
    yazi = "yazi";
    tmux = "tmux";
    dunst = "dunst";
    waybar = "waybar";
    neovide = "neovide";
    polybar = "polybar";
    quickshell = "quickshell";
  };
in
{
  imports = [ inputs.burpsuite-nix.homeManagerModules.default ];
  home.username = "tr3n";
  home.homeDirectory = "/home/tr3n";
  home.stateVersion = "25.05";

  # Git.config
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
    };

    git = {
      enable = true;
      settings.user.name = "tr3nb0lone";
      settings.user.email = "tr3nacetate@proton.me";
      settings.url = {
        "ssh://git@github.com/tr3nb0lone/*" = {
          insteadOf = "https://github.com/tr3nb0lone/*";
        };
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      initContent = "unalias gau gf ";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "fzf"
          "direnv"
        ];
        theme = "fwalch";
      };
      history.size = 50000;

      shellAliases = {
        # general:
        c = "clear";
        cat = "bat";
        x = "exit";
        v = "nvim";
        lg = "lazygit";
        vim = "nvim";
        nano = "nvim";
        vide = "neovide . & ;disown";
        z = "zoxide";
        j = "just";
        clone = "git clone";

        # tmux / herdr:
        t = "tmux";
        ta = "tmux a";
        tls = "tmux ls";

        h = "herdr";
        hls = "herdr workspace list";

        # services:
        dock = "DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock systemctl --user start docker";
        sound = "systemctl --user restart pipewire.service pipewire-pulse.service";

        # misc
        develop = "nix develop -c $SHELL";
        kssh = "kitten ssh ";

      };
    };

    # Favourite password manager:
    keepassxc = {
      enable = true;
      # autostart = true;
      settings = {
        # GUI = {
        #   AdvancedSettings = "true";
        #   ApplicationTheme = "dark";
        #   MinimizeOnClose = "true";
        #   ShowTrayIcon = "true";
        #   TrayIconAppearance = "monochrome-light";
        #   ConfigVersion = "2";
        #   MinimizeAfterUnlock = "true";
        #   CompactMode = "true";
        #   HidePasswords = "true";
        # };
        # Browser = {
        #   Enabled = "true";
        #   BrowserType = "Firefox";
        # };
      };
    };

    # nix-index:
    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

    };

    burp = {
      enable = true;
      # proEdition = true; # just refuses to work!
      enableJython = true;
      package = pkgs.callPackage ../pkgs/apps/burpsuite.nix { };

      wordlists = {
        seclists = "${pkgs.seclists}/share/wordlists/seclists";
      };

      cliArgs = [
        "--i-accept-the-license-agreement"
        "--disable-auto-update"
        "--disable-check-for-updates-dialog"
        "--suppress-jre-check"
        "--temporary-project"
      ];

      extensions = {
        # Loaded by default
        "403-bypasser".enable = true;
        "json-web-tokens".enable = true;
        "js-miner".enable = true;
        "param-miner".enable = true;

        # custom extension(s)
        # Just fetch the JAR directly - no derivation needed!
        "HopLa" = {
          enable = true;
          loaded = true;
          package = pkgs.fetchurl {
            url = "https://github.com/synacktiv/HopLa/releases/download/v2.2.0/HopLa.jar";
            hash = "sha256-kD4QEA8HcodITdEBf+B+OgIarLG0WSqog6G0ezIPeMg";
          };
          extensiontype = "1";
        };

        # "JSAnalyzer" = {
        #   enable = true;
        #   loaded = true;
        #   package = builtins.fetchGit {
        #     name = "https://github.com/jenish-sojitra/JSAnalyzer.git";
        #     ref = "master";
        #     rev = "55039799ae31fce1b87443b649de7863e18b53df";
        #   };
        #   extensiontype = "1";
        # };

        "burp-ai-agent" = {
          enable = true;
          loaded = true;
          package = pkgs.fetchurl {
            url = "https://github.com/six2dez/burp-ai-agent/releases/download/v0.9.0/Custom-AI-Agent-full-0.9.0.jar";
            hash = "sha256-zYzndz9N7uY6lYCF4cxfzToQKgYTIKNNOrL/HNjAF/s=";
          };
          extensiontype = "1";
        };

        "jxscout-burp" = {
          enable = true;
          loaded = false;
          package = pkgs.fetchurl {
            url = "https://github.com/francisconeves97/jxscout-burp/releases/download/v1.2.0/jxscout-1.2.0.jar";
            hash = "sha256-Q+FwRcbAn48N1oyS4n7WJAPntiVtYtB3AeW23Gmn9Z0=";
          };
          extensiontype = "1";
        };
      };

      # Settings that are deep-merged into the default config
      settings = {
        display.user_interface = {
          look_and_feel = "Dark";
          font_size = 18;
        };
      };
    };

  };

  # Burp 2026.x fails to initialize top-level tools with the fully generated
  # UserConfig.json from burpsuite-nix. Let Burp manage this file itself.
  # home.file.".BurpSuite/UserConfig.json".enable = lib.mkForce false;

  # Home path:
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.opencode/bin"
    "$HOME/flutter/flutter/bin"
    "$HOME/.bun/bin"
  ];

  # env:
  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    EDITOR = "nvim";
    XCURSOR_THEME = "Adwaita";
    MOZ_ENABLE_WAYLAND = 1;
  };

  xdg.autostart.enable = true;
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  # QT
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "gtk3";

  };

  # Theming:
  gtk = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font Mono";
      package = pkgs.iosevka;
      size = 13;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk2 = {
      font = {
        name = "Iosevka Nerd Font Mono";
        package = pkgs.iosevka;
        size = 13;
      };
    };

    theme = {
      name = "Orchis-Purple-Dark";
      package = pkgs.orchis-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
                gtk-application-prefer-dark-theme=1
        	gtk-theme-name="Orchis-Purple-Dark"
      '';
    };
  };

  services = {
    # manage removable media:
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "always";
    };

    kdeconnect = {
      enable = true;
      indicator = true;
    };

  };
  # MISC
  # wayland.windowManager.hyprland.systemd.enable = false;
  home.packages = with pkgs; [
    ripgrep
    fd
    cloc
    nodejs
    gcc
    deno
    lazygit
    lazydocker
    handbrake
    tor-browser
    material-design-icons
    gnome-themes-extra
    font-awesome
    iosevka
    hack-font
    nerd-fonts.iosevka
    i3-auto-layout

    # LSPs
    bash-language-server
    lua-language-server
    markdown-oxide
    nil
    vscode-json-languageserver
    rust-analyzer

    nixfmt

    # misc nvim
    luajitPackages.luarocks-nix
    stylua

    # wl
    hyprpaper
    hyprlock
    hyprshell
    hyprpanel
    wl-clipboard
    fuzzel
    waybar
    grim
    swappy
    slurp
    swappy
    woomer

  ];
}
