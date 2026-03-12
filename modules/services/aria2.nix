{
  config,
  lib,
  pkgs,
  ...
}: let
  getFormattedTrackerList = url: hash:
    builtins.replaceStrings ["\n"] [","] (builtins.replaceStrings ["\n\n"] ["\n"]
      (
        builtins.readFile
        (builtins.fetchurl {
          inherit url;
          sha256 = "1flk2c4l956151mr6qjcbni683ryyl1mkgpz27vv3w3h2g8if6fw";
        })
      ));

  trackerList = getFormattedTrackerList "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt" "1flk2c4l956151mr6qjcbni683ryyl1mkgpz27vv3w3h2g8if6fw";
in {
  services.aria2 = {
    enable = true;
    downloadDirPermission = "0770";
    serviceUMask = "0002";
    rpcSecretFile = config.users.users.felicia.home + "/aria2_rpc";
    settings = {
      rpc-allow-origin-all = true;
      input-file = "/var/lib/aria2/aria2.session";
      #      force-save = true;
      bt-tracker = trackerList;
    };
  };
}
