{ fetchFromGitHub
, stdenvNoCC
, lib
}:

stdenvNoCC.mkDerivation {
  pname = "tokyonight-extras";
  version = "4.7.0";
  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "1471dab694ad88351185758bb4275624d8b798ec";
    hash = "sha256-NWbI9g1UoiN/h+8JPeFZLN+Uh261fjiZviDMHQWM2Ks=";
  };
  installPhase = ''
    mkdir -p $out
    cp -r extras/* $out
    cp LICENSE $out
  '';

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/folke/tokyonight.nvim";
    description = "A clean, dark Neovim theme written in Lua.";
    platforms = platforms.all;
  };
}
