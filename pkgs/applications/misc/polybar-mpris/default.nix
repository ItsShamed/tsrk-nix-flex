# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  makeWrapper,
  playerctl,
  coreutils-full,
  polybarFull,
  procps,
  gawk,
  gnugrep,
  gnused,
  xdotool,
  zscroll,
}:

let
  statusPath = lib.makeBinPath [
    coreutils-full
    playerctl
    polybarFull
    procps
    gawk
    gnugrep
    gnused
    xdotool
  ];

  entryPath = lib.makeBinPath [ zscroll ];
in
stdenvNoCC.mkDerivation {
  pname = "polybar-mpris";
  version = "unstable-2024-02-25";

  src = fetchFromGitHub {
    owner = "0jdxt";
    repo = "polybar-mpris";
    rev = "d0c7bc49d899bc561e5d5e3bab9f039708782cfb";
    hash = "sha256-eDkOFpeHhDbnopJnLh2fsmTet7IHHuQPChKPseOtto4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patches = [
    ./patches/tsrk-usage.patch
    ./patches/nix-packaging.patch
    ./patches/decrease-scroll-delay.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/polybar-mpris

    cp -a get_status.sh $out/share/polybar-mpris/get-mpris-text

    wrapProgram $out/share/polybar-mpris/get-mpris-text \
      --prefix PATH : ${statusPath}

    substituteAll scroll_status.sh $out/bin/polybar-mpris

    chmod +x $out/bin/polybar-mpris

    wrapProgram $out/bin/polybar-mpris \
      --prefix PATH : ${entryPath}

    runHook postInstall
  '';

  dontBuild = true;
  dontConfigure = true;

  meta = with lib; {
    description = "MPRIS status and controls module for polybar with text scrolling and icons for various apps and wesbites.";
    homepage = "https://github.com/0jdxt/polybar-mpris";
    license = licenses.gpl3Only;
    mainProgram = "polybar-mpris";
    platforms = platforms.linux;
  };
}
