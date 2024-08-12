{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
    initrd.luks.devices = {
      cryptlvm.device = "/dev/disk/by-label/cryptlvm";
      crypthome.device = "/dev/disk/by-label/crypthome";
    };
  };

  fileSystems = {
    "/" = {
      label = "trenroot";
      fsType = "ext4";
    };
    "/boot" = {
      label = "EFI";
      fsType = "vfat";
    };
    "/home" = {
      label = "trenhome";
      fsType = "ext4";
      neededForBoot = true;
    };
  };

  swapDevices = [
    { label = "trenswap"; }
  ];
}
