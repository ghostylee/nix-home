{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.kernelPatches = [ {
    #name = "fsverity-config";
    #patch = null;
    #extraConfig = ''
      #FS_VERITY y
    #'';
  #}];

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-rime ];
    };
  };

  zramSwap.enable = true;

  networking.networkmanager.enable = true;

  # Route Anthropic/Claude traffic (api.anthropic.com, claude.ai, claude.com)
  # via the 10.10.100.1 gateway on enp9s0 instead of the default route.
  # Range from https://docs.anthropic.com/en/api/ip-addresses
  networking.networkmanager.dispatcherScripts = [{
    type = "basic";
    source = pkgs.writeShellScript "claude-route" ''
      [ "$1" = enp9s0 ] || exit 0
      case "$2" in
        up|dhcp4-change)
          ${pkgs.iproute2}/bin/ip route replace 160.79.104.0/23 via 10.10.100.1 dev enp9s0 ;;
        down)
          ${pkgs.iproute2}/bin/ip route del 160.79.104.0/23 via 10.10.100.1 dev enp9s0 || true ;;
      esac
    '';
  }];

  hardware.bluetooth.enable = true;

  services.openssh.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    insecure-registries = [ "gop-docker-stable-local.artifactory.softwaretools.resideo.com" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
      "nix-2.16.2"
    ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  environment.variables.EDITOR = "vim";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      wqy_zenhei
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-mono
      nerd-fonts.caskaydia-mono
      nerd-fonts.blex-mono
      nerd-fonts.commit-mono
      joypixels
      twitter-color-emoji
      source-sans-pro
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "DejaVu Serif" "WenQuanYi Zen Hei" ];
        sansSerif = [ "DejaVu Sans" "WenQuanYi Zen Hei" ];
        monospace = [ "JetBrainsMono Nerd Font Mono" "WenQuanYi Zen Hei Mono" ];
        emoji = [ "Noto Color Emoji" "Twitter Color Emoji" "JoyPixels" ];
      };
    };
  };

  services = {
    gvfs.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
    displayManager.defaultSession = "hyprland";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
    xserver = {
      enable = true;
      exportConfiguration = true;
      xkb.layout = "us";
      desktopManager.xterm.enable = false;
      #windowManager.bspwm.enable = true;
    };
    displayManager.gdm = {
      enable = true;
    };
  };

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Run unpatched dynamic binaries: Claude Desktop's SSH engine, vendor SDK installers, etc.
  programs.nix-ld.enable = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    config.common = { default = [ "gtk" ]; };
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.song = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" "docker" "audio" "dialout"];
  };


  system.stateVersion = "26.05";

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  time.timeZone = "America/New_York";
  networking.hostName = "T7910-Song";

}
