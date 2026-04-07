{
  lib,
  pkgs,
  ...
}: {
  # Hibernation Configuration
  # NOTE: Hibernation requires a swap file at least as large as RAM (32GB).
  # Run the provided instructions to set up the swap file and get the offset.
  boot.resumeDevice = "/dev/disk/by-uuid/1dc38181-1ce0-455c-9c08-6fd0b48d138c";
  boot.kernelParams = ["resume_offset=129884945"];

  # Default (Laptop) Power Configuration
  services.logind = {
    settings = {
      Login = {
        # Hibernate after 30 minutes of inactivity by default
        IdleAction = "hibernate";
        IdleActionSec = "30min";
        HandleLidSwitch = "suspend";
      };
    };
  };

  # Manage power with TLP
  services.tlp = {
    enable = true;
    settings = {
      # Enable WoWLAN (Wake on Wireless LAN)
      WOL_DISABLE = "N";

      DISK_DEVICES = "sda";
      DISK_APM_LEVEL_ON_AC = "127";
      DISK_APM_LEVEL_ON_BAT = "127";
      DISK_SPINDOWN_TIMEOUT_ON_AC = "10"; # 10 * 5s = 30 secs
      DISK_SPINDOWN_TIMEOUT_ON_BAT = "10";
    };
  };

  # Activation script to ensure WoWLAN is enabled at boot
  systemd.services.enable-wowlan = {
    description = "Enable WoWLAN for AX200";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      # iw dev wlp4s0 wowlan enable magic-packet sometimes fails if netdev is up,
      # but iw phy phy0 wowlan enable magic-packet usually works regardless.
      ExecStart = "${pkgs.iw}/bin/iw phy phy0 wowlan enable magic-packet";
      RemainAfterExit = true;
    };
  };

  # Server Specialization (Non-suspending, High-performance)
  specialisation.server.configuration = {
    services.logind.settings.Login = {
      IdleAction = lib.mkForce "ignore";
      HandleLidSwitch = lib.mkForce "ignore";
      HandleLidSwitchDocked = lib.mkForce "ignore";
      HandleLidSwitchExternalPower = lib.mkForce "ignore";
    };
    services.tlp.settings = {
      TLP_DEFAULT_MODE = lib.mkForce "AC";
      TLP_PERSISTENT_DEFAULT = lib.mkForce 1;
      DISK_APM_LEVEL_ON_AC = lib.mkForce "254";
      DISK_SPINDOWN_TIMEOUT_ON_AC = lib.mkForce "0";
    };
  };
}
