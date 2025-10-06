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
    tmux = "tmux";
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
 ];
}
