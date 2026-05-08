{
  config,
  icedosLib,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) hasAttr mkIf;
  inherit (config.icedos) desktop;
  inherit (desktop) gnome hyprland;

  accentColor = icedosLib.generateAccentColor {
    inherit (desktop) accentColor;
    gnomeAccentColor = gnome.accentColor;
    hasGnome = hasAttr "gnome" desktop;
  };
in
mkIf hyprland.plugins.hyprspace {
  home-manager.sharedModules = [
    {
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
    }
  ];
}
