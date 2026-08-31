# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  xivlauncher,
  fetchFromGitHub,
}:

let
  version = "1.4.0.9";
in
xivlauncher.overrideAttrs (old: {
  inherit version;
  src = fetchFromGitHub {
    owner = "rankynbass";
    repo = "XIVLauncher.Core";
    rev = "rb-v${version}";
    hash = "sha256-kB2nZmLv/oF79J8USOJnOth6MvbZbE0eQuwYh705Ics=";
    fetchSubmodules = true;
  };

  nugetDeps = ./deps.json;

  meta = old.meta // {
    homepage = "https://github.com/rankynbass/XIVLauncher.Core";
  };
})
