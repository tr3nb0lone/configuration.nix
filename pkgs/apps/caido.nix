{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  chromium,
  gcc-libs,
  zlib,
}:

let
  version = "0.59.0"; # Bump as releases drop
in
stdenv.mkDerivation rec {
  pname = "caido-cli";
  inherit version;

  src = fetchurl {
    url = "https://caido.download/releases/v${version}/caido-cli-v${version}-linux-x86_64.tar.gz";
    sha256 = lib.fakesha256;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    gcc-libs
    zlib
  ];

  sourceRoot = ".";

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

    # 1. Install patched caido-cli binary
    install -m755 -D caido-cli $out/bin/caido-cli

    # 2. Generate isolated caido-ui launcher script
    cat << 'EOF' > $out/bin/caido-ui
    #!/usr/bin/env bash
    set -euo pipefail

    DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/caido-ui"
    mkdir -p "$DATA_DIR"

    exec "${chromium}/bin/chromium" \
      --app="http://127.0.0.1:8080" \
      --user-data-dir="$DATA_DIR" \
      --class="caido-ui" \
      --disable-extensions \
      --no-first-run \
      --no-default-browser-check \
      --disable-features=Translate \
      "$@"
    EOF
    chmod +x $out/bin/caido-ui

    runHook postInstall
  '';
}
