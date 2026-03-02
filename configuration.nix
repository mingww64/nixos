# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Core System
    ./modules/core/boot.nix
    ./modules/core/networking.nix
    ./modules/core/system.nix
    ./modules/core/packages.nix

    # Desktop Environments
    ./modules/desktop/de.nix
    ./modules/desktop/gnome.nix
    ./modules/desktop/ulauncher.nix

    # Services
    ./modules/services/vscode-server.nix
    ./modules/services/lan-mouse.nix
    ./modules/services/samba.nix
    ./modules/services/aria2.nix
    ./modules/services/rclone.nix
    ./modules/services/ucla-vpn.nix

    # Users
    ./users/felicia.nix
  ];
}
