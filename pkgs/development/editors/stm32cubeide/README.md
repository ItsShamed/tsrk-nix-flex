# How to build the STM32CubeIDE derivation

Because the distribution of the IDE is very hasardous, building this derivation
directly will fail.

You will need to add the distribution ZIP archive yourself to the Nix store.

To do so, head to https://www.st.com/en/development-tools/stm32cubeide.html, and
download the "Generic Linux Installer" for the 1.16.1 version.

Then, add the ZIP archive to the nix store
```
nix-prefetch-url --type sha256 file://path/to/en.st-stm32cubeide_1.16.1_22882_20240916_0822_amd64.sh.zip
```

Then you can build the derivation.
