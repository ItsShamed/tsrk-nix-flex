<!--
Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
This file is licensed under the MIT License.
See the LICENSE file in the repository root for more info
-->

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
Cool thing about them is that you can use them without depending on my inputs!

You can use them by using the `nixosModules` output:

```nix
{
  description = "My cool flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    tsrk = "github:ItsShamed/tsrk-nix-flex";
    
    outputs = { nixpkgs, tsrk } @ inputs:
    {
      nixosConfigurations.my-configuration = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          tsrk.nixosModules.packages
          {
            tsrk.packages.pkgs.base.enable = true;
          }
        ];
      };
    }
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

> [!WARNING]
> There are some profiles (like `profile-tsrk-private`) that are encrypted with
> Git-Crypt (for privacy reasons) and you cannot use them.

### Secrets management

I use [agenix](https://github.com/ryantm/agenix) to manage secrets needed for
my NixOS configurations.

### TODOs

- [~] Finish polishing i3 environment
- [-] Create hyprland environment

## Licensing

All unencrypted files which include a license header are licensed under the MIT
License.
Please refer to the [LICENSE](./LICENSE) file for more info.
