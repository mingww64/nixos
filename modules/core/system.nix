{
  config,
  pkgs,
  ...
}: {
  boot.kernelModules = ["ufs"];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  services.udev.packages = with pkgs; [platformio-core.udev];

  virtualisation.docker = {
    enable = false; # Consider disabling the system-wide daemon
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  hardware.graphics.enable = true;

  services.gvfs.enable = true;
  services.usbmuxd.enable = true;
  services.flatpak.enable = true;
  services.envfs.enable = true;

  nix.extraOptions = ''
    extra-experimental-features = flakes nix-command
  '';

  environment.variables = {
    SUDO_ASKPASS = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };

  environment.shellAliases = {
    sysup = "sudo nixos-rebuild switch --flake /etc/nixos#desktop";
    sysupdate = "nix flake update /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#desktop";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
