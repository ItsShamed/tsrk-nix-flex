{ gaming, lib, config, ... }:

{
  options = {
    tsrk.packages.more-gaming = {
      enable = lib.options.mkEnableOption "tsrk's \"More Gaming\" pacakge bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.more-gaming.enable {
    home.packages = [
      gaming.osu-lazer-bin
      gaming.osu-stable
    ];
  };
}
