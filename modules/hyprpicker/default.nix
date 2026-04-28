{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.hyprpicker ];

  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland.settings.bind = [ "$mainMod, C, exec, hyprpicker --autocopy" ];
    }
  ];
}
