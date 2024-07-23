# Lib: util functions

## `fromYAML`

### Signature

```haskell
fromYAML :: String -> a
```

### Description

Convert a YAML string to a Nix value.

### Examples

This expression:

```nix
fromYAML ''
  foo:
    - 1
    - 2
    - 3
  bar:
    x: true
    y: some string
''
```

evaluates to

```nix
{
  foo = [ 1 2 3 ];
  bar = {
    x = true;
    y = "some string";
  };
}
```

## `generateFullUser`: generate full-fledged user declaration

### Description

Generates a full-fledged (NixOS + Home-Manager) user module

## `generateHome` generate Home-Manager configuration

### Description

Generates a standalone Home-Manager configuration

## `generateSystemHome`: generate NixOS Home-Manager configuration declration

### Description

Generates the NixOS module for an Home-Manager configuration

## `generateUser`: generate NixOS user declaration

Generates the NixOS module to generate a Linux user

## `mkGL`: make OpenGL context

### Signature

```haskell
mkGL :: AttrSet -> String -> String
```

### Inputs

`config`: Home-Manager config
`command`: the command to run

### Description

From the given `config` (Home-Manager) prepends `nixGL` to the given command if
needed.
This checks if `config.targets.genericLinux.enable` is `true`.

This is generally used for non-NixOS systems where OpenGL doesn't work as
expected due to paths shenanigans.

## `mkIfElse`: module-based if else

### Inputs

`condition`: a boolean to check
`positiveValue`: the value to return if the `condition` is `true`
`negativeValue`: the value to return if the `condition` is `false`

### Signature

```haskell
mkIfElse :: Bool -> a -> a -> a
```

### Description

Generates a module-friendly `if else` condition. This is safer to use than a
plain `if else` condition (nix language), as it avoids infinite recursions
during evaluation by leveraging `nixpkgs`' module merging system.
