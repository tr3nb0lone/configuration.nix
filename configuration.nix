{ pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages/default.nix
    ];

 hardware.enableAllFirmware = true;
 boot.loader.systemd-boot.enable = true;
 boot.loader.efi.canTouchEfiVariables = true;

  # Clean /tmp on reboot
  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
    tmpfsSize = "300%";
  };

 networking.hostName = "NIX";
 networking.networkmanager.enable = true;

 # Disable NetworkManager's internal DNS resolution
 networking.networkmanager.dns = "none";

 # These options are unnecessary when managing DNS ourselves
 networking.useDHCP = false;
 networking.dhcpcd.enable = false;

 # Configure DNS servers manually (Cloudflare and Google DNS)
 networking.nameservers = [
   "1.1.1.1"
   "8.8.8.8"
];

 # YAY! you now know where I live.
 time.timeZone = "Africa/Addis_Ababa";
 
 # get paid and unsupported packages
 nixpkgs.config.allowUnfree = true;
 nixpkgs.config.allowUnsupportedSystem = true;
 nixpkgs.config.microsoftVisualStudioLicenseAccepted = true;

# get `deprecated / insecure / unmaintained` packages:
 nixpkgs.config.permittedInsecurePackages = [ "python-2.7.18.8" "python-2.7.18.12"];

# Display manager:
services.displayManager.cosmic-greeter.enable = true;

services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.i3.enable = true;
    desktopManager.xfce.enable = true;
    displayManager.startx.enable = true;
};


 # Configure keymap(s) in X11
 services.xserver.xkb.layout = "us";
 services.xserver.xkb.options = "eurosign:e,caps:escape";


# Enable sound with pipewire.
services.pulseaudio.enable = false;
services.pipewire = {
       enable = true;
       jack.enable = true;
       pulse.enable = true;
       alsa.enable = true;
       alsa.support32Bit = true;
  };
 
  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Enable touchpad
  services.libinput.enable = true;

 # User config:
 users.users.tr3n = {
   isNormalUser = true;
   extraGroups = [ "wheel" "libvirtd" "podman" ];
   packages = with pkgs; [
     tree
   ];
 };

 # I'm forced to use Zsh - thanks NixOS:
 users.defaultUserShell = pkgs.zsh;
 programs.zsh.enable = true;
 programs.zsh.shellInit = ''
        eval "$(zoxide init zsh)"
	eval "$(fzf --zsh)"
	eval "$(direnv hook zsh)"
	bindkey -s ^f "sessionizer.sh\n"
 '';

# Enable common container config files in /etc/containers
virtualisation.containers.enable = true;
virtualisation = {
  podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;
    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };
};

  # Docker:
virtualisation.docker = {
  # Consider disabling the system wide Docker daemon, prevent easy privesc dummy.
  enable = false;
  rootless = {
    enable = true;
    setSocketVariable = true;
    # Optionally customize rootless Docker daemon settings
    daemon.settings = {
      dns = [ "1.1.1.1" "8.8.8.8" ];
    };
  };
};
  # auto-mount and external disk management:
  services.udisks2.enable = true;

  # https://blog.kaorubb.org/en/posts/nixos-fix-could-not-start-dynamically-linked-executable/
  # programs.nix-ld.enable = true; # might be useless as of now

  # Virtualization:
 virtualisation.libvirtd = { enable = true; };

  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

   # Allow VM management
   users.groups.libvirtd.members = [ "tr3n" ];
   users.groups.kvm.members = [ "tr3n" ];


  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
environment.systemPackages = with pkgs; [
	  neovim
	  kitty
	  rofi
	  tmux
	  polybar
	  ayugram-desktop
	  vesktop 
	  keepassxc
	  arandr
	  networkmanagerapplet
	  feh
	  flameshot
	  picom
	  thunar
	  # obs-studio
	  chromium
	  vlc
	  pavucontrol
	  pulseaudio
	  dunst
	  bluez
	  lxappearance
	  bluez-tools
	  font-awesome
          nerd-fonts.jetbrains-mono
  	 #       virtio-win # replacement of win-virtio
  	 # gnome-boxes # VM management
  	 #      dnsmasq # VM networking
  	 #      phodav # (optional) Share files with guest VMs

];
  # font setting:
  fonts.packages = with pkgs; [
	noto-fonts
	noto-fonts-color-emoji
	inter
	liberation_ttf
	fira-code
	fira-code-symbols
	dina-font
	proggyfonts
	font-awesome_5
	material-design-icons
	material-icons
	corefonts
	powerline
	powerline-fonts
	powerline-symbols
	
];
  fonts.fontDir.enable = true;
  fonts.fontconfig.defaultFonts = {
     monospace = [ "Iosevka Semibold" ];
     serif = [ "Iosevka Nerd Font Mono" ];
     # sansSerif = [ "Noto Sans" ];
};

  # picomm
  services.picom.enable = true;

  # List services that you want to enable:
  services.openssh = {
	enable = true;
	settings.PasswordAuthentication = false;
  };

  nix.settings.experimental-features  = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
  # system.stateVersion = "unstable";

}
