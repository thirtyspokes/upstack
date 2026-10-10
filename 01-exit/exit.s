// Build:  make
// Run:    ./exit ; echo $?        <- prints the exit code (should be 42)
// Debug:  lldb ./exit

.global _main          // export the symbol so the linker can find the entry point
.align 2               // instructions must be 4-byte aligned on ARM64

_main:
    mov  x0, #42       // x0 = 42.  x0 is the register for "first argument"
    mov  x16, #1       // syscall number; 1 = exit
    svc  #0x80         // "supervisor call": jump into the kernel to perform the syscall
                       // execution never returns here, because exit() never returns
