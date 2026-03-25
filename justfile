default:
  @just --list

update-flake:
    nix flake update

[macos]
rebuild:
  sudo darwin-rebuild switch --flake .

[linux]
rebuild:
  sudo nixos-rebuild switch --flake .

