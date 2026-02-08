{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

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

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
    permittedInsecurePackages = [ 
      "electron-25.9.0"
    ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libvdpau-va-gl
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
    thermald.enable = true;
    tlp.enable = true;
    gvfs.enable = true;
    tailscale.enable = true;
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
      wayland = true;
    };
  };

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = [
    pkgs.ghostty
    pkgs.heroic
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };


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
     extraGroups = [ "wheel" "docker" "audio" "dialout" ];
  };

  system.stateVersion = "24.11";

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  time.timeZone = "America/New_York";
  networking.hostName = "nuc-nixos";

}
