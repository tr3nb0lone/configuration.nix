{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "github-copilot";
  version = "1.1.26";

  src = fetchurl {
    url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-x64.AppImage";
    hash = lib.fakehash;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  meta = {
    description = "GitHub Copilot desktop application";
    homepage = "https://github.com/github/app";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "GitHub-Copilot";
  };
}
