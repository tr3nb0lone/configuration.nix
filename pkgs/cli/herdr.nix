{ pkgs, fetchUrl }:

let
  pname = "herdr-linux";
  name = "herdr";
  version = "0.7.1";
  src = fetchUrl {
    url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/${pname}-x86_64";
    hash = "THSIISNOTAHASH";

  };

in
pkgs.makeWrapper {
  name = name;
  src = src;
  buildInputs = [ pkgs.glibc ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${name}
    chmod +x $out/bin/${name}
  '';
}
