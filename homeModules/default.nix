# hypr-dotw2k — a Windows 2000 (Luna) desktop theme, as a portable
# Home-Manager module.
#
# This module is deliberately generic: it only touches universal
# Home-Manager option surfaces (programs.waybar, programs.rofi,
# services.swaync, wayland.windowManager.hyprland.settings, gtk.*,
# home.pointerCursor, home.sessionVariables) so it can complement ANY
# existing Hyprland + Home-Manager configuration, not just a specific
# flake's option tree.
#
# Every value this module sets uses `lib.mkForce`, so enabling
# `programs.hypr-dotw2k.enable` overrides whatever the importing
# configuration already set at those same option paths — regardless
# of import order.
#
# Not handled here (by design, since this module can't assume a
# particular Hyprland keybind DSL): binding a key to launch rofi.
# Add your own bind, e.g. `bind = SUPER, R, exec, rofi -show drun`.
{lib, ...}: {
  options.programs.hypr-dotw2k.enable =
    lib.mkEnableOption "the Windows 2000 (Luna) desktop theme";

  imports = [
    ./hyprland-decoration.nix
    ./waybar.nix
    ./swaync.nix
    ./theme.nix
    ./rofi.nix
  ];
}
