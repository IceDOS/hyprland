{
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) makeBinPath;
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
{
  home-manager.sharedModules = [
    {
      systemd.user = {
        services.eye-wellbeing = {
          Unit.Description = "Eye Wellbeing - Informs user for periodical eye rest";
          Install.WantedBy = [ "graphical-session.target" ];

          Service = {
            ExecStart = ''
              ${
                makeBinPath [
                  (pkgs.writeShellScriptBin "eye-wellbeing" ''
                    "${pkgs.procps}/bin/pidof" hyprlock || "${notify-send}" "System" "Take a 20-second break to look at something 6 meters away"
                  '')
                ]
              }/eye-wellbeing
            '';
          };
        };

        timers.eye-wellbeing = {
          Unit.Description = "Timer for eye-wellbeing";

          Timer = {
            Unit = "eye-wellbeing.service";
            OnBootSec = "20m";
            OnUnitActiveSec = "20m";
            AccuracySec = "20m";
          };

          Install.WantedBy = [ "timers.target" ];
        };
      };
    }
  ];
}
