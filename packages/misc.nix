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

    # Libs
    libx11
    xorg.libX11
    xorg.libX11.dev
    xorg.xhost
    pkg-config
    libxcursor
    libxxf86vm
    libxrandr
    libxinerama
    libxi
    glfw
    glfw2

  ];
}
