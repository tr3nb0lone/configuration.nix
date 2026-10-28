{
  lib,
  appimageTools,
  makeDesktopItem,
  fetchurl,
}:

let
  pname = "github-copilot";
  version = "1.1.26";

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "GitHub-Copilot";
    genericName = "GitHub-Copilot";
    exec = pname;
    categories = [
      "Office"
      "Network"
    ];
  };
  src = fetchurl {
    url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-x64.AppImage";
    hash = "sha256-Ga6ZqY128t1PGPubUSGpiZL06CxrXYjNi6c1boET1zo=";
  };

in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/${pname}.desktop \
      $out/share/applications/${pname}.desktop
  '';

  profile = ''
    export GDK_BACKEND="''${GDK_BACKEND:-wayland}"
    export WEBKIT_DISABLE_DMABUF_RENDERER="''${WEBKIT_DISABLE_DMABUF_RENDERER:-0}"
  '';

  meta = {
    description = "GitHub Copilot desktop application";
    homepage = "https://github.com/github/app";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "GitHub-Copilot";
  };
}
