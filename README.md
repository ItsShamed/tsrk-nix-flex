<!--
Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
This file is licensed under the MIT License.
See the LICENSE file in the repository root for more info
-->

<!-- SPDX-License-Identifier: MIT -->

> [!NOTE]
> ~~If you are viewing this on GitHub, this is a mirror of the real repo at
> https://git.tsrk.me/tsrk/tsrk-nix-flex~~
>
> Redoing infra right now. For the time being this is the official source.

# tsrk. Nix Flex

This is my all-in-one NixOS and Home-Manager configuration.

The structure of this configuration is largely inspired by the one used by
EPITA for their NixOS deployment[^1].

[^1]: https://gitlab.cri.epita.fr/forge/infra/nixpie

<div align="center">

<!-- TODO: Add showcase screenshot -->

</div>

## File structure

### Homes

The `homes/` directory contains standalone Home-Manager configurations.
Currently, this is used for the Intel NUC provided by my school for which I was
only allowed to install Arch Linux on it.
This might be also used for the actual configuration of my school session.

### Hosts

The `hosts/` directory contains NixOS systems declarations for different hosts
I have.

### Lib

The `lib/` diretory contains some util functions to avoid a lot of boilerplate
config to do by hand.

### Modules

The `modules/` directory contains modules for NixOS, Nixvim and Home-Manager. 

You can use them by using the `nixosModules`, or `homeManagerModules` outputs:

```nix
{
  description = "My cool flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    homeManager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tsrk = "github:ItsShamed/tsrk-nix-flex";
  };
    
  outputs = { nixpkgs, homeManager, tsrk } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.my-configuration = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        tsrk.nixosModules.packages
        {
          tsrk.packages.pkgs.base.enable = true;
          nixpkgs = { inherit pkgs; };
        }
      ];
    };
    homeConfigurations."my-home" = homeManager.lib.homeManagerConfiguration {
      inherit pkgs;
  
      modules = [
        tsrk.homeManagerModules.packages
        {
          tsrk.packages.core.enable = true;
        }
      ];
    };
  };
}
```

### Overlays

The `overlays/` directory contains nixpkgs overlays for various packages so that
they fit for my needs without having to inline them in modules.

### Packages

The `pkgs/` directory contains custom packages not available on upstream
`nixpkgs`, and a standalone binary of my Nixvim configuration (`nvim-cirno`).

### Profiles

The `profiles/` directory contains a set of NixOS and Home-Manager modules with
defaults configurations.

Like modules, you can use them via the `nixosModules` output. To use them you
just have to prefix the name of the profile you want to use with `profile-`.

### Secrets management

I use [agenix](https://github.com/ryantm/agenix) to manage secrets needed for
my NixOS configurations.

## Licensing

All unencrypted files which include a license header are licensed under the MIT
License.
Please refer to the [LICENSE](./LICENSE) file for more info.
