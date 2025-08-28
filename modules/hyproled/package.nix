{
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  name = "hyproled";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "mklan";
    repo = "hyproled";
    rev = version;
    hash = "sha256-WdnMSrvLjqL/EV/noFJ5OfRmEDE4IkfwKYrf+k9Bw1Q=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 hyproled $out/bin/hyproled
    runHook postInstall
  '';
}
