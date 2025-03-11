# # Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let
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

    %.linked: %.o %_tb.o
    	$(COMP) elaborate $(GHDLFLAGS) $*_tb

    %.o: %.vhd
    	$(COMP) analyse $(GHDLFLAGS) $<

    %.wave: %.linked
    	$(COMP) run $*_tb --vcd=$*_tb.vcd
    	${pkgs.gtkwave}/bin/gtkwave $*_tb.vcd

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
      stm32cubeide

      # CSTR
      heptagon

      # ELEC
      arduino
      arduino-ide

      # VHDL
      vunit-hdl
      vhdlMake
      ghdl-llvm
      zlib
      gtkwave
    ];
  };
}
