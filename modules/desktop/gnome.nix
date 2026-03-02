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
  };
  services.desktopManager = {
    gnome.enable = true;
  };
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "sway";
        user = "felicia";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
