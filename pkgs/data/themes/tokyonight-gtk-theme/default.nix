{ lib
, gtk-engine-murrine
, gnome-themes-extra
, sassc
, stdenv
, fetchFromGitHub
, tweaks ? []
}:

assert let
  isValidTweak = tweak: builtins.any (s: tweak == s) [
    "storm"
    "moon"
    "black"
    "float"
    "outline"
    "macos"
  ];
in builtins.all isValidTweak tweaks;

let
  tweaksArg = lib.strings.optionalString (tweaks != [])
    " --tweaks ${builtins.concatStringsSep " " tweaks}";
  tweakSuffixes = lib.strings.optionalString (tweaks != [])
    ("_" + (builtins.concatStringsSep "-" tweaks));
in
stdenv.mkDerivation rec {
  pname = "tokyonight-gtk-theme${tweakSuffixes}";
  version = "unstable-2024-07-22";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyonight-GTK-Theme";
    rev = "a9a25010e9fbfca783c3c27258dbad76a9cc7842";
    hash = "sha256-HbrDDiMej4DjvskGItele/iCUY1NzlWlu3ZneA76feM=";
  };

  propagatedBuildInputs = [
    gnome-themes-extra
    gtk-engine-murrine
    sassc
  ];


  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -vp $out/share/{themes,icons,tokyonight-gtk-theme}
    cp -av LICENSE $out/share/tokyonight-gtk-theme

    (cd themes; bash install.sh -t all -n TokyoNight -d $out/share/themes${tweaksArg})
    cp -a icons/* $out/share/icons/

    mkdir -pv $out/nix-support

    ${lib.strings.concatStrings (lib.forEach propagatedBuildInputs (input:
      ''
        echo "${input}" >> $out/nix-support/propagated-user-env-packages
      ''
    ))}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A GTK theme based on the Tokyo Night colour palette";
    homepage = "https://www.pling.com/p/1681315";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
  };
}
