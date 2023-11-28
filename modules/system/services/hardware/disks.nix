[ config, lib, ... ]:

{
  options = {
    tsrk.disk-management.enable = lib.options.mkEnableOption "disk managment";
  }

  config = lib.mkIf config.tsrk.disk-management.enable {
    services.udisks2.enable = lib.mkDefault true;
    programs.gnome-disks.enable = lib.mkDefault true;
  };
}
