{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    hyprnix = {
      url = "github:hyprwm/hyprnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.follows = "hyprnix/hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?ref=v0.56.0";
      inputs.hyprland.follows = "hyprland"; # Prevents version mismatch.
    };
    snappy-switcher = {
      url = "github:OpalAayan/snappy-switcher?rev=0957cd612fadf80fa95034515cb6fa2c163e497e";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    win2k-plymouth = {
      url = "github:Win2K-for-Unix/Win2K-Plymouth";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Windows 2000 GTK theme (gtk-2.0, gtk-3.0, metacity-1).
    # No flake.nix upstream — fetched as a plain source tree.
    win2k-gtk = {
      url = "github:Win2K-for-Unix/Win2K-GTK";
      flake = false;
    };

    # Windows 2000 / "Redmond97" icon theme.
    # Ships the icon pack under "Icon Theme/Redmond97/".
    win2k-icons = {
      url = "github:matthewmx86/WinClassic_icons";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs) self nixpkgs;
  in {
    # A standalone, portable Home-Manager module. Import this into any
    # Hyprland + Home-Manager flake to complement it with a Windows 2000
    # (Luna) theme; every option it sets uses `lib.mkForce`, so enabling
    # `programs.hypr-dotw2k.enable` overrides whatever the importing
    # configuration already set at the same option paths.
    homeManagerModules.default = {
      pkgs,
      lib,
      config,
      ...
    } @ args:
      import ./homeModules (args // {inherit inputs;});
  };
}
