{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # a big list of unsorted packages I use:
    netcat-gnu
    file
    xclip
    wl-clipboard-x11
    gparted
    tree
    wget
    zip
    unzip
    unrar
    p7zip
    kdePackages.okular
    xfce.xfwm4
    htop
    btop
    fastfetch
    lsb-release
    socat
    rlwrap
    dfc
    dig
    host
    zsh
    openvpn
    macchanger
    brightnessctl
    soapui
    ghex
    jq
    ntp
    redis
    imagemagick
    strace
    clamav
    lsd
    bat
    man
    less
    grc
    libvncserver
    lshw
    lshw-gui
    helvum
    psmisc
    aha
    pciutils
    clinfo
    mesa-demos # replacement for glxinfo
    vulkan-tools
    acpi
    xdg-utils
    inetutils
    wirelesstools
    airgeddon
    aircrack-ng
    libfaketime
    wireguard-tools
    wol
    e2fsprogs
    tldr
    sshpass
    lm_sensors
    libnotify
    zenity
    restic
    rsync
    handbrake
    qdirstat
    lsof
    firefox-bin
    exegol
    
    # remote-access
    openssh
    freerdp
    rdesktop
    remmina

  ];
}
