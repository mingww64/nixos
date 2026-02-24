{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.rclone ];
  environment.etc."rclone-mnt.conf".text = ''
    [pikpak]
type = webdav
url = dav.mypikpak.com
vendor = other
user = wfib
pass = 4isKsrmS_Sq7IdQqfB_kKi_7lSDR_SO6
bearer_token = d2ZpYjpjc3hld25keg==  '';



  systemd.mounts = [
    {
      where = "/mnt/OneDrive";
      what = "onedrive:/";
      type = "rclone";
      # Corrected: options must be a single string with comma-separated values
      options = "nodev,nofail,allow_other,args2env,config=${config.users.users.felicia.home + "/.config/rclone/rclone.conf"}";
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    }
    {
      where = "/mnt/GDrive";
      what = "gdrive:/";
      type = "rclone";
      # Corrected: options must be a single string with comma-separated values
      options = "nodev,nofail,allow_other,args2env,config=${config.users.users.felicia.home + "/.config/rclone/rclone.conf"}";
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    }
    {
      where = "/mnt/PikPak";
      what = "Pik:/";
      type = "rclone";
      # Corrected: options must be a single string with comma-separated values
      options = "nodev,nofail,allow_other,args2env,config=${config.users.users.felicia.home + "/.config/rclone/rclone.conf"}";
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    }
  ];
}
