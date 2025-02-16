{
  programs.fish = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    sessionVariables = {
      TERM = "xterm-256color";
    };
    initExtra = ''
    zstyle ':completion:*' menu select
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "^[[A" up-line-or-beginning-search
    bindkey "^[[B" down-line-or-beginning-search

    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*'
    '';
  };
  programs.command-not-found  = {
    enable = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
    };
  };
  programs.autojump = {
    enable = true;
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi-dark";
    };
  };
  programs.fd = {
    enable = true;
  };
  programs.ripgrep = {
    enable = true;
  };
  programs.yazi = {
    enable = true;
  };
  programs.htop = {
    enable = true;
  };
}
