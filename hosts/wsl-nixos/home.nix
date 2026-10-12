{ pkgs, inputs, ... }:
{
  imports = [
    ./../wsl/home.nix
  ];
  # Installed imperatively with `nix profile` on Ubuntu-WSL.
  home.packages = [
    inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.python3Packages.labgrid
  ];
}
