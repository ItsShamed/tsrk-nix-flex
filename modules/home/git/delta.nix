{ pkgs, ... }:

let
  delta-repo = pkgs.fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    rev = "fdfcc8fce30754a4f05eeb167a15d519888fc909";
    hash = "sha256-lj/HVcO0gDCdGLy0xm+m9SH4NM+BT3Jar6Mv2sKNZpQ=";
  };
in
{
  programs.git.includes = [{ path = "${delta-repo}/themes.gitconfig"; }];

  specialisation = {
    light.configuration = {
      programs.git.includes = [{ contents.delta.syntax-theme = "OneHalfLight"; }];
    };
    dark.configuration = {
      programs.git.includes = [{ contents.delta.syntax-theme = "OneHalfDark"; }];
    };
  };
}
