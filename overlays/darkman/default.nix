self: super:

{
  darkman = super.buildGoModule {
    inherit (super.darkman.drvAttrs)
      pname nativeBuildInputs buildInputs
      buildPhase installPhase;
    inherit (super.darkman) meta;
    version = "2.0.0-unrealeased";
    src = super.fetchFromGitLab {
      owner = "WhyNotHugo";
      repo = "darkman";
      rev = "38101ffd596f79790361817b4379c2e605f2f340";
      hash = "sha256-uBE8NKkv2TQns0uXov8NSMTqAjhXJZ9hPqQvzgQb7WU=";
    };
    vendorHash = "sha256-3lILSVm7mtquCdR7+cDMuDpHihG+gDJTcQa1cM2o7ZU=";
    patches = [ ./bump-lang.patch ];
  };
}
