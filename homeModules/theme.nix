# Windows 2000 (Luna) GTK/Qt/icon/cursor/font theme.
#
# Sources:
#   - GTK theme : github:Win2K-for-Unix/Win2K-GTK (flake input `win2k-gtk`).
#                 The upstream repo has been patched to use the W2K silver
#                 (#d4d0c8) / classic blue (#0a246a) palette; this flake
#                 tracks the latest commit on `main`.
#   - Icons    : github:matthewmx86/WinClassic_icons (flake input
#                `win2k-icons`) — installs the `Redmond97` directory.
#   - Cursors  : "classic-1" cursor set (rw-designer.com/cursor-set/classic-1),
#                public domain, ripped from user32.dll. Fetched as a ZIP and
#                converted from .cur to Xcursor format via win2xcur. The
#                identifiable cursors (arrow, text, wait, hand, resize, etc.)
#                are aliased to their standard X11 names; the rest install
#                under their original numbered names.
#   - Font     : `pkgs.corefonts` (nixpkgs-packaged Microsoft core fonts,
#                which includes Tahoma.ttf). Unfree — requires
#                `nixpkgs.config.allowUnfreePredicate` (or `allowUnfree`)
#                to be set for the Microsoft EULA package to build.
#
# Uses `home.sessionVariables` (not `environment.sessionVariables`) since
# this module must work standalone under plain Home-Manager, not only
# inside a NixOS + Home-Manager combined module system.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.programs.hypr-dotw2k;

  # The upstream Win2K-GTK repo ships gtk-2.0/, gtk-3.0/, metacity-1/.
  # Copy everything into $out/share/themes/Win2K-GTK/.
  gtkTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "win2k-gtk-theme";
    version = inputs.win2k-gtk.rev or "unstable";
    src = inputs.win2k-gtk;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/themes/Win2K-GTK"
      cp -r "$src"/. "$out/share/themes/Win2K-GTK/"
      chmod -R u+w "$out/share/themes/Win2K-GTK"
      # Upstream ships CSS only — write an index.theme so GTK can discover it.
      cat > "$out/share/themes/Win2K-GTK/index.theme" <<'EOF'
      [Desktop Entry]
      Type=X-GNOME-Metatheme
      Name=Win2K-GTK
      Comment=Windows 2000 GTK theme
      Encoding=UTF-8

      [X-GNOME-Metatheme]
      GtkTheme=Win2K-GTK
      MetacityTheme=Win2K-GTK
      IconTheme=Redmond97
      EOF
      runHook postInstall
    '';

    meta = {
      description = "Windows 2000 GTK theme (Win2K-for-Unix/Win2K-GTK)";
      homepage = "https://github.com/Win2K-for-Unix/Win2K-GTK";
      license = lib.licenses.gpl3;
      platforms = [pkgs.stdenv.hostPlatform.system];
    };
  };

  # Icon theme — WinClassic_icons (Redmond97) sourced from a flake input.
  # The upstream ships under "Icon Theme/Redmond97/" — install the inner
  # directory (the one with index.theme) directly into $out/share/icons.
  iconTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "redmond97-icons";
    version = inputs.win2k-icons.rev or "unstable";
    src = inputs.win2k-icons;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/icons"
      cp -r "$src/Icon Theme/Redmond97/." "$out/share/icons/"
      chmod -R u+w "$out/share/icons"
      runHook postInstall
    '';

    meta = {
      description = "Redmond97 icon theme (WinClassic_icons)";
      homepage = "https://github.com/matthewmx86/WinClassic_icons";
      license = lib.licenses.gpl3;
      platforms = [pkgs.stdenv.hostPlatform.system];
    };
  };

  # Cursor theme — "classic-1" set (rw-designer.com), Windows XP/2000 cursors
  # ripped from user32.dll, released to the public domain. The archive ships
  # raw .cur files (no index.theme), so we convert each to Xcursor format
  # with win2xcur and alias the identifiable ones to their standard X11
  # names. Unidentified cursors are still installed under their original
  # names so nothing is silently dropped.
  cursorTheme = let
    # filename (without .cur) -> list of X11 cursor names to alias to it.
    # Identified by visual inspection of the pack.
    aliases = {
      "Original Arrow Windows 95" = ["default" "left_ptr" "arrow" "top_left_arrow"];
      "Beam" = ["text" "xterm" "ibeam"];
      "Cursor_3" = ["wait" "watch"];
      "Cursor_12" = ["progress" "half-busy"];
      "Cursor_13" = ["help" "whats_this" "question_arrow"];
      "Cursor_15" = ["pointer" "hand1" "hand2" "pointing_hand"];
      "Cursor_11" = ["not-allowed" "no-drop" "crossed_circle" "forbidden"];
      "Cursor_10" = ["move" "all-scroll" "fleur" "size_all"];
      "Cursor_8" = ["ew-resize" "size_hor" "sb_h_double_arrow" "h_double_arrow" "col-resize"];
      "Cursor_9" = ["ns-resize" "size_ver" "sb_v_double_arrow" "v_double_arrow" "row-resize"];
      "Cursor_6" = ["nwse-resize" "size_fdiag" "bd_double_arrow" "top_left_corner" "bottom_right_corner"];
      "Cursor_7" = ["nesw-resize" "size_bdiag" "fd_double_arrow" "top_right_corner" "bottom_left_corner"];
    };
  in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "win2k-cursors";
      version = "unstable-2026-07-26";

      src = pkgs.fetchurl {
        url = "https://www.rw-designer.com/cursor-downloadset/classic-1.zip";
        sha256 = "0jksp3gq9dj6gb9pr39nw1ygdfalvf5kxzbvw1xwy263p5y4madj";
      };

      nativeBuildInputs = [pkgs.unzip pkgs.win2xcur];

      dontBuild = true;
      dontConfigure = true;

      unpackPhase = ''
        runHook preUnpack
        mkdir source
        unzip -q "$src" -d source
        runHook postUnpack
      '';

      installPhase = let
        aliasLines =
          lib.concatStringsSep "\n"
          (lib.flatten (lib.mapAttrsToList (
              file: names:
                map (name: ''ln -sf "${file}" "$cursorsDir/${name}"'') names
            )
            aliases));
      in ''
        runHook preInstall

        themeDir="$out/share/icons/win2k-cursor"
        cursorsDir="$themeDir/cursors"
        mkdir -p "$cursorsDir"

        # Convert every .cur in the archive to Xcursor format.
        win2xcur source/*.cur -o "$cursorsDir"

        # Alias the identified cursors to their standard X11 names.
        ${aliasLines}

        cat > "$themeDir/index.theme" <<'EOF'
        [Icon Theme]
        Name=win2k-cursor
        Comment=Windows 2000/XP cursor set (classic-1, rw-designer.com)
        Inherits=default
        EOF

        runHook postInstall
      '';

      meta = {
        description = "Windows 2000/XP cursor theme (classic-1 by TaglesMalsto, rw-designer.com)";
        homepage = "https://www.rw-designer.com/cursor-set/classic-1";
        license = lib.licenses.publicDomain;
        platforms = [pkgs.stdenv.hostPlatform.system];
      };
    };

  # Tahoma font — nixpkgs already packages Microsoft's core fonts (unfree,
  # requires `nixpkgs.config.allowUnfreePredicate` or `allowUnfree = true`
  # to permit the Microsoft EULA package).
  tahomaPkg = pkgs.corefonts;
in {
  config = lib.mkIf cfg.enable {
    gtk = {
      enable = lib.mkForce true;
      theme = lib.mkForce {
        name = "Win2K-GTK";
        package = gtkTheme;
      };
      iconTheme = lib.mkForce {
        name = "Redmond97";
        package = iconTheme;
      };
      font = lib.mkForce {
        name = "Tahoma";
        size = 8;
      };
      cursorTheme = lib.mkForce {
        name = "win2k-cursor";
        package = cursorTheme;
        size = 24;
      };
    };

    home.pointerCursor = lib.mkForce {
      package = cursorTheme;
      name = "win2k-cursor";
      size = 24;
    };

    home.packages = [tahomaPkg];

    home.sessionVariables = {
      XCURSOR_THEME = lib.mkForce "win2k-cursor";
      QT_STYLE_OVERRIDE = lib.mkForce "windowsvista";
    };
  };
}
