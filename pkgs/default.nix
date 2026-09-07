# packages
{
  pkgs,
  ...
}:

{
  imports = [
    # General programs
    ./utils.nix

    # Development
    ./dev.nix

    # misc (?)
    ./misc.nix

  ];

  environment.systemPackages = [
    (pkgs.callPackage ./apps/neovide.nix { })
    (pkgs.callPackage ./apps/silverbullet.nix { })
    (pkgs.callPackage ./apps/silverbullet-desktop.nix { })

    (pkgs.callPackage ./cli/herdr.nix { })
    (pkgs.callPackage ./cli/tsgo.nix { })

  ];

}
