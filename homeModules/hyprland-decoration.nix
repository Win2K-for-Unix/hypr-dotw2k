# Windows 2000 Hyprland decoration: flat, sharp-cornered windows with a
# silver/classic-blue border, no blur, no rounding.
#
# Only `config.general` and `config.decoration` are forced (not the whole
# `config` attrset) so that other Hyprland settings the importing config
# sets — input, misc, binds, env, etc. — are left untouched. Forcing the
# whole `config` value would silently wipe those out.
{
  config,
  lib,
  ...
}: let
  cfg = config.programs.hypr-dotw2k;
in {
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.config = {
      general = lib.mkForce {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        col.active_border = "rgba(10, 36, 106, 255)";
        col.inactive_border = "rgba(212, 208, 200, 255)";
      };

      decoration = lib.mkForce {
        rounding = 0;
        rounding_power = 1;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = false;
          size = 0;
          passes = 0;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 2;
          color = "rgba(0, 0, 0, 75)";
          offset = "1, 1";
        };
      };
    };
  };
}
