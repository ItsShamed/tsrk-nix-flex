# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ltex-ls, jre_headless, system, fetchurl }:

ltex-ls.overrideAttrs (self: super: {
  pname = super.pname + "-plus";
  version = "18.5.1";

  src = fetchurl {
    url = if system == "x86_64-linux" then
      "https://github.com/ltex-plus/ltex-ls-plus/releases/download/${self.version}/ltex-ls-plus-${self.version}-linux-x64.tar.gz"
    else if system == "aarch64-linux" then
      "https://github.com/ltex-plus/ltex-ls-plus/releases/download/${self.version}/ltex-ls-plus-${self.version}-linux-aarch64.tar.gz"
    else
      builtins.throw "Unsupported system ${system}";
    hash = if system == "x86_64-linux" then
      "sha256-5uCFmLu7V130CcjUkdMFMyYzc3dCUVpcUIA9TGcct98="
    else if system == "aarch64-linux" then
      "sha256-CGOYdzZRMDq5lqtweMv2Cc5sNF0e3aOS+sSebFgHadE="
    else
      builtins.throw "Unsupported system ${system}";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rfv bin/ lib/ $out
    rm -fv $out/bin/.lsp-cli-plus.json $out/bin/*.bat

    for file in $out/bin/{ltex-ls-plus,ltex-cli-plus}; do
      wrapProgram $file --set JAVA_HOME "${jre_headless}"
    done

    # Keep backwards compatibility with ltex-ls
    ln -vs $out/bin/ltex-ls-plus $out/bin/ltex-ls
    ln -vs $out/bin/ltex-cli-plus $out/bin/ltex-cli

    runHook postInstall
  '';

  meta = super.meta // { homepage = "https://ltex-plus.github.io/ltex-plus/"; };
})
