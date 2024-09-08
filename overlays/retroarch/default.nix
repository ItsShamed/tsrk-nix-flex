self: super:

{
  retroarch = super.retroarch.override {
    cores = with super.libretro; [
      gw
      beetle-gba
      bsnes
      citra
      desmume
      dolphin
      dosbox
      gpsp
      mame
      melonds
      mesen
      meteor
      mgba
      mupen64plus
      pcsx2
      ppsspp
      sameboy
      snes9x
    ];
  };
}
