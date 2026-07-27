# Windows 2000 style for swaync notifications — silver chrome, beveled
# edges, sharp corners, blue titlebar strip.
{
  config,
  lib,
  ...
}: let
  cfg = config.programs.hypr-dotw2k;
in {
  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = lib.mkForce true;
      style = lib.mkForce ./swaync-style.css;
    };
  };
}
