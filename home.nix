{ config, pkgs, ... }:

# dotfiles mania
let
  dotfiles = "${config.home.homeDirectory}/configuration.nix/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    i3 = "i3";
    nvim = "nvim";
    rofi = "rofi";
    kitty = "kitty";
    picom = "picom";
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

	# Kitty + yazi compatibility:
	set -g allow-passthrough on
	set -ga update-environment TERM
	set -ga update-environment TERM_PROGRAM


	'';
  };

programs.fzf = {
	enable = true;
	enableZshIntegration = true;
   };

programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
  };

programs.yazi = {
	enable = true;
	enableZshIntegration = true;
 };

programs.zsh = {
  enable = true;
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "fzf" ];
    theme = "robbyrussell";
  };
  history.size = 50000;

shellAliases = {
	# general:
	c = "clear";
	x = "exit";
	v = "nvim";
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

xdg.configFile = builtins.mapAttrs (name: subpath: {
		source = create_symlink "${dotfiles}/${subpath}";
		recursive = true;
	})
	configs;
   
# Theming:
gtk = {
    enable = true;
      iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk2.extraConfig = ''
	 gtk-theme-name="Orchis-Purple-Dark"
	 gtk-icon-theme-name="Papirus-Dark"
	 gtk-font-name="Google Sans Code Medium 12"
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


# manage removable media:
services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "always";
};

home.packages = with pkgs; [
	ripgrep
	nodejs
	gcc
	bun
	lazygit
	lazydocker
	handbrake
	material-design-icons
	gnome-themes-extra
	font-awesome

  ];
}
