{config, lib, pkgs, ...}:
{
  networking.openconnect.interfaces = {
    openconnect0 = {
    autoStart = false;
    gateway = "ssl.vpn.ucla.edu";
    passwordFile = "/etc/nixos/ucla_passwd";
    protocol = "anyconnect";
    user = "mingww64@ucla.edu";
    extraOptions = { useragent = "AnyConnect"; };
    };
  };
  environment.systemPackages = with pkgs; [
    openconnect
    ];
}
