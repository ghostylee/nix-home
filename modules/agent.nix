{pkgs, ... }:
{
  home.packages = with pkgs; [
    pi-coding-agent
  ];
  programs.opencode.enable = true;
}
