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

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      wqy_zenhei
      nerdfonts
      joypixels
      twitter-color-emoji
    ];

    fontconfig = {
      localConf   = lib.fileContents ./fontconfig.xml;
      defaultFonts = {
        serif = [ "DejaVu Serif" "WenQuanYi Zen Hei" ];
        sansSerif = [ "DejaVu Sans" "WenQuanYi Zen Hei" ];
        monospace = [ "FiraCode Nerd Font Mono" "WenQuanYi Zen Hei Mono" ];
        emoji = [ "Noto Color Emoji" "Twitter Color Emoji" "JoyPixels" ];
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

  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];


  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent updatestartuptty /bye > /dev/null
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };



  system.stateVersion = "20.03";

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable-small";



}
