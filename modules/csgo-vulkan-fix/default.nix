{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (config.icedos.desktop.hyprland.plugins) cs2fix;
in
mkIf cs2fix.enable {
  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland = {
        plugins = [ pkgs.hyprlandPlugins.csgo-vulkan-fix ];

        settings.plugin = [
          {
            csgo-vulkan-fix = {
              res_w = cs2fix.width;
              res_h = cs2fix.height;
              class = "cs2";
            };
          }
        ];
      };
    }
  ];
}
