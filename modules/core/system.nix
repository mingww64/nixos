{
  config,
  pkgs,
  ...
}: {
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

  nix.extraOptions = ''
    extra-experimental-features = flakes nix-command
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
