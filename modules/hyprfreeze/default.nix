{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.hyprfreeze ];

  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland.settings.bind = [ "$mainMod CTRL SHIFT, F, exec, hyprfreeze -a" ];
    }
  ];

  nixpkgs.overlays = [
    (final: super: {
      hyprfreeze = final.callPackage ./package.nix { };
    })
  ];
}
