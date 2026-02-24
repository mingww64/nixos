{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.direnv.enable = true;
  programs.corectrl.enable = true;
  programs.nix-ld.enable = true;

  services.prowlarr.enable = true;
  services.flaresolverr.package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw;
  services.flaresolverr.enable = true;

  services.code-server.enable = true;

  environment.systemPackages = with pkgs; [
    droidcam
    gcc
    gnumake
    cmake
    git
    p7zip
    unzip
    nodejs
    libimobiledevice
    ifuse
    nnn
    mlocate
    roc-toolkit
    wget
    cargo
    go
    steam-devices-udev-rules
    exfatprogs
  ];

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
