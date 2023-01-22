# :godmode: shkm's dotfiles

These are my dotfiles, which turns out to be a broad term now. They're a combination of [NixOS](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager) configurations I use to set up my environments. I used [Gabriel Fontes](https://github.com/Misterio77)' exceptional [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs) to migrate to flakes.

## Setup

Initial setup is a matter of cloning down the repo, running `nix shell` and then using a corresponding command for NixOS or Home Manager as detailed below.

### NixOS
For NixOS, I currently have only one configuration for my personal laptop, named `denkpad`. To switch to this, use the following (replacing . with the dotfiles path):

```
sudo nixos-rebuild switch -- flake .#denkpad
```

### Home Manager

Home Manager has two configs: `jamie@denkpad` and `jamie.schembri@dapper`. Switch to them as follows, for example:

```
home-manager switch --flake .#jamie@denkpad
````
