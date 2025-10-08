{ icedosLib, ... }:

let
  inherit (builtins) readFile;

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
      animations = settings.animations;
      hyprland = (fromTOML (readFile ./config.toml)).icedos.desktop.hyprland;
      plugins = hyprland.plugins;
      settings = hyprland.settings;
    in
    {
      desktop.hyprland = {
        plugins = {
          cs2fix = {
            enable = mkBoolOption { default = plugins.cs2fix.enable; };
            width = mkNumberOption { default = plugins.cs2fix.width; };
            height = mkNumberOption { default = plugins.cs2fix.height; };
          };

          hyprspace = mkBoolOption { default = plugins.hyprspace; };

          hyproled = {
            enable = mkBoolOption { default = plugins.hyproled.enable; };
            startWidth = mkNumberOption { default = plugins.hyproled.startWidth; };
            startHeight = mkNumberOption { default = plugins.hyproled.startHeight; };
            endWidth = mkNumberOption { default = plugins.hyproled.endWidth; };
            endHeight = mkNumberOption { default = plugins.hyproled.endHeight; };
          };
        };

        settings = {
          animations = {
            enable = mkBoolOption { default = animations.enable; };
            bezierCurve = mkStrOption { default = animations.bezierCurve; };
            speed = mkNumberOption { default = animations.speed; };
          };

          followMouse = mkNumberOption { default = settings.followMouse; };
          secondsToLowerBrightness = mkNumberOption { default = settings.secondsToLowerBrightness; };
          startupScript = mkStrOption { default = settings.startupScript; };
          windowRules = mkStrListOption { default = settings.windowRules; };
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
