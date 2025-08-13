{ icedosLib, lib, ... }:

let
  inherit (icedosLib)
    mkBoolOption
    mkNumberOption
    mkStrListOption
    mkStrOption
    ;
in
{
  options.icedos =
    let
      hyprland = (fromTOML (lib.fileContents ./config.toml)).icedos.desktop.hyprland;
    in
    {
      desktop.hyprland = {
        plugins = {
          cs2fix = {
            enable = mkBoolOption { default = false; };
            width = mkNumberOption { default = 0; };
            height = mkNumberOption { default = 0; };
          };

          hyprspace = mkBoolOption { default = false; };

          hyproled = {
            enable = mkBoolOption { default = false; };
            startWidth = mkNumberOption { default = 0; };
            startHeight = mkNumberOption { default = 0; };
            endWidth = mkNumberOption { default = 0; };
            endHeight = mkNumberOption { default = 0; };
          };
        };

        settings = {
          animations = {
            enable = mkBoolOption { default = true; };
            bezierCurve = mkStrOption { default = hyprland.settings.animations.bezierCurve; };
            speed = mkNumberOption { default = hyprland.settings.animations.speed; };
          };

          followMouse = mkNumberOption { default = 1; };
          secondsToLowerBrightness = mkNumberOption { default = 60; };
          startupScript = mkStrOption { default = ""; };
          windowRules = mkStrListOption { default = [ ]; };
        };
      };
    };

  outputs.nixosModules =
    { ... }:
    [
      (
        {
          lib,
          pkgs,
          ...
        }:

        let
          inherit (lib) attrNames filterAttrs;

          getModules =
            path:
            map (dir: ./. + ("/modules/" + dir)) (
              attrNames (filterAttrs (_: v: v == "directory") (builtins.readDir path))
            );
        in
        {
          imports = getModules ./modules;

          programs.hyprland = {
            enable = true;
            withUWSM = true;
          };

          environment = {
            systemPackages = with pkgs; [
              baobab # Disk usage analyser
              file-roller # Archive file manager
              gnome-disk-utility # Disks manager
              gnome-keyring # Keyring daemon
              gnome-online-accounts # Nextcloud integration
              gnome-themes-extra # Adwaita GTK theme
              hyprshade # Shader config tool
              wdisplays # Displays manager
            ];
          };

          services = {
            dbus = {
              enable = true;
              implementation = "broker";
            };

            gnome.gnome-keyring.enable = true;
          };

          security = {
            polkit.enable = true;
            pam.services.login.enableGnomeKeyring = true;
          };

          xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        }
      )
    ];

  meta.name = "default";
}
