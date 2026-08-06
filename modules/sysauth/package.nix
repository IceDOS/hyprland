let
  __rev = "901c2a28394f406bfbc86e6e72ace876c763d196";
  __sha256 = "sha256-IBKOIgAmu97M7JG4o5UxjtUu1SocVCKubv8/EP5CJOg=";
in
{
  _rev ? __rev,
  _sha256 ? __sha256,

  stdenv,
  fetchFromGitHub,

  pkg-config,
  wrapGAppsHook4,

  gtk4-layer-shell,
  gtkmm4,
  polkit,

  ...
}:
stdenv.mkDerivation rec {
  pname = "sysauth";
  version = "0.0.0-${_rev}";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = pname;
    rev = _rev;
    sha256 = _sha256;
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail "libsysauth.so" "$out/lib/libsysauth.so"
  '';

  buildInputs = [
    gtk4-layer-shell
    gtkmm4
    polkit
  ];

  makeFlags = [ "PREFIX=$(out)" ];
}
