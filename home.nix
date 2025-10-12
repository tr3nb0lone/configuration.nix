{ config, inputs, lib, pkgs, ... }:

# dotfiles mania
let
  dotfiles = "${config.home.homeDirectory}/dotfiles.nix/config";
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
	userName = "tr3nb0lone";
	userEmail = "tr3nacetate@proton.me";
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


programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
  };

programs.zsh = {
  enable = true;
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "thefuck" ];
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
	rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles.nix#NIX";
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

    theme = {
      name = "Adwaita-Dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

# Font - yea, Google had it's way into my PC:
fonts.fontconfig.enable = true;

home.packages = with pkgs; [
	ripgrep
	nodejs
	gcc
	bun
	zsh
	thefuck
	oh-my-zsh
	lazygit
	lazydocker
	gopls
	handbrake
	material-design-icons
	google-fonts
        # (google-fonts.override { fonts = [ "Google Sans Code" ]; })

  ];
}
