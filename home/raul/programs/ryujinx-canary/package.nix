{
  lib,
  buildDotnetModule,
  cctools,
  darwin,
  dotnetCorePackages,
  fetchurl,
  libx11,
  libgdiplus,
  moltenvk,
  ffmpeg,
  openal,
  libsoundio,
  sndio,
  stdenv,
  pulseaudio,
  vulkan-loader,
  glew,
  libGL,
  libice,
  libsm,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  udev,
  SDL2,
  SDL2_mixer,
  gtk3,
  wrapGAppsHook3,
}:
buildDotnetModule rec {
  pname = "ryujinx-canary";
  version = "1.3.279";

  src = fetchurl {
    url = "https://git.ryujinx.app/projects/Ryubing/archive/Canary-1.3.279.tar.gz";
    hash = "sha256-9NKlF0IsMmO27MufJYVEpBTGZn2wHSSa+/phzeYK7k0=";
  };

  nativeBuildInputs =
    lib.optional stdenv.hostPlatform.isLinux [
      wrapGAppsHook3
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      cctools
      darwin.sigtool
    ];

  enableParallelBuilding = false;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps-canary.json;

  postPatch = ''
    rm -f global.json
  '';

  runtimeDeps = [
    libx11
    libgdiplus
    SDL2_mixer
    openal
    libsoundio
    sndio
    vulkan-loader
    ffmpeg
    glew
    libice
    libsm
    libxcursor
    libxext
    libxi
    libxrandr
    gtk3
    libGL
    SDL2
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) [
    udev
    pulseaudio
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [ moltenvk ];

  projectFile = "Ryujinx.sln";
  testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";
  doCheck = !stdenv.hostPlatform.isDarwin;

  dotnetFlags = [
    "/p:ExtraDefineConstants=DISABLE_UPDATER%2CFORCE_EXTERNAL_BASE_DIR"
  ];

  executables = [ "Ryujinx" ];

  makeWrapperArgs = lib.optional stdenv.hostPlatform.isLinux [
    "--set SDL_VIDEODRIVER x11"
  ];

  preInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/sndio-6
    ln -s ${sndio}/lib/libsndio.so $out/lib/sndio-6/libsndio.so.6
  '';

  preFixup = ''
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps,mime/packages}
      install -D ./distribution/linux/Ryujinx.desktop  $out/share/applications/Ryujinx.desktop
      install -D ./distribution/linux/Ryujinx.sh       $out/bin/Ryujinx.sh
      install -D ./distribution/linux/mime/Ryujinx.xml $out/share/mime/packages/Ryujinx.xml
      install -D ./distribution/misc/Logo.svg          $out/share/icons/hicolor/scalable/apps/Ryujinx.svg
    ''}
    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) "ln -s $out/bin/Ryujinx $out/bin/ryujinx"}
  '';

  meta = {
    homepage = "https://ryujinx.app";
    description = "Nintendo Switch emulator (Ryubing Canary fork)";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    mainProgram = "Ryujinx";
  };
}
