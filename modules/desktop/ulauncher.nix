{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "ulauncher-with-extensions";
      paths = [inputs.ulauncher6.packages.${system}.ulauncher6];
      buildInputs = [pkgs.makeWrapper pkgs.gnused];
      postBuild = let
        upkgs = inputs.ulauncher6.packages.${system}.ulauncher6.pythonModule.pkgs;
      in ''
        # Wrap the binary to EXPORT essential environment variables
        wrapProgram $out/bin/ulauncher \
          --prefix PYTHONPATH : "${upkgs.makePythonPath [
          upkgs.dbus-python
          upkgs.pyxdg
          upkgs.fuzzywuzzy
          upkgs.pip
          upkgs.pytz
          upkgs.requests
        ]}" \
          --prefix GI_TYPELIB_PATH : "${pkgs.lib.makeSearchPath "lib/girepository-1.0" [pkgs.libnotify]}" \
          --prefix PATH : "${pkgs.lib.makeBinPath [pkgs.wl-clipboard pkgs.libnotify]}"

        # Patch D-Bus and Systemd services to use our master wrapper
        for file in share/dbus-1/services/io.ulauncher.Ulauncher.service \
                    share/systemd/user/ulauncher.service; do
          if [ -e "$out/$file" ]; then
            rm "$out/$file"
            cp "${inputs.ulauncher6.packages.${system}.ulauncher6}/$file" "$out/$file"
            sed -i "s|Exec.*=.*ulauncher|Exec=$out/bin/ulauncher|g" "$out/$file"
          fi
        done
      '';
    })
  ];
}
