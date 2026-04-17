{ pkgs, ... }:
{
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      keyMode = "vi";
      mouse = true;
      terminal = "xterm-256color";
      customPaneNavigationAndResize = true;
      escapeTime = 0;
      plugins = with pkgs.tmuxPlugins; [
        gruvbox
      ];
      extraConfig = ''
        set-option -ga terminal-overrides ",xterm-256color:Tc"
      '';
    };
}
