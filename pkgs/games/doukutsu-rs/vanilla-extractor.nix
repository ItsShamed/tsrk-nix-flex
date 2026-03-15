# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "vanilla-extractor";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "doukutsu-rs";
    repo = "vanilla-extractor";
    rev = "v${version}";
    hash = "sha256-hZKfRtuOlX34S4/arK0QvjpcbKOaROryz1B8P++vGE0=";
  };

  cargoHash = "sha256-lCGEWT8r/oUUWjgrrwmMjhJB6Ootg9Hgq+qPR4xDHmI=";

  meta = {
    description = "A simple program to extract game assets from the original Cave Story executable";
    homepage = "https://github.com/doukutsu-rs/vanilla-extractor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vanilla-extractor";
  };
}
