// Build:  make
// Run:    ./hello
// Debug:  lldb ./hello   then   b main, r, si ..., and try:  memory read -fs $x1

.global _main
.align 2

_main:
    mov  x0, #1               // fd = stdout
    adr  x1, msg              // x1 = the address where 'msg' lives
    mov  x2, #msg_len         // x2 = length (msg_len is defined below)
    mov  x16, #4              // syscall: write
    svc  #0x80

    mov  x0, #0               // exit code 0 = success
    mov  x16, #1              // syscall: exit
    svc  #0x80

// Data goes in its own labelled region. The label 'msg' is just a name for
// the address of the first byte that follows it.
msg:
    .ascii "Hello, world!\n"
msg_end:
.set msg_len, msg_end - msg  // the assembler computes this constant at build time
