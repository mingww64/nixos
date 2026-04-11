{ pkgs, ... }:

{
  # Define your service (ircSession in this case)
  systemd.services.lan-mouse = {
    after = [ "network.target" "graphical-session.target" ];
    description = "lan-mouse client of felicia.";
    serviceConfig = {
      Type = "simple";
      User = "felicia";
      Environment = "XDG_RUNTIME_DIR=/run/user/1000";
      ExecStart = "${pkgs.lan-mouse}/bin/lan-mouse -d";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    unitConfig.ConditionUser = "felicia";
  };

  # Install necessary packages (lan-mouse in this case)
  environment.systemPackages = [ pkgs.lan-mouse ];

}
