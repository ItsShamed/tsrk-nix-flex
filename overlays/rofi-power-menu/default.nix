self: super:

{
  rofi-power-menu = super.rofi-power-menu.overrideAttrs (selfAttrs: superAttrs: {
    patches = [
      ./patches/0001-refactor-allow-passing-logout-command.patch
    ];
  });
}
