# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  ### AUDIO
  spotify-adblock = ./applications/audio/spotify-adblock;

  ### INSTANT MESSAGING
  chatterino7 = ./applications/networking/instant-messengers/chatterino7;

  ### DEVELOPMENT
  ltex-ls-plus = ./development/languages-servers/ltext-ls-plus;
  realm-studio = ./development/misc/realm-studio;

  ## Editors
  stm32cubeide = ./development/editors/stm32cubeide;

  ### GAMES
  paladium-launcher = ./games/paladium-launcher;

  rewind = ./games/rewind;

  ### MISC
  polybar-mpris = ./applications/misc/polybar-mpris;
  tokyonight-extras = ./misc/tokyonight-extras;

  ### FONTS
  dsfr-marianne = ./data/fonts/dsfr-marianne;
  spectral-font = ./data/fonts/spectral-font;

  ### THEMES
  sddm-slice-theme = {
    path = ./data/themes/sddm-slice-theme;
    callPackage = self: super: super.libsForQt5.callPackage;
  };
  hyperfluent-grub-theme = ./data/themes/hyperfluent-grub-theme;

  rofi-themes-collection = ./data/themes/rofi-themes-collection;
}
