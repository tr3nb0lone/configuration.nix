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

    # (pkgs.callPackage ./packages/obsidian.nix { })
    # (pkgs.callPackage ./packages/balena-etcher.nix { })
    #    (pkgs.callPackage ./apps/neovide.nix { })

  ];

}
