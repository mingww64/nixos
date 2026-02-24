# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  nixpkgs-tars = "https://github.com/NixOS/nixpkgs/archive/";
  pr277183 = import (fetchTarball
    "${nixpkgs-tars}48e8c4b748d2f3800ba09bfa130d8047cea0cac7.tar.gz")
  {config = config.nixpkgs.config;};
in {
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

    # Services
    ./modules/services/lan-mouse.nix
    ./modules/services/samba.nix
    ./modules/services/aria2.nix
    ./modules/services/rclone.nix
    ./modules/services/ucla-vpn.nix

    # Users
    ./users/felicia.nix
  ];
}
