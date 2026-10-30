{ config, lib, pkgs, ... }:
let
  configDir = config.programs.claude-code.configDir;
in
{
  programs.claude-code = {
    enable = true;
    # Claude Code saves to settings.json itself (/theme, /model, "always allow"
    # rules, herdr's SessionStart hook), so merge these keys into the writable
    # file on each switch instead of linking it read-only. Declared keys win;
    # everything else is left as Claude Code wrote it.
    mutableSettings = true;
    settings = {
      model = "opus";
      effortLevel = "xhigh";
      modelSettings."claude-opus-5-5".effortLevel = "xhigh";
      permissions.defaultMode = "auto";
      skipAutoPermissionPrompt = true;
      theme = "custom:gruvbox";
      statusLine = {
        type = "command";
        command = "${lib.getExe pkgs.nodejs} ${configDir}/statusline.js";
      };
    };
  };

  # force replaces the hand-made copies from before this module managed them.
  home.file = {
    "${configDir}/statusline.js" = {
      source = ./claude-code/statusline.js;
      force = true;
    };
    "${configDir}/themes/gruvbox.json" = {
      source = ./claude-code/themes/gruvbox.json;
      force = true;
    };
  };
}
