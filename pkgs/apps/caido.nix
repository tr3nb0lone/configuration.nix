{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  writeShellApplication,
  ungoogled-chromium,
  libgcc,
  zlib,
}:

let
  caidoIcon = fetchurl {
    url = "https://avatars.githubusercontent.com/u/78991750?s=200";
    hash = "sha256-vi18snnKUcbWw3KcT/c+oAkPwgtx0F6U93yD6mT+p64=";
  };
  caidoUi = writeShellApplication {
    name = "caido-ui";
    runtimeInputs = [ ungoogled-chromium ];
    text = ''
      DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/caido-ui"
      mkdir -p "$DATA_DIR"

      exec chromium \
        --app="http://127.0.0.1:8080" \
        --user-data-dir="$DATA_DIR" \
        --class="caido-ui" \
        --no-proxy-server \
        --no-first-run \
        --no-default-browser-check \
        --disable-extensions \
        --disable-background-networking \
        --disable-session-crashed-bubble \
        --disable-infobars \
        --disable-pinch \
        --overscroll-history-navigation=0 \
        --disable-background-timer-throttling \
        --disable-renderer-backgrounding \
        --force-dark-mode \
        --ozone-platform=wayland \
        --enable-features=UseOzonePlatform,WaylandWindowDecorations \
        --enable-wayland-ime \
        --disk-cache-size=104857600 \
        --disable-features=Translate \
        --renderer-process-limit=2 \
        --disable-dev-shm-usage \
        --js-flags="--max-old-space-size=512" \
        "$@"
    '';
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "caido-cli";
  version = "0.59.0";

  src = fetchurl {
    url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-7XXBMRAS+0cCC4Cm8f8+QSfAicCtpzaX2J2QhuFXisU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    libgcc.lib
    zlib
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "caido-ui";
      desktopName = "Caido Web Client";
      genericName = "Web Proxy Frontend";
      exec = "caido-ui";
      icon = "utilities-terminal";
      terminal = false;
      categories = [
        "Development"
        "Security"
        "Network"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 caido-cli $out/bin/caido-cli
    ln -s ${lib.getExe caidoUi} $out/bin/caido-ui
    install -Dm644 ${caidoIcon} $out/share/icons/hicolor/256x256/apps/caido-ui.png
    runHook postInstall
  '';

  meta = {
    description = "Lightweight web security auditing toolkit CLI and PWA wrapper";
    homepage = "https://caido.io";
    mainProgram = "caido-cli";
    platforms = [ "x86_64-linux" ];
  };
})
