# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  pulseaudio,
  which,
  xorg,
  zenity,
  autoPatchelfHook,
  lib,
  makeWrapper,
  stdenv,
  requireFile,
}:

stdenv.mkDerivation rec {
  pname = "extrabold";
  version = "1.3.2";

  src = requireFile {
    name = "ExtraBoldSynthLinux_v${version}.tar.gz";
    url = "https://nakst.itch.io/extrabold";
    sha256 = "1989y71jpgppphg7vl10fl6gwcrdygrczjg8b85mbnijwg2l86gs";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    which
    zenity
  ];

  buildInputs = [
    zenity
    xorg.libX11
    pulseaudio
  ];

  patchPhase = ''
    sed -i -e 's|$HOME/.local|$out|g' \
      -e 's|$HOME/.clap|$out/lib/clap|g' \
      -e 's|mv|cp|g' \
      -e 's|share/nakst|bin|g' \
      -e '/ldd/d' \
      install.sh
  '';

  installPhase = ''
    runHook preInstall

    ./install.sh

    wrapProgram $out/bin/ExtraBold \
      --prefix PATH : "${
        lib.makeBinPath [
          pulseaudio
          zenity
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "Multi-tiered phase distorting synthesizer";
    homepage = "https://nakst.gitlab.io/extrabold/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "Regency";
  };
}
