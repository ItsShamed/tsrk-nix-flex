# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  nss,
  nssTools,
  xmlstarlet,
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
    xmlstarlet
  ];

  buildInputs = [
    nss
    nssTools
  ];

  sourceRoot = "root/opt/omnissa/ws1-hub";

  dontConfigure = true;
  dontBuild = true;

  patchPhase = ''
    xml ed -P -u /airwatch/agent/Version -v "${finalAttrs.version}" config/GeneralConfig.conf > config/GeneralConfig.patch.conf
    mv config/GeneralConfig{.patch,}.conf
    xml ed -P -u /airwatch/agent/Installer -v "nix" config/GeneralConfig.conf > config/GeneralConfig.patch.conf
    mv config/GeneralConfig{.patch,}.conf
    xml ed -P -u /airwatch/userInfo/UserName -v "root" config/GeneralConfig.conf > config/GeneralConfig.patch.conf
    mv config/GeneralConfig{.patch,}.conf
  '';

  installPhase = ''
    mkdir -vp $out/{bin,share/{applications,ws1-hub},etc/{ssl/certs,ws1-hub/}}

    cp -va bin $out/
    cp -va share/* $out/share/ws1-hub
    cp -va config/* $out/etc/ws1-hub/

    cat <<EOF > $out/etc/ws1-hub.conf
    <airwatch>
      <home>/run/ws1-hub</home>
      <bin>$out/bin</bin>
      <ipc>/var/run/ws1-hub</ipc>
      <config>$out/etc/ws1-hub/</config>
      <share>$out/share/ws1-hub/</share>
      <logs>/var/log/ws1-hub</logs>
      <extras>/var/opt/omnissa/ws1-hub</extras>
    </airwatch>
    EOF

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
