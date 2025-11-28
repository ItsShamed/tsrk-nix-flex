# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tokyonight-extras";
  version = "4.14.1";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "v${version}";
    hash = "sha256-4zfkv3egdWJ/GCWUehV0MAIXxsrGT82Wd1Qqj1SCGOk=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r extras/* $out
    cp LICENSE $out
  '';

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/folke/tokyonight.nvim";
    description = "A clean, dark Neovim theme written in Lua.";
    platforms = platforms.all;
  };
}
