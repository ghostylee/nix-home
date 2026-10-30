{ pkgs, ... }:
{
  imports = [
    ./../wsl/home.nix
    ./../../modules/claude-code.nix
  ];
  # Installed imperatively with `nix profile` on Ubuntu-WSL.
  home.packages = [
    pkgs.python3Packages.labgrid
  ];
}
