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
    rev = "5a3281dee9f889afdeea7263558e7a715dcf5aab";
    hash = "sha256-UzpHAHpQx2MlmBNKm2turjeVmgp5zXKWm3nZbEo0mYE=";
  };

  patches = [
    ./patches/dealer-fix.patch # https://github.com/abba23/spotify-adblock/pull/178
    ./patches/allow-login-fix.patch # https://github.com/abba23/spotify-adblock/pull/173
    ./patches/nix-packaging.patch
  ];

  postPatch = ''
    sed -i "s|@@out@@|$out|" src/lib.rs
  '';

  cargoHash = "sha256-MiTLl/HH65JOVdEnqTIomobxD4aswT9azOjvJUpjBss=";

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
        - Fix "dealer" regex match to allow Spotify Connect and Discord presence to work: https://github.com/abba23/spotify-adblock/pull/178
        - Allow domains used for logging in, signing up, and account modification: https://github.com/abba23/spotify-adblock/pull/173
    '';
    homepage = "https://github.com/abba23/spotify-adblock";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "spotify";
    platforms = platforms.linux;
  };
}
