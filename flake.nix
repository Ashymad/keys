{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (name: f name);
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      authorizedKeys = pkgs.fetchurl {
        url = "https://meta.sr.ht/~ashymad.keys";

        downloadToTemp = true;
        postFetch = ''sort < "$downloadedFile" > "$out"'';

        hash = "sha256-g5Gjrsah6EArtJIMVcCb+/Hb7CAjyToBmXlFx+yNpQ8=";
      };
    });
  };
}
