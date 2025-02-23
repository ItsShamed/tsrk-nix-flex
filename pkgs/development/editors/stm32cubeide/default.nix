# # Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ autoPatchelfHook, qt6, makeWrapper, cairo, dbus, libglvnd, libGL, fontconfig
, freetype, libgcc, glib, gtk3, gtk2-x11, pcsclite, pango, ncurses5, alsa-lib
, ffmpeg_4-headless, ffmpeg_6-headless, imagemagick, libxkbcommon, swt, unzip
, xorg, libz, xercesc, makeDesktopItem, requireFile, stdenv, symlinkJoin, lib }:

let
  package = stdenv.mkDerivation rec {
    pname = "stm32cubeide";
    version = "1.17.0";

    autoPatchelfIgnoreMissingDeps = [
      "libavcodec.so.54"
      "libavcodec.so.56"
      "libavcodec.so.57"
      "libavcodec.so.59"
      "libavformat.so.54"
      "libavformat.so.56"
      "libavformat.so.57"
      "libavformat.so.59"
      "libavcodec-ffmpeg.so.56"
      "libavformat-ffmpeg.so.56"
    ];

    fileTimestamps = "23558_20241125_2245";
    distName = "st-stm32cubeide_${version}_${fileTimestamps}_amd64";

    src = requireFile {
      name = "en.${distName}.sh.zip";
      url = "https://www.st.com/en/development-tools/stm32cubeide.html";
      sha256 = "0cn7hd9gb38x8qimxslsjym9r6mi56lry54l0ajq9wfyjmk44g3q";
    };

    nativeBuildInputs =
      [ autoPatchelfHook qt6.wrapQtAppsHook makeWrapper unzip imagemagick ];

    buildInputs = [
      cairo
      dbus
      libglvnd
      libGL
      fontconfig
      freetype
      ffmpeg_4-headless
      ffmpeg_6-headless
      libgcc
      glib
      gtk3
      gtk2-x11
      pcsclite
      pango
      ncurses5
      qt6.qtbase
      qt6.qtwayland
      alsa-lib
      libxkbcommon
      xorg.libX11
      xorg.libXcursor
      xorg.xcbutil
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXtst
      xorg.libXxf86vm
      libz
      xercesc
      swt
    ];

    unpackCmd = ''
      mkdir rootsrc
      unzip $curSrc -d rootsrc
    '';

    installPhase = ''
      chmod +x ${distName}.sh
      ./${distName}.sh --noexec --target extract
      mkdir -p $out/bin
      tar xvf extract/${distName}.tar.gz -C $out
      wrapProgram "$out/stm32cubeide" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
      wrapProgram "$out/stm32cubeide_wayland" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
      ln -s "$out/stm32cubeide" "$out/bin/stm32cubeide"
      ln -s "$out/stm32cubeide_wayland" "$out/bin/stm32cubeide_wayland"
      magick $out/icon.xpm $out/icon.png
    '';
  };

  x11DesktopItem = makeDesktopItem {
    name = "stm32cubeide-x11";
    exec = "${package}/stm32cubeide %U";
    icon = "${package}/icon.png";
    desktopName = "STM32CubeIDE";
    startupWMClass = "STM32CubeIDE";
    terminal = false;
    categories = [ "Development" "IDE" "Electronics" ];
  };

  waylandDesktopItem = makeDesktopItem {
    name = "stm32cubeide-wayland";
    exec = "${package}/stm32cubeide %U";
    icon = "${package}/icon.png";
    desktopName = "STM32CubeIDE (Wayland)";
    startupWMClass = "STM32CubeIDE";
    terminal = false;
    categories = [ "Development" "IDE" "Electronics" ];
  };
in symlinkJoin {
  name = "stm32cubeide";
  paths = [ package x11DesktopItem waylandDesktopItem ];

  meta = with lib; {
    license = licenses.unfree;
    homepage = "https://www.st.com/en/development-tools/stm32cubeide.html";
    description =
      "STM32CubeIDE is an all-in-one development tool, which is part of the STM32Cube software ecosystem.";
    platform = platforms.linux;
    mainProgram = "stm32cubeide";
  };
}
