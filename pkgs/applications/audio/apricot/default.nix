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
  pname = "apricot";
  version = "1.1.34";

  src = requireFile {
    name = "ApricotSynthLinux_v${version}.tar.gz";
    url = "https://nakst.itch.io/apricot";
    sha256 = "1qnwcvfv98ya59x78nm2j1qk31gh1wrc4gv4mkpln0dqzf9x54k2";
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

    wrapProgram $out/bin/Apricot \
      --prefix PATH : "${
        lib.makeBinPath [
          pulseaudio
          zenity
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "Apricot is a free compact hybrid synthesizer with a massive sound.";
    homepage = "https://nakst.gitlab.io/apricot/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "Apricot";
  };
}
