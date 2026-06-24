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

    # Mod spotify.
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # https://github.com/thiagokokada/nix-alien
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
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

    # nvim
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Nix Gaming for Steam platformOptimizations
    # https://github.com/fufexan/nix-gaming
    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-snapd = {
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland:
    hyprland.url = "github:hyprwm/Hyprland";

    # Quickshell:
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # languages I want to have everywhere:
    go-overlay = {
      url = "github:purpleclay/go-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DMS:
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nix-ld,
      home-manager,
      flake-parts,
      spicetify-nix,
      nixos-hardware,
      nix-gaming,
      burpsuitepro,
      neovim-nightly-overlay,
      nix-snapd,
      hyprland,
      go-overlay,
      quickshell,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";

      # Factor out the common bits of a nixosSystem invocation so each host is a one-liner.
      mkHost =
        hostName: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager

            {
              imports = [ inputs.home-manager.nixosModules.home-manager ];
              networking.hostName = hostName;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.tr3n = import ./home/home.nix;
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
                  overlays = [ ];
                };
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        # per-host config:
        thinkpad = mkHost "thinkpad" [
          spicetify-nix.nixosModules.spicetify
          nix-snapd.nixosModules.default
          nix-ld.nixosModules.nix-ld
        ];

        # INFO: you can also waste more time by adding more hosts!
      };

    };
}
