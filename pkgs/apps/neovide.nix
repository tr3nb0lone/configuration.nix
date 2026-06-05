{
  pkgs,
  fetchurl,
}:

let
  pname = "neovide";
  version = "nightly";

  src = fetchurl {
    url = "https://github.com/neovide/neovide/releases/download/nightly/neovide.AppImage";
    hash = "sha256-SZr3sAqVWeC6GX6Dpn6Tov0GZRLMuGiLjEen9OVXJ5I=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.svg \
      $out/share/icons/hicolor/512x512/apps/${pname}.svg
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';
}
