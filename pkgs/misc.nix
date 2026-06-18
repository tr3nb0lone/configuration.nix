{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Wine:
#   wineWowPackages.stable
#   winetricks
#   bottles
#   lutris
#   geekbench
    iproute2

    # Virtualization
    spice-vdagent
    spice-autorandr
#    virtio-win # replacement of win-virtio
#    gnome-boxes # VM management
    dnsmasq # VM networking
    phodav # (optional) Share files with guest VMs

    # misc-y misc
    ffmpeg_7-full

  ];
}
