{
  fetchFromGitHub,
  makeWrapper,
  psmisc,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  name = "hyprfreeze";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "zerodya";
    repo = "hyprfreeze";
    tag = "v${version}";
    hash = "sha256-iMFSbMRVO3yOBZvCzx0BAb26KEETE7Nb+960B24r+W4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 hyprfreeze $out/bin/hyprfreeze

    # Add pstree to path
    wrapProgram $out/bin/hyprfreeze \
      --prefix PATH : ${psmisc}/bin

    runHook postInstall
  '';
}
