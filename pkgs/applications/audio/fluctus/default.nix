# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
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
  pname = "fluctus";
  version = "1.1.12";

  src = requireFile {
    name = "FluctusSynthLinux_v${version}.tar.gz";
    url = "https://nakst.itch.io/fluctus";
    sha256 = "1xw5j907yx7s41ml9768lw1nr77yqj8ljzx888wwwkxl5gl8dxj9";
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

    wrapProgram $out/bin/Fluctus \
      --prefix PATH : "${
        lib.makeBinPath [
          pulseaudio
          zenity
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "The ultra simple 3-operator FM synthesizer.";
    homepage = "https://nakst.gitlab.io/fluctus/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "Fluctus";
  };
}
