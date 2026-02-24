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
  # systemd.tmpfiles.rules = [
  #  ''f+ /run/gdm/.config/monitors.xml - gdm gdm - <monitors version="2"><configuration><logicalmonitor><x>0</x><y>0</y><scale>2</scale><primary>yes</primary><monitor><monitorspec><connector>DP-1</connector><vendor>SAM</vendor><product>U28E850</product><serial>HCJHA01068</serial></monitorspec><mode><width>3840</width><height>2160</height><rate>59.997</rate></mode></monitor></logicalmonitor><disabled><monitorspec><connector>HDMI-1</connector><vendor>SAM</vendor><product>U28E850</product><serial>HCHMC00802</serial></monitorspec></disabled></configuration><configuration><logicalmonitor><x>0</x><y>0</y><scale>2</scale><primary>no</primary><transform><rotation>left</rotation><flipped>no</flipped></transform></logicalmonitor></configuration></monitors>''
  # ];
}
