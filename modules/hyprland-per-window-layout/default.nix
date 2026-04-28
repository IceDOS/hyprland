{ pkgs, ... }:

let
  package = pkgs.hyprland-per-window-layout;
in
{
  environment.systemPackages = [ package ];

  home-manager.sharedModules = [
    {
      systemd.user.services.hyprland-per-window-layout = {
        Unit = {
          Description = "Hyprland per window layout";
          StartLimitIntervalSec = 60;
          StartLimitBurst = 60;
        };

        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          ExecStart = "${package}/bin/hyprland-per-window-layout";
          Nice = "-20";
          Restart = "on-failure";
        };
      };
    }
  ];
}
