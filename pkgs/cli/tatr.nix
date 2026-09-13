{
  stdenv,
}:

stdenv.mkDerivation {
  pname = "tatr";
  version = "2.9.0";

  src = fetchGit {
    url = "https://github.com/tsoding/tatr.git";
    rev = "49fc0428d560ab24c67df0c8fdb1cb1775e9399b";
    ref = "main";
  };

  buildPhase = ''
    runHook preInstall
    cc -o nob nob.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $src/nob $out/bin/
    runHook postInstall
  '';

}
