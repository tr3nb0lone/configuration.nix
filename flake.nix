{
    description = "NixOS, a new chapter.";

    inputs = {
    # nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable"; # yea, live life on the edge.

    # Home-Manager:
    home-manager = {
	# HM follows unstable:
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic's Nyx
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

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
      owner = "xiv3r";
      repo = "Burpsuite-Professional";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
    # Red-Flake tools
    tools = {
      url = "github:Red-Flake/tools";
      flake = false;
    };

    # Red-Flake NUR packages
    redflake-packages = {
      type = "github";
      owner = "Red-Flake";
      repo = "packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Gaming for Steam platformOptimizations
    # https://github.com/fufexan/nix-gaming
    nix-gaming.url = "github:fufexan/nix-gaming";

};


outputs = {
	  self, 
	  nixpkgs, 
	  home-manager,
	  chaotic, 
	  flake-parts, 
	  pre-commit-hooks,
	  tools, 
	  poetry2nix, 
	  nixos-hardware, 
	  nix-gaming, 
	  burpsuitepro,
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
            chaoticPkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.chaotic.overlays.default ];
              config.allowUnfree = true;
       };
     };
	modules = [
            ./configuration.nix
	    chaotic.nixosModules.default
            home-manager.nixosModules.home-manager
			    
		    {
              imports = [ inputs.home-manager.nixosModules.home-manager ];
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
