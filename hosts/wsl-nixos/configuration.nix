# NixOS-WSL host. Replaces the home-manager-only setup on Ubuntu-WSL
# (homeConfigurations.song), reusing the same hosts/wsl/home.nix.
# Options: https://nix-community.github.io/NixOS-WSL/options.html

{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };

  wsl.enable = true;
  wsl.defaultUser = "song";
  # USB passthrough via usbipd-win: `usbipd attach --wsl --busid <id>` on Windows.
  wsl.usbip.enable = true;

  networking.hostName = "wsl-nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  # Run unpatched dynamic binaries: VS Code server, vendor SDK installers, etc.
  programs.nix-ld.enable = true;

  # Native dockerd in this distro. All WSL distros share one network stack,
  # so don't run Docker in another distro (e.g. Ubuntu) at the same time.
  virtualisation.docker.enable = true;

  # Lets Claude Desktop open this distro as an SSH host ("wsl" in the Windows
  # ~/.ssh/config): SSH sessions get the Files pane, terminal and plugins that
  # WSL sessions lack. Loopback only, keys only. In mirrored networking,
  # Windows reaches 127.0.0.1 here through loopback0.
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    listenAddresses = [ { addr = "127.0.0.1"; port = 2222; } ];
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.interfaces.loopback0.allowedTCPPorts = [ 2222 ];

  programs.zsh.enable = true;
  users.users."song" = {
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "dialout" "docker" ];
    # Windows id_ed25519, used by Claude Desktop's SSH connection.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKTyJ38QbrWvYNBOj8TnfVEW6Jt0h/FpszUiT+heu3/o resideo\\205701@NY80LT3M9MSW3"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # First installed from the NixOS-WSL 26.05 image; leave as is.
  system.stateVersion = "26.05"; # Did you read the comment?
}
