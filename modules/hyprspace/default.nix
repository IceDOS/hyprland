{
  config,
  icedosLib,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mapAttrs
    mkIf
    ;

  cfg = config.icedos;

  accentColor = icedosLib.generateAccentColor {
    accentColor = cfg.desktop.accentColor;
    gnomeAccentColor = cfg.desktop.gnomeAccentColor;
    hasGnome = lib.hasAttr "gnome" cfg.desktop;
  };
in
mkIf (cfg.desktop.hyprland.plugins.hyprspace) {
  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland = {
      plugins = [ pkgs.hyprlandPlugins.hyprspace ];

      settings = {
        bind = [
          "$mainMod, TAB, overview:toggle"
          "$mainMod SHIFT, TAB, overview:toggle, all"
        ];

        plugin = [
          {
            overview = {
              gapsIn = 5;
              gapsOut = 5;
              panelHeight = 100;
              showEmptyWorkspace = false;
              showNewWorkspace = false;
              workspaceActiveBorder = accentColor;
            };
          }
        ];
      };
    };
  }) cfg.users;
}
