{ config, lib, pkgs, ... }:

with builtins;

{
  imports =
    [
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    ] ++ lib.optional (pathExists ./local.nix) ./local.nix ;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    };
  };

  sound.enable = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  virtualisation.docker.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
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

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      powerline-fonts
      font-awesome_5
      wqy_zenhei
      nerdfonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Hack NF" ];
      };
    };
  };

  services = {
    thermald.enable = true;
    tlp.enable = true;
    xserver = {
      enable = true;
      exportConfiguration = true;
      layout = "us";
      libinput = {
        enable = true;
        naturalScrolling = true;
      };

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        defaultSession = "none+bspwm";
        autoLogin = {
          enable = true;
          user = "ghosty";
        };
        sddm = {
          enable = true;
          theme = "maldives";
        };
      };

      windowManager = {
        bspwm = {
          enable = true;
        };
      };
    };
  };

  users.defaultUserShell = pkgs.zsh;
  users.users.ghosty = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" "docker" "audio" ];
  };

  home-manager.users.ghosty = if pathExists ./home.nix then import ./home.nix else {};
  home-manager.users.root = if pathExists ./home.nix then import ./home.nix else {};

  services.sshd.enable = true;

  system.stateVersion = "20.03";

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

}
