{ lib, fetchFromGitHub, stdenv, theme ? "nixos" }:

assert builtins.any (s: theme == s) [
  "arch"
  "debian"
  "endeavouros"
  "fedora"
  "gentoo"
  "linux-generic"
  "linux-mint"
  "macos"
  "manjaro"
  "nixos"
  "opensuse-generic"
  "opensuse-tumbleweed"
  "redhat"
  "ubuntu"
  "windows-dark"
  "windows-light"
  "zorin-os"
];

stdenv.mkDerivation {
  pname = "hyperfluent-grub-theme";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Coopydood";
    repo = "HyperFluent-GRUB-Theme";
    rev = "addbc7ced9e54a6dd51cd7ef15ac275e6e7ec6eb";
    hash = "sha256-zryQsvue+YKGV681Uy6GqnDMxGUAEfmSJEKCoIuu2z8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r "${theme}"/* $out/
    cp LICENSE $out/

    runHook postInstall
  '';

  meta = with lib; {
    description =
      "Boot your machine in style with a fluent, modern, and clean GRUB theme.";
    homepage = "https://github.com/Coopydood/HyperFluent-GRUB-Theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
