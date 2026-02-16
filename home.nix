{ config, inputs, pkgs, ... }:

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
    picom = "picom";
    # direnv = "direnv";
    yazi = "yazi";
    sesh = "sesh";
    # tmux = "tmux";
    dunst = "dunst";
    polybar = "polybar";
  };
in
{
    home.username = "tr3n";
    home.homeDirectory = "/home/tr3n";
    home.stateVersion = "25.05";

# Git.config
programs.git = {
	enable = true;
	settings.user.name = "tr3nb0lone";
	settings.user.email = "tr3nacetate@proton.me";
  };

# tmux:
programs.tmux = {
	enable = true;
	plugins = with pkgs;
      [
        tmuxPlugins.tmux-fzf
        tmuxPlugins.sensible
        tmuxPlugins.resurrect
        tmuxPlugins.logging
        tmuxPlugins.continuum
        tmuxPlugins.rose-pine
      ];
	extraConfig = ''
	# set a better limit
	set -g history-limit 50000

	# remap prefix from 'C-b' to 'C-a'
        set -g prefix C-a	
	set-option -g default-command $SHELL

	# Mouse!??
	set-option -g mouse on

	# Custom remaps:
	bind-key K kill-session

	# switch panes using Alt-arrow without prefix
	bind -n M-h  select-pane -L
	bind -n M-l select-pane -R
	bind -n M-k    select-pane -U
	bind -n M-j  select-pane -D

	# Switch sessions effortlessly:
	bind-key -n 'M-]' switch-client -n
	bind-key -n 'M-[' switch-client -p
	
	# effortlessly reload config (might be useless as a result of HM)
	bind r source-file ~/.tmux.conf \; display "Config reloaded!"

	# General
	setw -g mode-keys vi
	set-option -g allow-rename off
	set -g base-index 1
	set -g pane-active-border-style fg="blue"

	# status customization:
	set -g status-justify absolute-centre
	set -g status-style "bg=default"
	set -g window-status-current-style "fg=black bg=white  "
	set -g status-interval 5
	set -g status-left "#S"
	set -g status-right ""
	set -g renumber-windows on
	set -g status-left-length 76 # could be any number :)

	# Base16 Black Metal
	# Scheme author: metalelf0 (https://github.com/metalelf0)
	# Template author: Tinted Theming: (https://github.com/tinted-theming)

	# default statusbar colors
	set-option -g status-style "fg=#999999,bg=#121212"

	# default window title colors
	set-window-option -g window-status-style "fg=#999999,bg=#121212"

	# active window title colors
	set-window-option -g window-status-current-style "fg=#a06666,bg=#121212"

	# pane border
	set-option -g pane-border-style "fg=#121212"
	set-option -g pane-active-border-style "fg=#999999"

	# message text
	set-option -g message-style "fg=#999999,bg=#222222"

	# pane number display
	set-option -g display-panes-active-colour "#999999"
	set-option -g display-panes-colour "#121212"

	# copy mode highlight
	set-window-option -g mode-style "fg=#999999,bg=#222222"

	# bell
	set-window-option -g window-status-bell-style "fg=#000000,bg=#5f8787"

	# style for window titles with activity
	set-window-option -g window-status-activity-style "fg=#c1c1c1,bg=#121212"

	# style for command messages
	set-option -g message-command-style "fg=#999999,bg=#222222"

	# Source extra config(s)
	source-file ~/configuration.nix/config/tmux/extra.conf
	'';
  };

programs.fzf = {
	enable = true;
	enableZshIntegration = true;
   };

programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
  };

programs.yazi = {
	enable = true;
	enableZshIntegration = true;
 };

programs.zsh = {
  enable = true;
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "fzf" "direnv" ];
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

  # Home path:
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.opencode/bin"
  ];

xdg.autostart.enable = true;
xdg.configFile = builtins.mapAttrs (name: subpath: {
		source = create_symlink "${dotfiles}/${subpath}";
		recursive = true;
	})
	configs;
   
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
# Direnv:
programs.direnv = {
	enable = true;
	nix-direnv.enable = true;
	enableZshIntegration = true;
};

# Favourite password manager:
programs.keepassxc  = {
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

# manage removable media:
services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "always";
};

home.packages = with pkgs; [
	# inputs.joplin-desktop.packages.${system}.default
	ripgrep
	fd
	# nodejs
	# gcc
	# bun
	# deno
	# webkitgtk_6_0
	lazygit
	lazydocker
	# handbrake
	# tor-browser
	material-design-icons
	gnome-themes-extra
	font-awesome
	iosevka
	# hack-font
        nerd-fonts.iosevka
	i3-auto-layout

	# LSPs
	bash-language-server
	lua-language-server
	# typescript-language-server
	# gopls
	nil
	# pyright
	# copilot-language-server

	# opencode

        # misc nvim
	luajitPackages.luarocks-nix
	# gotools
	stylua
  ];
}
