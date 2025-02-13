{ pkgs, ... }:
let
  tmux-monokai-pro = pkgs.tmuxPlugins.mkTmuxPlugin
  {
    pluginName = "tmux-monokai-pro";
    version = "unstable-2024-12-03";
    src = pkgs.fetchFromGitHub {
      owner = "maxpetretta";
      repo = "tmux-monokai-pro";
      rev = "afb5831e5267047381378c41644ed46f336be33f";
      sha256 = "sha256-S6EVkjsWU6om4E8yO/g7EOToXIEka6ZuOAGwSjjEHbA=";
    };
    rtpFilePath = "monokai.tmux";
  };
in
{
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      keyMode = "vi";
      mouse = true;
      terminal = "xterm-256color";
      customPaneNavigationAndResize = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        catppuccin
      ];
      extraConfig = ''
        set-option -ga terminal-overrides ",xterm-256color:Tc"
      '';
    };
}
