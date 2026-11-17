{ inputs, ... }:
{
  imports = [ inputs.qmd.homeModules.default ];

  programs.qmd.enable = true;

  programs.opencode.enable = true;
  programs.pi-coding-agent = {
    enable = true;

    settings = {
      defaultProvider = "openai";
      defaultModel = "gpt-6.1-sol";
      defaultThinkingLevel = "medium";
      quietStartup = true;
      theme = "system";

      packages = [
        "npm:pi-web-access"
        "npm:@luminascale/pi-zvec-grep"
        "npm:pi-powerline-footer"
        "npm:@gowthamgts/pi-codex-usage@1.2.1"
      ];

      powerline = {
        preset = "default";
        placement = "below";
        welcome = false;
        separator = "dot";
        path.mode = "full";

        # Plan quota requires /login openai-codex for the same ChatGPT account.
        customItems = [
          {
            id = "openai-quota";
            statusKey = "codex-usage";
            prefix = "ChatGPT remaining";
            selfColorize = true;
          }
        ];

        # Same order as the Claude Code status line (modules/claude-code).
        layout = {
          left = [ "shell_mode" "model" "thinking" "path" "git" ];
          right = [ "context_pct" "time_spent" "custom:openai-quota" ];
          secondary = [ "extension_statuses" ];
        };

        queue.compactPromptMode = "native";
      };
    };
  };

  # Gruvbox Dark, the same colors as the Claude Code status line.
  home.file.".pi/agent/extensions/powerline-footer/theme.json".text = builtins.toJSON {
    colors = {
      model = "#fe8019";
      shellMode = "#83a598";
      path = "#ebdbb2";
      gitClean = "#98971a";
      gitDirty = "#d79921";
      thinking = "#7c6f64";
      thinkingMinimal = "#a89984";
      thinkingLow = "#a89984";
      thinkingMedium = "#a89984";
      thinkingHigh = "#a89984";
      thinkingXhigh = "#a89984";
      thinkingMax = "#a89984";
      context = "#8ec07c";
      contextWarn = "#fe8019";
      contextError = "#fb4934";
      cacheHit = "#b8bb26";
      cacheHitWarn = "#fabd2f";
      cacheHitError = "#fb4934";
      cost = "#fabd2f";
      tokens = "#a89984";
      queue = "#fabd2f";
      separator = "#7c6f64";
      border = "#665c54";
    };
    icons = {
      model = "";
      folder = "";
      branch = ""; # nf-pl-branch, as in the Claude Code status line
      context = "ctx";
      time = "";
    };
  };
}
