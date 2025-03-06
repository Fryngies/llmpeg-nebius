{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, self }:
    let forEachSystem = f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: f nixpkgs.legacyPackages.${system});
    in {
      packages = forEachSystem
        (pkgs: {
          default = pkgs.stdenv.mkDerivation
            {
              pname = "llmpeg";
              version = "0.0.0";
              src = ./llmpeg;
              dontUnpack = true;
              buildInputs = with pkgs; [
                curl
                ffmpeg-full
              ];
              nativeBuildInputs = with pkgs; [ makeWrapper ];
              installPhase = ''
                mkdir -p $out/bin
                install -D $src $out/bin/llmpeg
                wrapProgram $out/bin/llmpeg --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.curl pkgs.ffmpeg-full]} --run 'export NEBIUS_API_KEY="$(cat $NEBIUS_API_KEY_PATH)"'
              '';
              NEBIUS_API_KEY_PATH = "";
            };
        });

      overlays.default = final: prev: {
        llmpeg-nebius = self.packages.${prev.system}.default;
      };
    };
}


