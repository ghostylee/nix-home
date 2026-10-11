# NixOS, macOS, and Home Manager configuration

Flake-based system and user configurations using nixpkgs, nix-darwin, and Home Manager.

## Configurations

| Platform | Flake configuration | Architecture | Files |
| --- | --- | --- | --- |
| NixOS | `powercat-nixos` | `x86_64-linux` | `hosts/powercat-nixos/` |
| NixOS | `nuc-nixos` | `x86_64-linux` | `hosts/nuc-nixos/` |
| NixOS | `T7910-Song` | `x86_64-linux` | `hosts/T7910-Song/` |
| macOS | `Songs-MBP` | `aarch64-darwin` | `hosts/Songs-MBP/` |
| WSL / standalone Home Manager | `song` | `x86_64-linux` | `hosts/wsl/home.nix` |

These configurations are specific to the existing hosts and user `song`. Review host settings, usernames, home directories, and hardware configuration before using them on another machine.

## Setup

Install Nix if it is not already available, and enable the `nix-command` and `flakes` experimental features. For installation instructions, see the [Nix manual](https://nixos.org/manual/nix/stable/installation/installing-binary.html).

Clone the repository and run the commands below from its directory:

```sh
git clone https://github.com/ghostylee/nix-home.git ~/.config/nixpkgs
cd ~/.config/nixpkgs
```

### NixOS

Hardware configuration lives in `hosts/<hostname>/hardware-configuration.nix`. Review it for the target machine rather than placing a hardware configuration file at the repository root.

Apply a configuration, replacing `powercat-nixos` with the desired NixOS configuration name:

```sh
sudo nixos-rebuild switch --flake .#powercat-nixos
```

Home Manager is integrated into the NixOS configurations and is applied during the system rebuild.

### macOS

For a new installation, first [bootstrap nix-darwin](https://github.com/nix-darwin/nix-darwin#installing). Once `darwin-rebuild` is available, apply the configuration:

```sh
sudo darwin-rebuild switch --flake .#Songs-MBP
```

Home Manager is integrated into the nix-darwin configuration.

### WSL / standalone Home Manager

The standalone configuration targets user `song`, home directory `/home/song`, and `x86_64-linux`. Adjust `hosts/wsl/home.nix` if needed.

If the `home-manager` command is not installed, apply the locked Home Manager input through Nix:

```sh
nix run --inputs-from . home-manager -- switch --flake .#song
```

Once `home-manager` is available:

```sh
home-manager switch --flake .#song
```

## Maintenance

Update the dependencies pinned in `flake.lock`:

```sh
nix flake update
# Or, with just installed:
just update-flake
```

Rebuild after updating to apply the new versions. With `just` installed, `just rebuild` uses nix-darwin on macOS, NixOS on Linux when `nixos-rebuild` is available, and the `song` Home Manager configuration otherwise. System rebuilds infer the configuration from the hostname; use the explicit commands above to select a different configuration.

Shared user configuration modules live in `modules/`. Host-specific settings belong in `hosts/`; there is currently no automatic `local.nix` import.
