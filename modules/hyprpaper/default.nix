{
  config,
  lib,
  pkgs,
  ...
}:

let
  package = pkgs.hyprpaper;
  globalWallpaper = config.icedos.desktop.wallpaper;
  isColor = lib.hasPrefix "color:" globalWallpaper;
  isPath = !isColor && globalWallpaper != "";
  hyprWallpaper = lib.removePrefix "path:" globalWallpaper;
  colorHex = lib.removePrefix "color:" globalWallpaper;
in
{
  environment.systemPackages = [ package ];

  home-manager.sharedModules = [
    {
      services.hyprpaper = {
        enable = true;

        settings = {
          ipc = "off";
        }
        // lib.optionalAttrs isPath {
          preload = hyprWallpaper;
          wallpaper = ", ${hyprWallpaper}";
        };
      };

      # hyprpaper can't render solid color. Compositor's misc.background_color
      # is what shows when no wallpaper is loaded — set it for the color case.
      wayland.windowManager.hyprland.settings.misc.background_color = lib.mkIf isColor "0xff${colorHex}";
    }
  ];
}
