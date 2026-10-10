// Lesson 4: loops.
//
// A loop is a conditional branch that points BACKWARDS. That is the whole idea.
// This program has two loops.
//
//   Loop 1: sum = 1 + 2 + ... + n        (n = 10, so sum = 55)
//           This is the classic   for (i = 1; i <= n; i++) sum += i;
//
//   Loop 2: print n stars, one write syscall per star, then a newline.
//           Shows a loop whose body makes a syscall. The syscall needs x0, x1,
//           x2, x16 for itself and overwrites x0 and x1 with results, so the
//           loop counter must live somewhere else.
//
// New instructions:
//   cbnz x, label   "compare and branch if not zero": jump if x != 0.
//                   A cmp + b.ne fused into one instruction, flags untouched.
//   subs            sub that also sets the flags (cmp is subs with no result)
//
// Build:  make
// Run:    ./loop ; echo $?        (expect 10 stars and exit code 55)
// Debug:  lldb ./loop  ->  b main, r, then si repeatedly and watch x1 x2 x3

.text
.global _main
.align 2

_main:
    mov  x1, #10              // n
    mov  x2, #0               // sum = 0
    mov  x3, #1               // i = 1

sum_loop:
    add  x2, x2, x3           // sum += i
    add  x3, x3, #1           // i++
    cmp  x3, x1               // i vs n
    b.le sum_loop             // if i <= n, go round again (a BACKWARD branch)

    // x2 now holds 55. Keep it safe: we need it for the exit code later, and
    // the loop below reuses x1 and x2 for the syscall. (Measured fact: a macOS
    // syscall overwrites x0 and x1 with its results and leaves the rest alone.
    // Ordinary function calls, lesson 6, may trash x0-x17, so parking long-lived
    // values in x19-x28 is the habit to build now.)
    mov  x19, x2

    mov  x20, x1              // star counter in x20, also safe across syscalls
star_loop:
    mov  x0, #1               // fd = stdout
    adrp x1, star@PAGE
    add  x1, x1, star@PAGEOFF
    mov  x2, #1               // one byte
    mov  x16, #4
    svc  #0x80                // write(1, "*", 1)
    subs x20, x20, #1         // x20-- and set flags
    b.ne star_loop            // loop while x20 != 0  (try replacing these two lines
                              // with:   sub x20, x20, #1   /   cbnz x20, star_loop)

    mov  x0, #1
    adrp x1, newline@PAGE
    add  x1, x1, newline@PAGEOFF
    mov  x2, #1
    mov  x16, #4
    svc  #0x80                // write(1, "\n", 1)

    mov  x0, x19              // exit code = sum
    mov  x16, #1
    svc  #0x80

.data
star:    .ascii "*"
newline: .ascii "\n"
