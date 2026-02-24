{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  # hardware.pulseaudio.enable = mkForce false;
  services.gnome.core-apps.enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
  };
  services.displayManager = {
    defaultSession = "sway";
    gdm = {
      enable = true;
      wayland = true;
    };
  };
  services.desktopManager = {
    gnome.enable = true;
  };
  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          scaling-factor = lib.gvariant.mkUint32 2;
        };
      };
    }
  ];
}
