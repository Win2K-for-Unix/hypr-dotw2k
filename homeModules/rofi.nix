# Rofi launcher styled like the Windows 2000 "Run..." dialog.
#
# This module does not bind a key to launch rofi — hypr-dotw2k is generic
# and can't assume the importing config's Hyprland keybind syntax. Add
# your own bind, e.g. `bind = SUPER, R, exec, rofi -show drun`.
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.hypr-dotw2k;

  rofiTheme = ''
    /*
     * Windows 2000 Run dialog — silver face, blue accent, beveled border.
     */
    configuration {
      modi: "drun,run";
      show-icons: true;
      icon-theme: "Redmond97";
      font: "Tahoma 11";
      location: 0; /* center */
      yoffset: 0;
      xoffset: 0;
      width: 360;
      lines: 6;
      columns: 1;
      padding: 4px;
      border-radius: 0;
      border-width: 2px;
      background-color: #d4d0c8;
      border-color: #3c3b3b;
      text-color: #000000;
      display-drun: "Run...";
      drun-display-format: "{name}";
    }

    * {
      border-radius: 0;
    }

    window {
      background-color: #d4d0c8;
      border: 2px solid #3c3b3b;
      padding: 8px;
    }

    mainbox {
      background: transparent;
    }

    inputbar {
      background: linear-gradient(to bottom, #3168d5, #245edb);
      border-top: 1px solid #aabbdd;
      border-bottom: 1px solid #1a3c7e;
      padding: 4px 8px;
      spacing: 6px;
    }

    prompt {
      background: transparent;
      text-color: #ffffff;
      font: "Tahoma Bold 11";
    }

    entry {
      placeholder: "Type the name of a program or command...";
      placeholder-color: #ffffff;
      background: #ffffff;
      border: 1px solid #3c3b3b;
      text-color: #000000;
      padding: 2px 6px;
    }

    listview {
      background: transparent;
      lines: 6;
      columns: 1;
      spacing: 2px;
    }

    element {
      padding: 2px 6px;
      spacing: 6px;
      background-color: transparent;
      text-color: #000000;
      border: 1px solid transparent;
    }

    element selected {
      background-color: #1a4eb2;
      text-color: #ffffff;
      border: 1px solid #1a3c7e;
    }

    element-icon {
      size: 1.2em;
    }
  '';
in {
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = lib.mkForce true;
      package = lib.mkForce pkgs.rofi;
      theme = lib.mkForce rofiTheme;
    };
  };
}
