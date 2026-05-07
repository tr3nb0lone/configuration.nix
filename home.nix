{
  config,
  inputs,
  pkgs,
  ...
}:

# dotfiles mania
let
  dotfiles = "${config.home.homeDirectory}/configuration.nix/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    i3 = "i3";
    nvim = "nvim";
    neovide = "neovide";
    wezterm = "wezterm";
    i3-autodisplay = "i3-autodisplay";
    rofi = "rofi";
    kitty = "kitty";
    ghostty = "ghostty";
    alacritty = "alacritty";
    picom = "picom";
    yazi = "yazi";
    sesh = "sesh";
    tmux = "tmux";
    dunst = "dunst";
    polybar = "polybar";
    eww = "eww";
  };
in
{
  home.username = "tr3n";
  home.homeDirectory = "/home/tr3n";
  home.stateVersion = "25.05";

  # Git.config
  programs = {
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

    # ewwww:
    eww = {
      enable = true;
      enableZshIntegration = true;
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
      initContent = ''
        			unalias gau gf
        		'';
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
        x = "exit";
        v = "nvim";
        vim = "nvim";
        vide = "neovide . & ;disown";
        z = "zoxide";
        clone = "git clone";

        # nix:
        rebuild = "sudo nixos-rebuild switch --flake ~/configuration.nix#NIX";
        purge = "sudo nix-collect-garbage -d";
        develop = "nix develop -c $SHELL";
        sound = "systemctl --user restart pipewire.service pipewire-pulse.service";

        # tmux
        t = "tmux";
        ta = "tmux a";
        tls = "tmux ls";

        # services:
        dock = "DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock systemctl --user start docker";
      };
    };

    # Favourite password manager:
    keepassxc = {
      enable = true;
      autostart = true;
      settings = {
        GUI = {
          AdvancedSettings = "true";
          ApplicationTheme = "dark";
          MinimizeOnClose = "true";
          ShowTrayIcon = "true";
          TrayIconAppearance = "monochrome-light";
          ConfigVersion = "2";
          MinimizeAfterUnlock = "true";
          CompactMode = "true";
          HidePasswords = "true";
        };
        Browser = {
          Enabled = "true";
          BrowserType = "Firefox";
        };
        SSHAgent.Enabled = false;
      };
    };

    # Direnv:
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      config = builtins.fromTOML ''
        [global]
        log_format = "\u001B[2mdirenv: %s\u001B[0m"
        hide_env_diff = true
      '';
    };

    # nix-index:
    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

    };

  };

  # Home path:
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.opencode/bin"
    "$HOME/flutter/flutter/bin"
    "$HOME/.bun/bin"
  ];

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
    gtk2.extraConfig = ''
      	 gtk-theme-name="Orchis-Purple-Dark"
      	 gtk-icon-theme-name="Papirus-Dark"
      	 gtk-font-name="Iosevka Hard 13"
      	 gtk-cursor-theme-name="Adwaita"
      	 gtk-cursor-theme-size=0
      	 gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
      	 gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      	 gtk-button-images=0
      	 gtk-menu-images=0
      	 gtk-enable-event-sounds=1
      	 gtk-enable-input-feedback-sounds=1
      	 gtk-xft-antialias=1
      	 gtk-xft-hinting=1
      	 gtk-xft-hintstyle="hintmedium"
      	 gtk-xft-rgba="none"
      	'';

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

    gtk4.extraConfig = {
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
  };

  home.packages = with pkgs; [
    inputs.joplin-desktop.packages.${system}.default
    ripgrep
    fd
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

    opencode
    nixfmt

    # misc nvim
    luajitPackages.luarocks-nix
    stylua
  ];
}
