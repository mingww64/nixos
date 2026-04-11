{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.rclone ];

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
