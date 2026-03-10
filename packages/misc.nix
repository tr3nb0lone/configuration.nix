{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # Wine:
    wineWowPackages.stable
    winetricks
    bottles
    lutris
    geekbench

evil-winrm
evil-winrm-py
    iproute2

    # Libs
    libx11
    xhost
    pkg-config
    libxrandr
    libxinerama
    libxi
    glfw
    glfw2

  # Virtualization
  spice-vdagent
  spice-autorandr
  virtio-win # replacement of win-virtio
  gnome-boxes # VM management
  dnsmasq # VM networking
  phodav # (optional) Share files with guest VMs

  ];
}
