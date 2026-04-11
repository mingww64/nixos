{pkgs, config, ...}: {
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age.keyFile = "/home/felicia/.config/sops/age/keys.txt";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.ucla_passwd = {};
    secrets.pikpak_pass = {};
    secrets.pikpak_bearer_token = {};
    secrets.gemini_api_key = {
      owner = "felicia";
    };
    secrets.lastfm_key = {
      owner = "felicia";
    };
    secrets.lastfm_secret = {
      owner = "felicia";
    };
  };

  sops.templates."rclone.conf" = {
    content = ''
      [pikpak]
      type = webdav
      url = dav.mypikpak.com
      vendor = other
      user = wfib
      pass = ${config.sops.placeholder.pikpak_pass}
      bearer_token = ${config.sops.placeholder.pikpak_bearer_token}
    '';
    owner = "felicia";
  };

  sops.templates."rescrobbled/config.toml" = {
    content = ''
      lastfm-key = "${config.sops.placeholder.lastfm_key}"
      lastfm-secret = "${config.sops.placeholder.lastfm_secret}"
    '';
    owner = "felicia";
    path = "/home/felicia/.config/rescrobbled/config.toml";
  };

  sops.templates."gemini-vars" = {
    content = ''
      export GEMINI_API_KEY=${config.sops.placeholder.gemini_api_key}
      export GOOGLE_API_KEY=${config.sops.placeholder.gemini_api_key}
    '';
    owner = "felicia";
  };

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
