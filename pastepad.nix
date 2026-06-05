{ pkgs, ... }:
{

  nixosConfigurations = {
    # Config for my main host:
    NIX = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs outputs;
      };
      # modules = [
      #   ./configuration.nix
      #   home-manager.nixosModules.home-manager
      #   spicetify-nix.nixosModules.spicetify
      #   nix-snapd.nixosModules.default
      #
      #   nix-ld.nixosModules.nix-ld
      #   { programs.nix-ld.dev.enable = true; }
      #   {
      #     # imports = [ inputs.home-manager.nixosModules.home-manager ];
      #     # home-manager = {
      #     #   useGlobalPkgs = true;
      #     #   useUserPackages = true;
      #     #   users.tr3n = import ./home.nix;
      #     #   backupFileExtension = "backup";
      #     # };
      #     # home-manager.extraSpecialArgs = {
      #     #   inherit inputs;
      #     #   user = "tr3n";
      #     #   pkgs = import inputs.nixpkgs {
      #     #     system = "x86_64-linux";
      #     #     config.allowUnfree = true;
      #     #     config.allowBroken = true;
      #     #     config.allowUnsupportedSystem = true;
      #     #     overlays = [ ];
      #     #   };
      #     # };
      #   }
      # ];
    };
  };
}
