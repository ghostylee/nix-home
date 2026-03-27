default:
  @just --list

update-flake:
    nix flake update

[macos]
rebuild:
    sudo darwin-rebuild switch --flake .

[linux]
rebuild:
    @if command -v nixos-rebuild >/dev/null 2>&1; then sudo nixos-rebuild switch --flake . ; else home-manager switch ;fi

