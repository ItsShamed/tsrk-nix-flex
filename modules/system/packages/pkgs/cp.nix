# # Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ config, lib, pkgs, ... }:

let
  tsrkPkgs = self.packages.${pkgs.system};
  gapgdbserver = pkgs.writeShellApplication {
    name = "gapgdbserver";
    runtimeInputs = with pkgs; [ openocd ];
    text = ''
      openocd -f ${pkgs.openocd}/share/openocd/scripts/interface/stlink.cfg -f ${pkgs.openocd}/share/openocd/scripts/board/stm32f429discovery.cfg
    '';
  };

  gapflash = with pkgs;
    writeShellApplication {
      name = "gapflash";
      runtimeInputs = [ gcc-arm-embedded stlink ];
      text = ''
        if [ $# -ne 1 ] || [ ! -f "$1" ]; then
            echo "Usage: $0 <elf>" >&2
            exit 1
        fi

        input="$1"
        tmp_file=$(mktemp)

        arm-none-eabi-objcopy -O binary "$input" "$tmp_file"
        st-flash --reset write "$tmp_file" 0x8000000
        rm "$tmp_file"
      '';
    };

  vhdlMakefile = pkgs.writeText "Makefile" ''
    COMP=${pkgs.ghdl-llvm}/bin/ghdl

    %.linked: %.o
    	$(COMP) elaborate $(GHDLFLAGS) $*

    %.o: %.vhd
    	$(COMP) analyse $(GHDLFLAGS) $<

    %.vcd: %.linked
    	$(COMP) run $*_tb --vcd=$*_tb.vcd

    %.check: %.linked
    	$(COMP) run $*_tb

    clean:
    	$(COMP) clean
    	$(RM) *_tb *_tb.vcd

    .PHONY: all *.check clean *.wave *.linked
  '';

  vhdlMake = pkgs.writeShellApplication {
    name = "vhdl-make";
    runtimeInputs = with pkgs; [ vunit-hdl zlib gtkwave ghdl-llvm ];
    text = ''
      make -f ${vhdlMakefile} "$@"
    '';
  };
in {
  options = {
    tsrk.packages.pkgs.cp = {
      # WARN: IT'S ABSOLUTELY NOT WHAT YOU THINK IT MEANS
      # IT'S "PLATFORM CONCEPTION" BUT IN FRENCH THIS ACRONYM IS SO BAD IK
      enable = lib.options.mkEnableOption "tsrk's CP Major package bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.pkgs.cp.enable {
    tsrk.packages.pkgs.cDev.enable = lib.mkDefault true; # For basic toolchains
    tsrk.packages.pkgs.cpp.enable = lib.mkDefault true; # For CLion

    environment.systemPackages = with pkgs; [
      # ARM
      stlink
      stlink-gui
      gcc-arm-embedded
      openocd
      picocom
      gapgdbserver
      gapflash

      # STM32
      stm32cubemx

      # CSTR
      heptagon

      # ELEC
      arduino
      arduino-ide
      kicad

      # VHDL
      tsrkPkgs.vunit-hdl
      vhdlMake
      ghdl-llvm
      zlib
      gtkwave
      surfer
    ];
  };
}
