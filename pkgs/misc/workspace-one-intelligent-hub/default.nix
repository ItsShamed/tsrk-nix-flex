# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  nss,
  nssTools,
  makeWrapper,
  dpkg,
  autoPatchelfHook,
  requireFile,
  stdenv,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "workspaceone-intelligent-hub";
  version = "26.02.0.29";

  src = requireFile {
    name = "${finalAttrs.pname}-amd64-${finalAttrs.version}.deb";
    url = "https://docs.omnissa.com/bundle/LinuxDeviceManagementVSaaS/page/EnrollYourLinuxDevices.html";
    hash = "sha256-AouixWfXaW43HW8bR7Ojgsv9NUVBEQUnzZgnZ8RrFEM=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    nss
    nssTools
  ];

  sourceRoot = "root/opt/omnissa/ws1-hub";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -vp $out/{bin,share/applications,etc/{systemd/system,ssl/certs}}

    cp -va bin $out/

    substitute script/ws1Hub-url-handler.desktop $out/share/applications/ws1Hub-url-handler.desktop \
      --replace-fail "/usr" "$out"

    cp -v data/cacert.pem $out/etc/ssl/certs/omnissa-cert.pem
  '';

  passthru.services.default = {
    imports = [ ./service.nix ];
    ws1-hub.package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Manage and secure your enterprise Linux devices";
    mainProgram = "ws1HubUtil";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
})
