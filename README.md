> [!NOTE]
> ~~If you are viewing this on GitHub, this is a mirror of the real repo at
> https://git.tsrk.me/tsrk/tsrk-nix-flex~~
>
> Redoing infra right now. For the time being this is the official source.

# tsrk. Nix Flex

*(you get it? because it's pronounced likes "flakes". laugh now.)*

This is *will be* my all-in-one NixOS and Home-Manager configuration.

If you're from EPITA and specifically from the Forge, yes, I've been inspired
A LOT by the PIE (to not say this is a rip-off) minus a lot of admin stuff that
I will likely never use (yet?).

# File structure

## Homes

The `homes/` directory contains standalone Home-Manager configurations.
Currently, this is used for the Intel NUC provided by my school for which I was
only allowed to install Arch Linux on it.
This might be also used for the actual configuration of my school session.

## Hosts

The `hosts/` directory contains NixOS systems declarations for different hosts
I have.

## Lib

The `lib/` diretory contains some util functions to avoid a lot of boilerplate
config to do by hand.

## Modules

The `modules/` directory contains modules for both NixOS and Home-Manager. The
modules are written in a waa that each module can be imported individually
without causing to much discrepancy to their original goal.

## Overlays

The `overlays/` directory contains nixpkgs overlays for various package so that
they fit for my needs without having to inline them in modules.

## Packages

The `pkgs/` directory contains custom packages not available on upstream
`nixpkgs`.

## Profiles

THe `profiles/` directory contains a set of NixOS and Home-Manager modules with
defaults configurations.

# Secrets management

I use [agenix](https://github.com/ryantm/agenix) to manage secrets needed for
my NixOS configurations.
