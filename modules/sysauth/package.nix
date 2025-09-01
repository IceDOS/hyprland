let
  __rev = "901c2a28394f406bfbc86e6e72ace876c763d196";
  __sha256 = "sha256-IBKOIgAmu97M7JG4o5UxjtUu1SocVCKubv8/EP5CJOg=";
  __bgColor = "@theme_bg_color";
  __bgTransparency = 1.0;
in
{
  _rev ? __rev,
  _sha256 ? __sha256,
  _bgColor ? __bgColor,
  _bgTransparency ? __bgTransparency,

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

  _style = builtins.toFile "sysauth-styles.css" ''
    #sysauth {
      background: rgba(0, 0, 0, 0.5);
    }

    #sysauth .box_layout {
      background: alpha(${_bgColor}, ${toString _bgTransparency});
      box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.5);
    }
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4-layer-shell
    gtkmm4
    polkit
  ];

  hardeningDisable = [ "format" ];
  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    sed -i "s|libsysauth.so|$out/lib/libsysauth.so|g" ./src/main.cpp
    cp ${_style} ./style.css
  '';
}
