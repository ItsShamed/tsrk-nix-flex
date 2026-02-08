# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "modern-minimal-ui-sounds";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "cadecomposer";
    repo = "modern-minimal-ui-sounds";
    rev = "V${version}";
    hash = "sha256-cpvL25Sb4f7Rg34FHYYBbvpWzB0jvQdQKmTAqYEWtZc=";
  };

  patches = [
    ./0001-fix-screen-capture-symlink.patch
  ];

  installPhase = ''
    mkdir -vp $out/share/sounds/modern-minimal-ui

    cp -va index.theme stereo $out/share/sounds/modern-minimal-ui
  '';

  meta = {
    description = "Minimalistic UI sounds adhering to the freedesktop naming standard";
    homepage = "https://github.com/cadecomposer/modern-minimal-ui-sounds";
    license = lib.licenses.cc-by-sa-40;
    platforms = lib.platforms.unix;
  };
}
