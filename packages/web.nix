{ inputs, pkgs, lib, config, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    httrack
    updog
    inputs.burpsuitepro.packages.${system}.default
    zap
    gobuster
    feroxbuster
    ffuf
    graphqlmap
    sqlmap
    wpscan
    
    # project discovery:
    httpx
    katana
    # nuceli
    interactsh

  ];
}
