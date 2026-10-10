// Build:  make
// Run:    ./arith ; echo $?
// Debug:  lldb ./arith   ->  b main, r, si ..., re r x0 x1 x2 x3 cpsr

.text
.global _main
.align 2

_main:
    mov  x1, #7
    mov  x2, #15
    mul  x3, x1, x2           // x3 = 7 * 15 = 105
    mov  x4, #30
    sub  x3, x3, x4           // x3 = 105 - 3 = 102    (x3 = x3 - x4)

    cmp  x3, #100             // compute x3 - 100, set the flags, discard the result
    b.lt small                // if x3 < 100, jump to the label 'small'

    // fall through: x3 >= 100
    adrp x1, big_msg@PAGE          // x1 = address of the 4KB page holding big_msg
    add  x1, x1, big_msg@PAGEOFF   // x1 += offset within that page  (see note below)
    mov  x2, #big_len
    b    print                // unconditional branch, skip over the 'small' code

small:
    adrp x1, small_msg@PAGE
    add  x1, x1, small_msg@PAGEOFF
    mov  x2, #small_len

print:
    mov  x0, #1               // fd = stdout   (x1 and x2 were set above)
    mov  x16, #4              // write
    svc  #0x80

    mov  x0, x3               // exit code = n   (register-to-register mov)
    mov  x16, #1              // exit
    svc  #0x80

.data                         // from here on: data, not code
big_msg:    .ascii "big\n"
.set big_len, . - big_msg     // '.' means "the current address"
small_msg:  .ascii "small\n"
.set small_len, . - small_msg
