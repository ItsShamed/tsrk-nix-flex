# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, rustPlatform, fetchFromGitHub, lndir, makeBinaryWrapper, spotify }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "1.0.3-patched";

  src = fetchFromGitHub {
    owner = "abba23";
    repo = pname;
    rev = "8e0312d6085a6e4f9afeb7c2457517a75e8b8f9d";
    hash = "sha256-nwiX2wCZBKRTNPhmrurWQWISQdxgomdNwcIKG2kSQsE=";
  };

  patches = [
    ./patches/allow-login-fix.patch # https://github.com/abba23/spotify-adblock/pull/173
    ./patches/nix-packaging.patch
  ];

  postPatch = ''
    substituteAllInPlace src/lib.rs
  '';

  cargoHash = "sha256-oGpe+kBf6kBboyx/YfbQBt1vvjtXd1n2pOH6FNcbF8M=";

  nativeBuildInputs = [ makeBinaryWrapper lndir ];

  postInstall = ''
    install -Dm644 config.toml $out/etc/spotify-adblock/config.toml

    lndir ${spotify} $out

    wrapProgram $out/bin/spotify \
      --suffix LD_PRELOAD : "$out/lib/libspotifyadblock.so"
  '';

  meta = with lib; {
    description =
      "Adblocker for Spotify. Patched with some bugs fixes and quality of life improvements.";
    longDescription = ''
      Included patches:
        - Allow domains used for logging in, signing up, and account modification: https://github.com/abba23/spotify-adblock/pull/173
    '';
    homepage = "https://github.com/abba23/spotify-adblock";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "spotify";
    platforms = platforms.linux;
  };
}
