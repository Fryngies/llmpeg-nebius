{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, self }:
    let
      forEachSystem = f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forEachSystem
        (pkgs:
          let
            default = pkgs.stdenv.mkDerivation {
              pname = "llmpeg";
              version = "0.0.0";
              src = ./llmpeg;
              dontUnpack = true;
              nativeBuildInputs = [ ];
              buildInputs = with pkgs; [
                curl
                ffmpeg-full
              ];
              installPhase = ''
                mkdir -p $out/bin
                install -D $src $out/bin/llmpeg
              '';
              passthru = { inherit withApiKey; };
            };

            withApiKey = keyPath: default.overrideAttrs (prev: {
              nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.makeWrapper ];
              postFixup = ''
                wrapProgram $out/bin/llmpeg \
                  --run 'export NEBIUS_API_KEY="$(cat ${keyPath})"'
              '';
            });
          in
          { inherit default; });

      overlays.default = final: prev: {
        llmpeg-nebius = self.packages.${prev.system}.default;
      };
    };
}


