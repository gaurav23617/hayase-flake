{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
}:

let
  versionInfo = builtins.fromJSON (builtins.readFile ./version.json);
in

stdenv.mkDerivation rec {
  pname = "hayase";
  version = versionInfo.version;

  src = fetchFromGitHub {
    owner = "ClearVision";
    repo = "Miru";
    rev = "v${version}";
    sha256 = versionInfo.sha256;
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
  '';

  meta = {
    description = "Hayase: anime streaming app";
    homepage = "https://github.com/ClearVision/Miru";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
