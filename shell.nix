{ pkgs ? (import <nixpkgs> { config.allowUnfree = true; }), ... }:
let
  # Extensions not available via nix packages
  vscodeMktExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];

  # Extensions available via nix packages
  vscodePkgsExtensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    samuelcolvin.jinjahtml
  ];

  # Merge extension sets
  vscodeExtensions = vscodeMktExtensions ++ vscodePkgsExtensions;

  # Merged vscode package
  vscode = pkgs.vscode-with-extensions.override { inherit vscodeExtensions; };

  # Packages
  packages = with pkgs;
    [
      nixfmt-classic
      nixd
      git
      jinja2-cli
    ] ++ [ vscode ];

  # Shell hook for venv
  shellHook = ''
    code .
  '';

in pkgs.mkShell { inherit shellHook packages; }
