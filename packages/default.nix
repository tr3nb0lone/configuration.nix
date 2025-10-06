# packages

{ inputs, pkgs, lib, config, ... }:

{
  # disable default packages
  # environment.defaultPackages = [];

  imports = [
    # General programs

    # Development 
    ./dev.nix

    # Security	
    ./windows.nix
    ./recon.nix
    ./web.nix

    # misc (?)
    ./utils.nix



  ];
}
