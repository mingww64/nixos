{ pkgs, ... }:

{
  # Define your service (ircSession in this case)
  systemd.services.lan-mouse = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Start the lan-mouse client of felicia.";
    serviceConfig = {
      Type = "simple";
      User = "felicia";
      ExecStart = " ${pkgs.bash}/bin/bash -c 'XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.lan-mouse}/bin/lan-mouse -d'";
    };
  };

  # Install necessary packages (lan-mouse in this case)
  environment.systemPackages = [ pkgs.lan-mouse ];

}

