# clang drives the assembler and linker for us.
#   -g   keep debug info so lldb can show source lines
# Note: macOS requires every program to link libSystem (no fully static
# binaries), so we don't pass -nostdlib. The system startup code calls _main.
exit: exit.s
	clang -g -o exit exit.s

clean:
	rm -rf exit exit.dSYM
