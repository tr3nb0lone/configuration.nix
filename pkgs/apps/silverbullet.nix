{
  autoPatchelfHook,
  common-updater-scripts,
  fetchzip,
  lib,
  stdenv,
  stdenvNoCC,
  writeShellScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "silverbullet";
  version = "2.6.1";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/silverbullet $out/bin/
    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchzip {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-server-linux-x86_64.zip";
        hash = "sha256-m0bQ3J99WZ9CBrA7M2i7Sh/lOI5c+z/an+9bNfQZW4c=";
        stripRoot = false;
      };
      "aarch64-darwin" = fetchzip {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-server-darwin-aarch64.zip";
        hash = "sha256-K/4w4jsa+RIYQA9cW2U/oycJx7PfUzcdG6WjZswRLU0=";
        stripRoot = false;
      };
    };

    updateScript = writeShellScript "update-silverbullet" ''
      NEW_VERSION="$1"
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        ${lib.getExe' common-updater-scripts "update-source-version"} "silverbullet" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';

  };

})
