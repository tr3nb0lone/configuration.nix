{
  description = "NixOS, a new chapter.";

  inputs = {
    # nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Home-Manager:
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-ld:
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    # get the CachyOS kernel
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      # Do not override its nixpkgs input, otherwise there can be mismatch between patches and kernel version
    };

    # Modules support for flakes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Have a local index of nixpkgs for fast launching of apps
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Easy linting of the flake and all kind of other stuff
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    # Mod spotify.
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # https://github.com/thiagokokada/nix-alien
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/poetry2nix
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # https://github.com/xiv3r/Burpsuite-Professional
    burpsuitepro = {
      type = "github";
      owner = "tr3nb0lone";
      repo = "Burp-Professional";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Joplin:
    joplin-desktop = {
      type = "github";
      owner = "tr3nb0lone";
      repo = "joplin-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvim
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Gaming for Steam platformOptimizations
    # https://github.com/fufexan/nix-gaming
    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-snapd = {
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland:
    hyprland.url = "github:hyprwm/Hyprland";

  };

  outputs =
    {
      self,
      nixpkgs,
      nix-ld,
      home-manager,
      flake-parts,
      pre-commit-hooks,
      spicetify-nix,
      poetry2nix,
      nixos-hardware,
      nix-gaming,
      burpsuitepro,
      joplin-desktop,
      neovim-nightly-overlay,
      nix-snapd,
      hyprland,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in
    {

      nixosConfigurations = {
        # Config for my main host:
        NIX = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            spicetify-nix.nixosModules.spicetify
            nix-snapd.nixosModules.default

            nix-ld.nixosModules.nix-ld
            { programs.nix-ld.dev.enable = true; }
            {
              imports = [
                inputs.home-manager.nixosModules.home-manager
              ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.tr3n = import ./home.nix;
                backupFileExtension = "backup";
              };
              home-manager.extraSpecialArgs = {
                inherit inputs;
                user = "tr3n";
                pkgs = import inputs.nixpkgs {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                  config.allowBroken = true;
                  config.allowUnsupportedSystem = true;
                  overlays = [
                    # impacket overlay
                    # (import nixos/overlays/impacket-overlay)
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
