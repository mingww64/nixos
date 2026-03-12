{
  config,
  pkgs,
  ...
}: {
  # Bootloader configuration
  boot.loader.systemd-boot.enable = false; # Disabled in favor of GRUB for Brunch
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    # Brunch configuration entries
    extraEntries = ''
      submenu 'Brunch' {
      menuentry 'Brunch' --class 'brunch' {
      	img_path="/home/felicia/cros/Brunch.img"
      	img_uuid="98d1b025-3067-9246-b025-ae7e71996255"
      	search --no-floppy --set=root --file ''${img_path}
      	loopback loop ''${img_path}
      	source (loop,12)/efi/boot/settings.cfg
      	if [ -z ''${verbose} ] -o [ ''${verbose} -eq 0 ]; then
      		linux (loop,7)''${kernel} boot=local noresume noswap loglevel=7 options=''${options} chromeos_bootsplash=''${chromeos_bootsplash} ''${cmdline_params} \
      			cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path} \
      			console= vt.global_cursor_default=0 brunch_bootsplash=''${brunch_bootsplash} quiet
      	else
      		linux (loop,7)''${kernel} boot=local noresume noswap loglevel=7 options=''${options} chromeos_bootsplash=''${chromeos_bootsplash} ''${cmdline_params} \
      			cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
      	fi
      	initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
      }
      menuentry 'Brunch settings' --class 'brunch-settings' {
      	img_path="/home/felicia/cros/Brunch.img"
      	img_uuid="98d1b025-3067-9246-b025-ae7e71996255"
      	search --no-floppy --set=root --file ''${img_path}
      	loopback loop ''${img_path}
      	source (loop,12)/efi/boot/settings.cfg
      	linux (loop,7)/kernel boot=local noresume noswap loglevel=7 options= chromeos_bootsplash= edit_brunch_config=1 \
      		cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
      	initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
      }
      }
    '';
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = ["amdgpu"];
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
