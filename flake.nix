{
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    high-tide-repo = {
      url = "github:Nokse22/high-tide";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    ulauncher6 = {
      url = "github:Ulauncher/Ulauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    antigravity-nix = {
      url = "github:mingww64/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    vscode-server,
    high-tide-repo,
    nur,
    ulauncher6,
    antigravity-nix,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        nur.modules.nixos.default
        vscode-server.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
        }

        ({
          config,
          pkgs,
          ...
        }: {
          services.vscode-server.enable = true;
          services.vscode-server.enableFHS = true;

          # Use the package directly from the repo's outputs.
          # This ensures it uses its own nixpkgs-unstable and Adw 1.6+
          environment.systemPackages = [
            high-tide-repo.packages.${system}.high-tide
            antigravity-nix.packages.${system}.google-antigravity-no-fhs
            (ulauncher6.packages.${system}.ulauncher6.overrideAttrs (oldAttrs: {
              propagatedBuildInputs =
                (oldAttrs.propagatedBuildInputs or [])
                ++ [
                  pkgs.python3Packages.dbus-python
                  pkgs.python3Packages.xdg
                  pkgs.python3Packages.fuzzywuzzy
                ];
            }))
          ];
        })

        ./configuration.nix
      ];
    };
  };
}
