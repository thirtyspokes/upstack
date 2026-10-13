# 04 - loops and registers

We walked through labels and jumping with `cmp` in the last section.  It follows from this behavior that if we want to create looping behavior in our code, then we simply use these concepts to jump "backwards" to a previous instruction.  

```
sum = 0
n = 10
i = 1

do {
  sum += i
  i++
} while (i <= n)
```

Could be expressed as:

```
mov x1, #10 // n
mov x2, #0  // sum
mov x3, #1  // i

sum_loop:
    add  x2, x2, x3 // x2 + x3 = sum + i
    add  x3, x3, #1 // x3 + 1 = i++
    cmp  x3, x1      
    b.le sum_loop   // if (x3 <= x1), loop = if (i <= n), continue looping
```

So long as the `cmp` of x3 and x1 results in b reading le from the flags that cmp set, we continue jumping to the sum_loop label which is in our case a previous instruction, and that is how loops can be achieved.

## Registers and Context

We see in this program (and previous lessons) that some registers have special purposes: x16 is where the number of the syscall for svcs is, and the arguments to that syscall are in the first few registers - they can and will get overwritten.  So if we care about data that we're storing in the lower registers it's up to us as the programmer to save them elsewhere to preserve them across function calls.  

On ARM64 apple silicon, we want to use x19-x28 to store arbitrary data that we care about so that it won't get overwritten by function calls, etc.  x18 is a special register that's reserved by Apple, so we shouldn't use that for anything.  x29 is the frame pointer, which points to the current function's region of the stack (and each frame stores the previous fp which forms a chain - LLDB uses this, for example).  x30 is the link register, which is how a function knows where to return to once it's finished executing.

We know that registers are on the actual CPU - each core has a set of the registers..  If it's possible for us to trash our own register values with function calls, etc, is it not possible that another program running at the same time as ours could trash what we store in x19-x28?  Hypothetically yes, nothing in the CPU hardware exists to prevent this from happening - instead, it's the job of the kernerl to prevent this.  The kernel pauses a program so that another can run, and then when that one is done, may un-pause the previous program and get it going again.  When the program is paused, the kernel copies all of the values of the registers to a block of memory that belongs to the thread that the program was executing, and when the pprogram is un-paused, those saved values get loaded back to the registers.  This process is called context switching - when there are more threads that need to run than there are cores on the CPU, context switching is how the kernel load balances the work between the available cores.

This context-switching process is entirely transparent to the running program - from its perspective it was running the whole time and had all those registers to itself.  One of the kernel responsibilities is to maintain this illusion so that programmers don't necessarily have to handle it themselves.
