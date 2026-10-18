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
        separator = "pipe";

        # Plan quota requires /login openai-codex for the same ChatGPT account.
        customItems = [
          {
            id = "openai-quota";
            statusKey = "codex-usage";
            prefix = "ChatGPT remaining";
            selfColorize = true;
          }
        ];

        layout = {
          left = [ "path" "git" "model" "thinking" ];
          right = [ "context_pct" "custom:openai-quota" "cost" ];
          secondary = [
            "token_in"
            "token_out"
            "cache_read"
            "extension_statuses"
          ];
        };

        queue.compactPromptMode = "native";
      };
    };
  };
}
