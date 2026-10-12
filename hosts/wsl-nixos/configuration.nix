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

  networking.hostName = "wsl-nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  # Run unpatched dynamic binaries: VS Code server, vendor SDK installers, etc.
  programs.nix-ld.enable = true;

  # Native dockerd in this distro. All WSL distros share one network stack,
  # so don't run Docker in another distro (e.g. Ubuntu) at the same time.
  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
  users.users."song" = {
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "dialout" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # First installed from the NixOS-WSL 26.05 image; leave as is.
  system.stateVersion = "26.05"; # Did you read the comment?
}
