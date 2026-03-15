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
}:

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
    mkdir -p $out/share/{applications,metainfo,doukutsu,icons/hicolor/512x512/apps}
    APP_ID=io.github.doukutsu_rs.doukutsu-rs

    cp -v res/flatpak/$APP_ID.desktop $out/share/applications
    cp -v res/flatpak/$APP_ID.png $out/share/icons/hicolor/512x512/apps
    cp -v res/flatpak/$APP_ID.metainfo.xml $out/share/metainfo

    ln -vst $out/share/doukutsu ${assets}/share/cavestory/data

    wrapProgram $out/bin/doukutsu-rs \
      --set CAVESTORY_DATA_DIR "$out/share/doukutsu/data"
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
