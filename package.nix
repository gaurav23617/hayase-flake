{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
# Add any runtime dependencies here
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

  nativeBuildInputs = [ makeWrapper ];

  # Add runtime dependencies if needed
  # buildInputs = [ ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/hayase
    mkdir -p $out/bin

    # Copy application files
    cp -r * $out/share/hayase/

    # Create wrapper script if there's a main executable
    # Adjust this based on how Hayase is actually run
    if [ -f "$out/share/hayase/hayase" ]; then
      makeWrapper $out/share/hayase/hayase $out/bin/hayase \
        --chdir $out/share/hayase
    fi

    runHook postInstall
  '';

  # Add fixup phase for permissions if needed
  postFixup = ''
    # Make sure executables are executable
    find $out -name "*.sh" -exec chmod +x {} \;
    find $out -name "hayase" -exec chmod +x {} \;
  '';

  meta = with lib; {
    description = "Hayase: anime streaming app";
    homepage = "https://github.com/ClearVision/Miru";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ]; # Add your maintainer info here
    mainProgram = "hayase"; # Specify the main program
  };
}
