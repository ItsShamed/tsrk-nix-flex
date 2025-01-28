{ chatterino2, lib, fetchFromGitHub }:

chatterino2.overrideAttrs (self: super: {
  pname = "chatterino7";
  version = "7.5.2";
  src = fetchFromGitHub {
    owner = "SevenTV";
    repo = self.pname;
    rev = "v${self.version}";
    hash = "sha256-kQeW9Qa8NPs47xUlqggS4Df4fxIoknG8O5IBdOeIo+4=";
    fetchSubmodules = true;
  };
  meta = with lib; {
    description = "Chat client for Twitch chat";
    mainProgram = "chatterino";
    longDescription = ''
      Chatterino is a chat client for Twitch chat. It aims to be an
      improved/extended version of the Twitch web chat. Chatterino 2 is
      the second installment of the Twitch chat client series
      "Chatterino".
    '';
    homepage = "https://github.com/SevenTV/chatterino7";
    changelog =
      "https://github.com/SevenTV/chatterino7/blob/master/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rexim supa ];
  };
})
