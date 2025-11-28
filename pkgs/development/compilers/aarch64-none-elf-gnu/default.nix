# # Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  stdenv,
  fetchurl,
  ncurses5,
  python3,
  expat,
}:

stdenv.mkDerivation rec {
  pname = "gcc-aarch64-none-elf";
  version = "12.3.rel1";

  suffix =
    {
      x86_64-linux = "x86_64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${suffix}-aarch64-none-elf.tar.xz";
    sha256 =
      {
        x86_64-linux = "sha256-OCyMeGKF5BW8D/TfRj4QH3bW9pqJSwPxMjaBR8N/C6c=";
      }
      .${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  preFixup = ''
    find $out -executable -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${
        lib.makeLibraryPath [
          "$out"
          stdenv.cc.cc
          ncurses5
          python3
          expat
        ]
      } "$f" || true
    done
  '';

  meta = with lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-A processors";
    homepage = "https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a";
    platforms = [ "x86_64-linux" ];
  };
}
