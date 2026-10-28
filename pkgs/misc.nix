{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Wine:
    # winetricks
    # wineWow64Packages.stable
    geekbench
    iproute2

    # Virtualization
    spice-vdagent
    spice-autorandr
    virtio-win # replacement of win-virtio
    dnsmasq # VM networking
    phodav # (optional) Share files with guest VMs
    bottles
    lutris
    gnome-boxes # VM management

    # misc-y misc
    # ffmpeg
    evil-winrm
    netexec
    hashcat
    ffuf

  ];
}
