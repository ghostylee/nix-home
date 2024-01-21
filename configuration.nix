{ config, lib, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
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
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-rime ];
    };
  };

  sound.enable = true;

  networking.networkmanager.enable = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {
      enableHybridCodec = true;
    };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  environment.variables.EDITOR = "vim";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      wqy_zenhei
      nerdfonts
      joypixels
      twitter-color-emoji
      source-sans-pro
    ];

    fontconfig = {
      localConf   = lib.fileContents ./fontconfig.xml;
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
    xserver = {
      enable = true;
      exportConfiguration = true;
      layout = "us";
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
      desktopManager.xterm.enable = false;
      displayManager.defaultSession = "none+bspwm";
      windowManager.bspwm.enable = true;
    };
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
     extraGroups = [ "wheel" "docker" "audio" ];
  };


  system.stateVersion = "24.05";

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

  time.timeZone = "America/New_York";
  networking.hostName = "nuc-nixos";

}
