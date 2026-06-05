{
  pkgs,
  fetchurl,
}:

let
  pname = "silverbullet-plus";
  version = "2.9.1";

  src = fetchurl {
    url = "https://releases.silverbullet.plus/releases/2.8.1/SilverBullet_x86_64.AppImage";
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
