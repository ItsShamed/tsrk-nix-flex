# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

pkgs:

contents:
builtins.fromJSON (
  builtins.readFile (
    pkgs.runCommand "yaml-${builtins.hashString "sha256" contents}-as.json"
      {
        nativeBuildInputs = [ pkgs.yj ];
      }
      ''
        yj <<EOF > "$out"
        ${contents}
        EOF
      ''
  )
)
