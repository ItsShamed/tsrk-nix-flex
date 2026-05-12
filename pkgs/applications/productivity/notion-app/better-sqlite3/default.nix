# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  node-gyp,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "better-sqlite3";
  version = "12.10.0";

  src = fetchFromGitHub {
    owner = "WiseLibs";
    repo = "better-sqlite3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QP++wD1O31J7sKAWMUgjNJ+p9U7rVkvLvSvAXfGY81I=";
  };

  nativeBuildInputs = [
    node-gyp
  ];

  postPatch = ''
    cp -vf ${./package-lock.json} package-lock.json
  '';

  npmBuildScript = "build-release";
  npmDepsHash = "sha256-cnq8DWsZ/GvWP32TaBx0eCP0F4rS5d+25/CIGCNoB1s=";

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
    broken = true;
  };
})
