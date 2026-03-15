# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  stdenv,
  fetchzip,
  nxengine-evo,
  vanilla-extractor,
  useNXEngineAssets ? false,
}:

let
  cavestory = fetchzip {
    url = "https://www.cavestory.org/downloads/cavestoryen.zip";
    hash = "sha256-1dKaGb3HLl64NFA7zizkqpPDQT1sS+pJ7CONbaoCugc=";
  };
in
stdenv.mkDerivation {
  pname = "cavestory";
  version = if useNXEngineAssets then "assets+nxengine-evo" else "assets+en";

  nativeBuildInputs = lib.optional (!useNXEngineAssets) vanilla-extractor;

  src = if useNXEngineAssets then nxengine-evo else cavestory;

  dontBuild = true;
  dontCheck = true;
  dontPatch = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/share/cavestory

    ${
      if useNXEngineAssets then
        "cp -va share/nxengine/data $out/share/cavestory"
      else
        ''
          cp -va data $out/share/cavestory
          VANILLA_EXT_OUTDIR=$out/share/cavestory/data vanilla-extractor
        ''
    }
  '';

  meta.license = lib.licenses.unfreeRedistributable;
}
