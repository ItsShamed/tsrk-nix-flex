# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  alsa-lib,
  autoPatchelfHook,
  cairo,
  fetchzip,
  fontconfig,
  gdk-pixbuf,
  glib-networking,
  gtk3,
  lib,
  libcxx,
  libGL,
  libsoup_3,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  makeWrapper,
  stdenv,
  webkitgtk_4_1,
  zlib,
}:

stdenv.mkDerivation (self: {
  pname = "pano-scrobbler-bin";
  version = "4.18";

  src =
    let
      tagVersion = lib.concatStrings (builtins.splitVersion self.version);
    in
    fetchzip {
      url = "https://github.com/kawaiiDango/pano-scrobbler/releases/download/${tagVersion}/pano-scrobbler-linux-x64.tar.gz";
      hash = "sha256-vIKfCNmmCNyH2gSm80IhkZYzvt0hyJe/WKa+BcLMbIc=";
      stripRoot = false;
    };

  buildInputs = [
    alsa-lib
    cairo
    fontconfig
    gdk-pixbuf
    glib-networking
    gtk3
    libcxx
    libGL
    libsoup_3
    libx11
    libxext
    libxi
    libxrender
    libxtst
    webkitgtk_4_1
    zlib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  installPhase = ''
    mkdir -vp $out/{bin,lib,share/applications}
    chmod -v +x *.so lib/*.so

    cp -v pano-scrobbler.svg LICENSE $out
    cp -v *.so lib/*.so $out/lib
    cp -v pano-scrobbler $out
    cp -v pano-scrobbler.desktop $out/share/applications

    sed -i -e "s|Exec=|Exec=$out/bin/pano-scrobbler|g" \
      -e "s|Icon=|Icon=$out/pano-scrobbler.svg|g" \
      $out/share/applications/pano-scrobbler.desktop

    wrapProgram $out/pano-scrobbler \
      --add-flag -Dpano.native.components.path="$out/lib" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (self.buildInputs ++ [ "$out/lib" ])
      }

    ln -sft $out $out/lib/{libawt,libfontmanager,libjava,libjvm,libjsound}.so
    ln -sft $out/bin $out/pano-scrobbler
    addAutoPatchelfSearchPath $out/lib
  '';

  meta = with lib; {
    description = "Feature packed cross-platform music tracker for Last.fm, ListenBrainz, Libre.fm, Pleroma and other compatible services";
    homepage = "https://kawaiidango.github.io/pano-scrobbler/";
    mainProgram = "pano-scrobbler";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    broken = true;
  };
})
