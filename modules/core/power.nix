{...}: {
  # Hibernation Configuration
  # NOTE: Hibernation requires a swap file at least as large as RAM (32GB).
  # Run the provided instructions to set up the swap file and get the offset.
  boot.resumeDevice = "/dev/disk/by-uuid/1dc38181-1ce0-455c-9c08-6fd0b48d138c";
  boot.kernelParams = ["resume_offset=129884945"];

  # Hibernate after 30 minutes of inactivity
  services.logind = {
    settings = {
      Login = {
        IdleAction = "hibernate";
        IdleActionSec = "30min";
      };
    };
  };

  # Manage disk power with TLP
  services.tlp = {
    enable = true;
    settings = {
      DISK_DEVICES = "sda";
      DISK_APM_LEVEL_ON_AC = "127";
      DISK_APM_LEVEL_ON_BAT = "127";
      DISK_SPINDOWN_TIMEOUT_ON_AC = "120"; # 120 * 5s = 10 mins
      DISK_SPINDOWN_TIMEOUT_ON_BAT = "120";
    };
  };
}
