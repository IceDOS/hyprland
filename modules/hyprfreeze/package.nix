{
  fetchFromGitHub,
  makeWrapper,
  psmisc,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  name = "hyprfreeze";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "zerodya";
    repo = "hyprfreeze";
    tag = "v${version}";
    hash = "sha256-omwAWBEnb14ZBux7bvXSJyi7FI1LZ5GaZFn46/bWJA4=";
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
