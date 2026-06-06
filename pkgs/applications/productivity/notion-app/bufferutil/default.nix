# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT
{
  lib,
  node-gyp-build,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "bufferutil";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "websockets";
    repo = "bufferutil";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W9McBGIrDWMvTbrs9J1KmZ8NTbS/qMYrlDa55Ar1UHM=";
  };

  nativeBuildInputs = [
    node-gyp-build
  ];

  dontNpmPrune = true;

  npmBuildScript = "install";

  npmDepsHash = "sha256-jmu4rfR/WaDyfIkwEvuc09wC64wLUi0pr1ZDepY2KrI=";

  postPatch = ''
    cp -vf ${./package-lock.json} package-lock.json
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/bufferutil/

    cp -vf build/Release/bufferutil.node $out/lib/bufferutil/

    runHook postInstall
  '';

  meta = {
    description = "WebSocket buffer utils";
    homepage = "https://github.com/websockets/bufferutil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "bufferutil";
    platforms = lib.platforms.all;
  };
})
