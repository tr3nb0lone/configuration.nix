{ inputs, pkgs, lib, config, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # a big list of unsorted packages I use:
    netcat-gnu
    file
    gparted
    tree
    wget
    zip
    unzip
    unrar
    p7zip
    kdePackages.okular
    htop
    btop
    fastfetch
    lsb-release
    socat
    rlwrap
    dfc
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
    glxinfo
    vulkan-tools
    acpi
    inetutils
    libfaketime
    wireguard-tools
    wol
    e2fsprogs
    tldr
    sshpass
    python312Packages.pyhanko
    lm_sensors
    libnotify
    zenity
    restic
    rsync
    handbrake
    lsof
    firefox-bin
    
    # remote-access
    # evil-winrm-patched
    openssh
    freerdp3
    rdesktop
    remmina


  ];
}
