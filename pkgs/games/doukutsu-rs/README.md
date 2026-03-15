# doukutsu-rs

[doukutsu-rs] is a Rust re-implementation of the engine of [CaveStory].

[doukutsu-rs]: https://github.com/doukutsu-rs/doukutsu-rs
[CaveStory]: https://www.cavestory.org

This Nix derivation packages doukutsu-rs along with two variants of data files
compatible with doukutsu-rs.

## Overrides

**`vanilla-extractor`:** small program to extract extra resources from the
original Doukutsu.exe game.
`useNXEngineAssets`: whether to use the data files from the [NXEngine-evo]
project.
**`assets`**: the data files for the game. If overriding this, you should
provide your data files at `$out/share/cavestory/data`. Has no effect when
`useNXEngineAssets` is `true`.

## Notable changes

`Cargo.lock` has been patched to use `rust-sdl2` with the `use-pkgconfig` flag
instead of the upstream `bundled`. This allows to use the Nix-vendored SDL2
compat library (backed by SDL3), instead of recompiling SDL2, which may incur
some problems down the line due to missing workarounds made before 25.05.
