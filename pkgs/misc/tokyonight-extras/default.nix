{ fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "tokyonight-extras";
  version = "2024-07-18";
  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "a2979cef3300b44ad4d649e7dba8547d47bfbf16";
    hash = "sha256-H3Tioz9Ya032WoHSmBlN1gjQO028MVd7lQG+D0r4sQM=";
  };
  installPhase = ''
    mkdir -p $out
    cp -r extras/* $out
  '';
}
