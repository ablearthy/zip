{
  description = "zip";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
	      haskellPackages = pkgs.haskell.packages.ghc965;
        devTools = with pkgs; [
          bashInteractive
          python3
          
          ghc
          fuse3
	        haskellPackages.cabal-install
	        haskellPackages.haskell-language-server
	        haskellPackages.cabal-fmt
	        haskellPackages.fourmolu
        ];
	      packageName = "zip";
      in {
        packages.${packageName} = haskellPackages.callCabal2nix packageName self {};
        devShell = pkgs.mkShell ({
          buildInputs = devTools;
	        inputsFrom = [ self.packages.${system}.${packageName}.env ];
        });
      }
    );
}
