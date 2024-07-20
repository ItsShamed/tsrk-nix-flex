self: super:

{
  rofi-power-menu = super.rofi-power-menu.overrideAttrs (selfAttrs: superAttrs: {
    buildPhase = ''
      # Logging out with logind doesn't give pretty good results with i3
      # Let's just stick to exiting i3 manually
      sed -i 's@loginctl terminate-session ''${XDG_SESSION_ID-}@i3-msg exit@' rofi-power-menu
    '';
  });
}
