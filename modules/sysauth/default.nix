{ pkgs, ... }:

let
  package = pkgs.sysauth;
in
{
  environment.systemPackages = [ package ];

  home-manager.sharedModules = [
    {
      systemd.user.services.sysauth = {
        Unit = {
          Description = "Sysauth - Polkit authentication agent";
          StartLimitIntervalSec = 60;
          StartLimitBurst = 60;
        };

        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          ExecStart = "${package}/bin/sysauth";
          Nice = "-20";
          Restart = "on-failure";
        };
      };

      xdg.configFile."sys64/auth/style.css".text = ''
        #sysauth .box_layout {
          background: @theme_bg_color;
        }
      '';
    }
  ];

  nixpkgs.overlays = [
    (final: super: {
      sysauth = final.callPackage ./package.nix { };
    })
  ];
}
