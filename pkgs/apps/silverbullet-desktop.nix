{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
}:

let
  pname = "silverbullet-desktop";
  version = "2.12.1";

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "SilverBullet Desktop";
    genericName = "SilverBullet desktop client";
    exec = pname;
    categories = [
      "Office"
      "Network"
    ];
  };

  src = fetchurl {
    url = "https://release.silverbullet.md/electron/artifacts/2.12.1/linux/x64/SilverBullet-${version}-linux-x86_64.AppImage";
    hash = "sha256-GtiLG6cnZIwwMGjINYEzboCTi+0weUX7zvrtmgA7y4c=";
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/${pname}.desktop \
      $out/share/applications/${pname}.desktop
  '';

  meta = with lib; {
    description = "SilverBullet desktop client";
    homepage = "https://silverbullet.md";
    license = licenses.mit;
    maintainers = with maintainers; [ aorith ];
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
