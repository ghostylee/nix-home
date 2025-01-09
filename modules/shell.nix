{
  # zsh {{{
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
      initExtraBeforeCompInit =
        ''
        source /etc/profile
        '';
      initExtra =
        ''
          zstyle ':completion:*' menu select
          autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
          zle -N up-line-or-beginning-search
          zle -N down-line-or-beginning-search
          bindkey "^[[A" up-line-or-beginning-search
          bindkey "^[[B" down-line-or-beginning-search

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*'
        '';
      };
  # }}}
  # command-not-found {{{
    programs.command-not-found.enable = true;
  # }}}
  # fzf {{{
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  # }}}
  # lsd {{{
    programs.lsd = {
      enable = true;
      enableAliases = true;
    };
  # }}}
  # starship {{{
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
      };
    };
  # }}}
  # autojump {{{
    programs.autojump = {
      enable = true;
    };
  # }}}
  # direnv {{{
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  # }}}
  # bat {{{
    programs.bat = {
      enable = true;
      config = {
        theme = "ansi-dark";
      };
    };
  # }}}
  # fd {{{
    programs.fd = {
      enable = true;
    };
  # }}}
  # ripgrep {{{
    programs.ripgrep = {
      enable = true;
    };
  # }}}
  # ranger {{{
    programs.ranger = {
      enable = true;
    };
  # }}}
  # htop {{{
    programs.htop = {
      enable = true;
    };
  # }}}
}
