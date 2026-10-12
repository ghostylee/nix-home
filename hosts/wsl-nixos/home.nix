{ pkgs, ... }:
{
  imports = [
    ./../wsl/home.nix
  ];
  # Installed imperatively with `nix profile` on Ubuntu-WSL.
  home.packages = [
    pkgs.python3Packages.labgrid
  ];
  programs.claude-code = {
    enable = true;
  };
}
