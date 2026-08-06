{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hyproled";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "mklan";
    repo = "hyproled";
    rev = "v${version}";
    hash = "sha256-WdnMSrvLjqL/EV/noFJ5OfRmEDE4IkfwKYrf+k9Bw1Q=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 hyproled $out/bin/hyproled
    runHook postInstall
  '';

  meta = {
    description = "Hyprland shader utility to prevent OLED burn-in";
    homepage = "https://github.com/mklan/hyproled";
    license = lib.licenses.bsd3;
    mainProgram = "hyproled";
    platforms = lib.platforms.linux;
  };
}
