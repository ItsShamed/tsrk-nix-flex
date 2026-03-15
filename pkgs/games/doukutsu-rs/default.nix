# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  callPackage,
  pkg-config,
  cmake,
  alsa-lib,
  SDL2,
  useNXEngineAssets ? false,
  vanilla-extractor ? callPackage ./vanilla-extractor.nix { },
  assets ? callPackage ./assets.nix {
    inherit vanilla-extractor useNXEngineAssets;
  },
  makeBinaryWrapper,
  writeShellScript,
}:

let
  launcher = writeShellScript "doukutsu-rs" ''
    export CAVESTORY_DATA_DIR=''${CAVESTORY_DATA_DIR:-@out@/share/doukutsu-rs/data}

    if [ -d "$XDG_DATA_HOME/share/doukutsu-rs/data" ]; then
      echo "Found user data files at $XDG_DATA_HOME/share/doukutsu-rs/data"
      export CAVESTORY_DATA_DIR=''${CAVESTORY_DATA_DIR:-$XDG_DATA_HOME/share/doukutsu-rs/data}
    fi

    echo "Using data files at $CAVESTORY_DATA_DIR"

    exec @out@/libexec/doukutsu-rs "$@"
  '';
in
rustPlatform.buildRustPackage {
  pname = "doukutsu-rs";
  version = "0.102.0-beta7+968d969";

  src = fetchFromGitHub {
    owner = "doukutsu-rs";
    repo = "doukutsu-rs";
    rev = "968d969264bcbd32fb9fff5a1ff979d6170d9cc0";
    hash = "sha256-sDTy0+luMbn86a2rW1QvRFTYT8tHcxmvrKxqo9u+Wgg=";
  };

  cargoPatches = [
    ./patches/0001-build-unix-use-pkg-config-instead-of-bundling.patch
  ];

  cargoHash = "sha256-JT5Exn1aK1HU0zvwA0rTQgL1r/UMU/c7W3fkxBdOcUA=";

  nativeBuildInputs = [
    pkg-config
    cmake
    SDL2
    rustPlatform.bindgenHook
    makeBinaryWrapper
  ];

  buildInputs = [
    SDL2
    alsa-lib
  ];

  postInstall = ''
    mkdir -vp $out/{share/{applications,metainfo,doukutsu-rs,icons/hicolor/512x512/apps},libexec}
    APP_ID=io.github.doukutsu_rs.doukutsu-rs

    cp -v res/flatpak/$APP_ID.desktop $out/share/applications
    cp -v res/flatpak/$APP_ID.png $out/share/icons/hicolor/512x512/apps
    cp -v res/flatpak/$APP_ID.metainfo.xml $out/share/metainfo

    ln -vst $out/share/doukutsu-rs ${assets}/share/cavestory/data

    mv -v $out/bin/doukutsu-rs $out/libexec/doukutsu-rs
    cp -v ${launcher} $out/bin/doukutsu-rs
    substituteAllInPlace $out/bin/doukutsu-rs
  '';

  passthru = {
    inherit vanilla-extractor assets;
  };

  meta = {
    description = "A faithful and open-source remake of Cave Story's engine written in Rust";
    homepage = "https://github.com/doukutsu-rs/doukutsu-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "doukutsu-rs";
    platfomrms = with lib.platforms; linux;
  };
}
