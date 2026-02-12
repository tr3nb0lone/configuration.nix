# packages

{ inputs, pkgs, lib, config, ... }:

{
  imports = [
    # General programs
    ./utils.nix

    # Development 
    # ./dev.nix

    # Security	
    ./windows.nix
    ./recon.nix
    ./web.nix

    # misc (?)
    ./misc.nix

  ];
}
