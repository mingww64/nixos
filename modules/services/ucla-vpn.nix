{config, lib, pkgs, ...}:
{
  networking.openconnect.interfaces = {
    openconnect0 = {
    autoStart = false;
    gateway = "ssl.vpn.ucla.edu";
    passwordFile = config.sops.secrets.ucla_passwd.path;
    protocol = "anyconnect";
    user = "mingww64@ucla.edu";
    extraOptions = { useragent = "AnyConnect"; };
    };
  };
  environment.systemPackages = with pkgs; [
    openconnect
    ];
}
