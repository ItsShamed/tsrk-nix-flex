# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    tsrk.epita.cunix = {
      enable = lib.options.mkEnableOption "tsrk's EPITA C/Unix Environment";
    };
  };

  config = lib.mkIf config.tsrk.epita.cunix.enable {
    programs.zsh.shellAliases = {
      epicc = "gcc -Wextra -Wall -Werror -Wvla -std=c99 -pedantic";
      epiccnop = "gcc -Wextra -Wall -Werror -Wvla -std=c99";
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "scaffold-c" ''
        if [ $# -ne 1 ]; then
          echo "Usage: $0 <name>"
          exit 1
        fi

        cat <<EOF > compile_flags.txt
        -Wextra
        -Wall
        -Wvla
        -Werror
        -std=c99
        -pedantic
        -I/run/current-system/sw/include
        EOF

        cat <<EOL > tests.c
        #include <criterion/criterion.h>
        #include "$1.h"
        EOL

        cat <<EOL > main.c
        #include "$1.h"

        // TODO: change this prototype
        int main()
        {
            return 0;
        }
        EOL

        cat <<EOL > .gitignore
        .gitignore
        compile_commands.json
        compile_flags.txt
        tests.c
        main.c
        EOL

        cat <<EOL > Makefile
        CC = gcc
        CFLAGS = -Wall -Wextra -Wvla -Werror -std=c99 -pedantic
        SRCFILES =
        OFILES = \$(SRCFILES:%.c=%.o)
        TEST_SRCFILES = tests.c
        TEST_OFILES = \$(TEST_SRCFILES:%.c=%.o)
        LIB = $1

        # Put your global rules
        all:

        # Add your required binaries
        main: CFLAGS += -g
        main: LDFLAGS += -fsanitize=address
        main: main.o \$(OFILES)

        check: CFLAGS += -g -I.
        check: LDFLAGS += -fsanitize=address
        check: LDLIBS += -lcriterion
        check: \$(OFILES) \$(TEST_OFILES)
        	\$(CC) \$^ -o \$@ \$(LDFLAGS) \$(LDLIBS)
        	./\$@ --verbose

        library: \$(OFILES)
        	ar csr lib\$(LIB).a \$^

        clean:
        	\$(RM) \$(OFILES) lib\$(LIB).a main check tests.o main.o

        .PHONY: all clean library
        EOL

        echo "All files were generated."
        echo "Do not forget to add your sources!!!!!"
      '')
    ];
  };
}
