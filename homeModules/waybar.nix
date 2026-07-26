/*
 * Windows 2000 taskbar for waybar — bottom-positioned, periwinkle blue
 * gradient, beveled buttons, no rounding, no transparency.
 */
{
  config,
  lib,
  ...
}: let
  cfg = config.programs.hypr-dotw2k;
in {
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = lib.mkForce true;
      systemd.enable = lib.mkForce true;
      style = lib.mkForce (builtins.readFile ./waybar-style.css);
      settings.main = lib.mkForce (builtins.fromJSON (builtins.readFile ./waybar-config.json));
    };
  };
}
