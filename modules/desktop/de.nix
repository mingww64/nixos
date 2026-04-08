{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  services.gnome.gnome-keyring.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.dbus.enable = true;
  services.blueman.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = mkDefault [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-termfilechooser
      (pkgs.xdg-desktop-portal-gtk.override {
        # Do not build portals that we already have.
        buildPortalsInGnome = false;
      })
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      sway = {
        default = lib.mkForce [ "termfilechooser" "gtk" "wlr" ];
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = [ pkgs.polkit_gnome ];

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.gnome.gparted" && subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [
      pkgs.qt6Packages.fcitx5-chinese-addons
      pkgs.fcitx5-rime
      pkgs.fcitx5-gtk
    ];
  };

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = false;
    packages = [
      pkgs.nerd-fonts.symbols-only
      pkgs.nerd-fonts.meslo-lg
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-emoji-blob-bin
      pkgs.noto-fonts
      pkgs.nerd-fonts."m+"
      pkgs.nerd-fonts.hack
      pkgs.nerd-fonts.bigblue-terminal
      pkgs.roboto
      pkgs.roboto-mono
      pkgs.noto-fonts-cjk-serif
    ];
    fontconfig = {
      #localConf = (builtins.readFile ./local.conf);
      defaultFonts = {
        emoji = ["Blobmoji" "Symbols Nerd Font"];
        monospace = ["Hack Nerd Font Mono" "Roboto Mono" "Noto Sans Mono" "Blobmoji" "Symbols Nerd Font Mono" "MesloLGS Nerd Font Mono"];
        sansSerif = ["Roboto" "Noto Sans" "Blobmoji" "Symbols Nerd Font"];
        serif = ["Noto Serif" "Blobmoji" "Symbols Nerd Font"];
      };
    };
  };
}
