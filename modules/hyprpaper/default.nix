{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    hasPrefix
    mkIf
    optionalAttrs
    removePrefix
    ;

  package = pkgs.hyprpaper;
  globalWallpaper = config.icedos.desktop.wallpaper;
  isColor = hasPrefix "color:" globalWallpaper;
  isPath = !isColor && globalWallpaper != "";
  hyprWallpaper = removePrefix "path:" globalWallpaper;
  colorHex = removePrefix "color:" globalWallpaper;
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
        // optionalAttrs isPath {
          preload = hyprWallpaper;
          wallpaper = ", ${hyprWallpaper}";
        };
      };

      # hyprpaper can't render solid color. Compositor's misc.background_color
      # is what shows when no wallpaper is loaded — set it for the color case.
      wayland.windowManager.hyprland.settings.misc.background_color = mkIf isColor "0xff${colorHex}";
    }
  ];
}
