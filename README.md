# Place for my nixos $HOME configuration with [home-manager](https://github.com/rycee/home-manager)

## Install

* clone repo
```
git clone https://github.com/ghostylee/nix-home.git ~/.config/nixpkgs/
```
* install nixpkgs
```
curl -L https://nixos.org/nix/install | sh
```
* install home-manager
```
nix-env -iA nixpkgs.home-manager
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```
* generate config files with home-manager
```
home-manager switch
```
