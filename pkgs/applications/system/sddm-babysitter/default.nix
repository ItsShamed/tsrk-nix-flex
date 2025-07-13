{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage (self: {
  pname = "sddm-babysitter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ItsShamed";
    repo = "sddm-babysitter";
    tag = self.version;
    hash = "sha256-KfmIkyryTKbKaJp+nltsD8VvRRFkDvbcVY5C2xCc35w=";
  };

  cargoHash = "sha256-C+JZeJNa8dfFFbMLv5bIIJAFquMPb4v3+xl8bqHEQUk=";

  meta = {
    description = "A daemon to babysit SDDM that will cry if its helper dies";
    homepage = "https://github.com/ItsShamed/sddm-babysitter";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
