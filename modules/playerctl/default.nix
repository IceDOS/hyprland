{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.playerctl ];

  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland.settings.bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
    }
  ];
}
