# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  node-gyp,
  electron,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
}:

let
  electron-node-gyp = node-gyp.overrideAttrs (_: {
    makeWrapperArgs = [ "--set npm_config_nodedir ${electron.headers}" ];
  });
in
(buildNpmPackage.override { inherit nodejs; }) (finalAttrs: {
  pname = "better-sqlite3";
  version = "12.8.0";

  src = fetchFromGitHub {
    owner = "WiseLibs";
    repo = "better-sqlite3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B9SHvlSK9Heqhp3maCPRf08tatXzLi5m2zcnU5o2Y0E=";
  };

  nativeBuildInputs = [
    electron-node-gyp
  ];

  buildInputs = [
    electron
  ];

  postPatch = ''
    cp -vf ${./package-lock.json} package-lock.json
  '';

  buildPhase = ''
    node-gyp rebuild --release --runtime=electron
  '';

  npmDepsHash = "sha256-mtciGERuBzkBLNAW5/muq6S2hZONrFa/7hALN7KOv9A=";
  npmInstallFlags = [ "--ignore-scripts" ];

  installPhase = ''
    runHook preInstall

    runHook npmInstall

    mkdir -p $out/lib/better-sqlite3/

    cp -vf build/Release/better_sqlite3.node $out/lib/better-sqlite3/

    runHook postInstall
  '';

  dontNpmPrune = true;

  meta = {
    description = "The fastest and simplest library for SQLite3 in Node.js";
    homepage = "https://github.com/WiseLibs/better-sqlite3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
