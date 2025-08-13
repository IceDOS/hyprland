{
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  name = "hyproled";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "mklan";
    repo = "hyproled";
    rev = version;
    hash = "sha256-vbwhX5YTb1p+vTeU0c9++PvhgnaM63IZ6Ga1KKFAdGo=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 hyproled $out/bin/hyproled
    runHook postInstall
  '';
}
