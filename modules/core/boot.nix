{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
canTouchEfiVariables = true;
efiSysMountPoint = "/boot/efi";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "amdgpu" ];
  # Extra kernel modules
  boot.extraModulePackages = [
#    config.boot.kernelPackages.v4l2loopback
     config.boot.kernelPackages.ryzen-smu
  ];

  # Register a v4l2loopback device at boot
  boot.kernelModules = [
    "v4l2loopback"
    "nct6775"
    "ryzen_smu"
  ];
}
