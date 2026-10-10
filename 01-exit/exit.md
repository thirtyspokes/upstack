# 1. Exit

Basically the simplest assembly program one could write and demonstrates the "core loop" in assembly.

The CPU of a computer has a number of registers that hold numbers.  Many of those registers have special jobs, depending on the plateform and OS.  To "do stuff" with assembly, we are basically moving values into the available registers and then calling a function that looks at what's in each register.

In this program we are just invoking the syscall `exit` with a specific exit code.  It is simple to understand this by reading the program bottom to top:

`svc` is "supervisor call", and effectively drops into the kernel to perform a syscall.  The 0x80 is a convention from other platforms, but doesn't really mean anything for ours (an ARM64 apple silicon mac).

`svc`, when invoked, looks for two things:

* The syscall we want it to invoke in register x16
* The arguments to the syscall in registers x0, x1, x2, etc.

`mov` is a very basic operation that puts a value into one of the CPU registers.  `mov x16, #1` moves the numeric literal 1 into the register x16.  Similarly, `mov x0, #42` moves the numeric literal 42 into the register x0.  Now, when we hit the `svc` call, our program does this:

* It sees `svc` and looks in register x16 to know what syscall we want.  We've put the value 1 in that register which corresponds to `exit()`.  
* It looks in `x0` for the argument to be supplied to the syscall (in our case, the number 42).
* It passes control to the kernel, which runs `exit(42)`.
