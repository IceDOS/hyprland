{ pkgs, ... }:

let
  package = pkgs.poweralertd;
in
{
  environment.systemPackages = [ package ];

  home-manager.sharedModules = [
    {
      systemd.user.services.poweralertd = {
        Unit = {
          Description = "Poweralertd - UPower-powered power alerter";
          StartLimitIntervalSec = 60;
          StartLimitBurst = 60;
        };

        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          ExecStart = "${package}/bin/poweralertd";
          Nice = "-20";
          Restart = "on-failure";
        };
      };
    }
  ];
}
