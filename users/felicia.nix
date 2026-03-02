{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  users.users.felicia = {
    isNormalUser = true;
    extraGroups = ["wheel" "aria2" "dialout"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      inputs.high-tide-repo.packages.${system}.high-tide
      inputs.antigravity-nix.packages.${system}.google-antigravity-no-fhs
      gh
      amule
      firefox
      moonlight-qt
      seahorse
      dconf-editor
      code-cursor
      gparted
      pavucontrol
      playerctl
      mpv
      lxmenu-data
      shared-mime-info
      remmina
      tidal-hifi
      google-chrome
      thunar
      xfce4-settings
      obs-studio
      qpwgraph
      easyeffects
      valent
      lan-mouse
      gnome-tweaks
      nixd
      alejandra
      nautilus
      nnn
      jq
    ];
  };

  # services.displayManager.autoLogin.user = "felicia";

  home-manager.users.felicia = {pkgs, ...}: {
    home.stateVersion = "22.11";

    services.rescrobbled = {
      enable = true;
      settings = {
        lastfm-key = "2ef331a96c0f0fa8367bfdd5c53b23cb";
        lastfm-secret = "77370bc219ed9c74404f0e293bbeda07";
      };
    };

    xdg.configFile."sway".source = ../dotfiles/sway;
    xdg.configFile."waybar".source = ../dotfiles/waybar;
    xdg.configFile."Code/User/settings.json".source = ../dotfiles/vscode/settings.json;
    xdg.configFile."Antigravity/User/settings.json".source = ../dotfiles/antigravity/settings.json;
    home.file.".base16".source = ../dotfiles/base16;

    wayland.windowManager.sway = {
      enable = true;
      extraSessionCommands = ''
        export NIXOS_OZONE_WL="1"
        export SDL_VIDEODRIVER="wayland"
        export _JAVA_AWT_WM_NONREPARENTING="1"
        export QT_QPA_PLATFORM="wayland"
        export MOZ_ENABLE_WAYLAND="1"
        export QT_SCREEN_SCALE_FACTORS="1;1"
        export XDG_CURRENT_DESKTOP="sway"
        export XDG_SESSION_DESKTOP="sway"
        export QT_QPA_PLATFORMTHEME="gnome"
        export XMODIFIERS="@im=fcitx"
        export GTK_IM_MODULE="fcitx"
        export QT_IM_MODULE="fcitx"
        export TERM="foot"
        export TERMINAL="foot"
      '';
    };

    gtk = {
      enable = true;
      theme = {
        name = "Orchis-Dark";
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "oomox-wallpaper";
      };
      font = {
        name = "Noto Sans";
        size = 10;
        package = pkgs.noto-fonts;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        monospace-font-name = "Hack Nerd Font Mono 10";
        color-scheme = "prefer-dark";
        document-font-name = "Noto Sans 12";
        font-antialiasing = "grayscale";
        font-hinting = "slight";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "icon:minimize,maximize,close";
        titlebar-font = "Noto Sans Bold 11";
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = ["<Control>Escape"];
        move-to-workspace-2 = ["<Shift><Super>2"];
        move-to-workspace-3 = ["<Shift><Super>3"];
        move-to-workspace-4 = ["<Shift><Super>4"];
        show-desktop = ["<Super>d"];
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        switch-to-workspace-last = ["<Super>0"];
      };
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
      };
    };

    home.packages = with pkgs; [
      # Sway / GUI utilities
      kickoff
      mako
      waybar
      xdg-utils
      xclip
      clipnotify
      wl-clipboard
      sway-contrib.grimshot
      glib
      wdisplays
      qgnomeplatform
      qgnomeplatform-qt6
      hyprpaper
      dmenu-wayland
      nwg-look
      linux-wallpaperengine
      networkmanagerapplet
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "nnn.desktop";
      };
    };
  };
}
