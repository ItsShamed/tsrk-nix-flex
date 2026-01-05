# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  stdenvNoCC,
  fetchzip,
  lib,
}:

stdenvNoCC.mkDerivation {
  pname = "dsfr-marianne";
  version = "1.007";

  src = fetchzip {
    url = "https://www.systeme-de-design.gouv.fr/uploads/Marianne_fd0ba9c190.zip";
    hash = "sha256-hbe60MVd0Nu+hiY27y8q58zyJny4I5jqyINpZep/opc=";
    stripRoot = false; # They left MacOS metadata files smh
  };

  installPhase = ''
    __dest_dir="$out/share/fonts/opentype/Marianne"
    mkdir -p $__dest_dir
    find -name '*.otf' -exec cp {} $__dest_dir \;
  '';

  meta = with lib; {
    description = "Official font of the French Government design system";
    longDescription = ''
      The font Marianne is one of the official fonts of the French Government
      branding guidelines. Its usage creates a coherence between the various
      fronts and gives the user a positive experience.
    '';
    homepage = "https://www.systeme-de-design.gouv.fr/fondamentaux/typographie/";
    license = licenses.unfree;
  };
}
