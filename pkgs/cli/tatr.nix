{
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "tatr";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "tatr";
    rev = "49fc0428d560ab24c67df0c8fdb1cb1775e9399b";
    hash = "sha256-Srwf5NxmlMKKcs68Q9IbQMsQD3rSgdS4nBjs/hn3wus=";
  };

  buildPhase = ''
    runHook preBuild
    cc -o nob nob.c
    ./nob
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/tatr $out/bin/tatr
    runHook postInstall
  '';
}
