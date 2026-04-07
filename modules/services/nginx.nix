{pkgs, ...}: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;
    virtualHosts."_" = {
      default = true;
      extraConfig = "absolute_redirect off;";
      locations."= /wallpaper.jpg" = {
        alias = ../../dotfiles/sway/wallpaper.jpg;
      };
      locations."/code/" = {
        proxyPass = "http://[::1]:4444/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_redirect / /code/;
          proxy_set_header Accept-Encoding "";
        '';
      };
      locations."/prowlarr/" = {
        proxyPass = "http://127.0.0.1:9696";
      };
      locations."/flaresolverr/" = {
        proxyPass = "http://127.0.0.1:8191/";
      };
      locations."/aria/" = {
        alias = "${pkgs.ariang}/share/ariang/";
        index = "index.html";
      };
      locations."/jsonrpc" = {
        proxyPass = "http://[::1]:6800/jsonrpc";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
