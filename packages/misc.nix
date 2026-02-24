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
    xhost
    pkg-config
    libxrandr
    libxinerama
    libxi
    glfw
    glfw2

  ];
}
