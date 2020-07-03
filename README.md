# My home-manager configuration for NixOS and non-NixOS system

### for NixOS

* Clone repo to `/etc/nixos` and keep your `hardware-configuration.nix` file in the folder
```
git clone https://github.com/ghostylee/nix-home.git /etc/nixos/
```
* put local setttings like wifi ssid/password into `local.nix` file

### for nox-NixOS

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
