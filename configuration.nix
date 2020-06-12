{ config, lib, pkgs, ... }:

with builtins;

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "98fa8f63b8d7508e84275eb47cd7f3003e6b9510";
    ref = "release-20.03";
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      "${home-manager}/nixos"
    ] ++ lib.optional (pathExists ./local.nix) ./local.nix ;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n = {
     defaultLocale = "en_US.UTF-8";
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
    wget
    bspwm
    sxhkd
    polybar
    dmenu
    alacritty
    rofi-unwrapped
    ranger
    firefox
    feh
    tree
    gitFull
    htop
    bat
    neofetch
    silver-searcher
    minikube
    networkmanager
    vscode
    cargo
    home-manager
    ostree
    binutils
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
      penultimate.enable = false;
      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Hack NF" ];
      };
    };
  };

  services = {
    compton = {
      enable = true;
      fade = true;
      inactiveOpacity = "0.9";
      shadow = true;
      fadeDelta = 4;
    };
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
        sddm = {
          enable = true;
          autoLogin = {
            enable = true;
            user = "ghosty";
          };
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

}
