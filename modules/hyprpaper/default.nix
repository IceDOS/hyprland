{ pkgs, ... }:

let
  package = pkgs.hyprpaper;
in
{
  environment.systemPackages = [ package ];

  home-manager.sharedModules = [
    {
      services.hyprpaper = {
        enable = true;

        settings = {
          preload = "~/Pictures/wallpaper.jpg";
          wallpaper = ", ~/Pictures/wallpaper.jpg";
          ipc = "off";
        };
      };
    }
  ];
}
