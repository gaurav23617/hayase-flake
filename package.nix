{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  electron,
  nodejs,
  pnpm,
  python3,
  pkg-config,
  libsecret,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  pname = "hayase";
  version = "6.3.9";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ThaUnknown";
    repo = "miru";
    rev = "v${version}";
    hash = "sha256-nLPqEI6u5NNQ/kPbXRWPG0pIwutKNK2J8JeTPN6wHlg=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm.configHook
    python3
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    libsecret
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Update this
  };

  installPhase = ''
    runHook preInstall

    # Build the application
    pnpm build

    # Install the built application
    mkdir -p $out/share/hayase
    cp -r dist/* $out/share/hayase/

    # Create wrapper script
    makeWrapper ${electron}/bin/electron $out/bin/hayase \
      --add-flags $out/share/hayase \
      --set-default ELECTRON_IS_DEV 0

    # Install desktop file
    mkdir -p $out/share/applications
    cp $out/share/hayase/hayase.desktop $out/share/applications/ || true

    # Install icon if it exists
    if [ -f $out/share/hayase/assets/icon.png ]; then
      mkdir -p $out/share/pixmaps
      cp $out/share/hayase/assets/icon.png $out/share/pixmaps/hayase.png
    fi

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "hayase";
      exec = "hayase";
      icon = "hayase";
      desktopName = "Hayase";
      comment = "Stream anime torrents, real-time with no waiting for downloads";
      categories = [
        "AudioVideo"
        "Video"
      ];
      startupNotify = true;
    })
  ];

  meta = with lib; {
    description = "Hayase - Stream anime torrents, real-time with no waiting for downloads";
    homepage = "https://github.com/ThaUnknown/miru";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "hayase";
  };
}
