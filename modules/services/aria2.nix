{
  config,
  ...
}: let
  getFormattedTrackerList = url: sha256:
    builtins.replaceStrings ["\n"] [","] (builtins.replaceStrings ["\n\n"] ["\n"]
      (
        builtins.readFile
        (builtins.fetchurl {
          inherit url sha256;
        })
      ));

  trackerList = getFormattedTrackerList "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt" "0kckb5qwmy8qp8fh8gbbfc0z679mvhxag9vl4n14hdgbjc56477v";
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
