{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  wails,
  pkg-config,
  webkitgtk_4_1,
  gtk3,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  nix-update,
  writeShellApplication,
}:
let
  pname = "aether";
  version = "4.32.0";

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "aether";
    tag = "v${version}";
    hash = "sha256-Ntu2KRcEPyC4SvlFxW8PgdvijqH8OjljF60UuCvnWzg=";
  };

  frontend = buildNpmPackage {
    pname = "${pname}-frontend";
    inherit version;
    src = "${src}/frontend";

    npmDepsHash = "sha256-pKMbskfU6w1PO9eQvffoBk8HMmvrpkLZ3l6p6Y/czgU=";

    # `npm run build` writes dist/, which is what wails embeds.
    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };
in
buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-i8Tr4zKm+LaaZ/zKA8yoZC5mv2s4DUqaeT7Iq0uB+ME=";

  nativeBuildInputs = [
    nodejs
    wails
    pkg-config
    copyDesktopItems
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
  ];

  buildPhase = ''
    # Upstream does not commit frontend/dist, and main.go embeds it with
    # `//go:embed all:frontend/dist`. The finished dist from the derivation
    # above goes in before wails is asked to skip building it.
    #
    # Inline rather than in preBuild, because buildPhase is replaced here and
    # preBuild is a hook OF the phase being replaced -- it would never run, and
    # the build would still succeed: wails creates an empty frontend/dist when
    # one is missing, so the binary links, installs, and opens a blank window.
    # That is exactly the failure installCheckPhase below exists to catch.
    rm -rf frontend/dist
    cp -r ${frontend} frontend/dist
    chmod -R u+w frontend/dist

    wails build -s -m -skipbindings -tags webkit2_41 -o ${pname}
    runHook postBuild
  '';
  doCheck = false;
  installPhase = ''
    runHook preInstall
    install -Dm755 build/bin/${pname} $out/bin/${pname}

    # The desktop item below names icon = "aether", which resolves to nothing
    # unless a file of that name is in the icon theme -- the entry would show
    # a generic placeholder in the launcher. Upstream's Makefile installs
    # assets/aether-icon-512.png; so does this.
    install -Dm644 assets/aether-icon-512.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # -r over bin/, not the binary by name: wrapGAppsHook3 has already run by
    # installCheck time, so $out/bin/${pname} is a wrapper script and the ELF is
    # the hidden .${pname}-wrapped beside it.
    grep -qra "frontend/dist/index.html" $out/bin || {
      echo "ERROR: the frontend was not embedded; the window would be blank"
      exit 1
    }
    runHook postInstallCheck
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Aether";
      comment = "Native Omarchy theming";
      categories = [
        "Utility"
        "Settings"
      ];
    })
  ];

  passthru.frontend = frontend;

  passthru.updateScript = writeShellApplication {
    name = "update-aether";
    runtimeInputs = [ nix-update ];
    text = ''
      [ -f flake.nix ] || { echo "aether: run from the repo root" >&2; exit 1; }
      nix-update --flake aether --subpackage frontend
    '';
  };

  meta = {
    description = "Native Omarchy theming made easy";
    homepage = "https://github.com/omacom/aether";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = lib.platforms.linux;
    broken = !stdenv.hostPlatform.isLinux;
  };
}
