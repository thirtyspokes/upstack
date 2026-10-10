# 3.  Arithmetic, Branching, Comparisons

We can perform arithmetic operations using some functions that work basically the way as one would expect.  `add`, `sub`, and `mul` all perform the listed arithmetic operation on two numbers in separate registers and put the value of the computation into a third register:

```
mov x1, #5
mov x2, #7
add x3, x1, x2 // x3 now holds 12
```

The special directives `.text` and `.data` can be used to signify to the linker that certain regions of the code are actual code, and others are pure data.  This is useful for debugging tools like `objdump` so that they can tell whether something is meant to be code or just data.

`cmp` is a kind of swiss army knife for boolean comparisons.  It compares two values and stores the result as a bit field in a special register called `cpsr` (current program state register).  This field actually stores information about a variety of things, but the leftmost four bits are four flags (N, Z, C, V) which will be set to 0 or 1 depending on the result of the comparison.  For example, in `cmp x1, x2`, if x1 and x2 are equal then the flag Z will be set to 1.

The branch directive `b` can be used to jump to particular regions of the code based on the result of the previous `cmp`.  `b` will look at `cpsr` to figure out whether the given branch is to be used or not.

```
mov x1, #1
cmp x1, #1
b.eq equal // If x1 and 1 are equal (which they are) jump to the label 'equal'
```

This is important because an assembly program is always read one instruction at a time, in order, unless a jump instruction causes it to skip instructions.  

```
mov x1, #1
cmp x1, #1

b.ne not_equal
b.eq equal

not_equal:
  mov x0, #1
  mov x16, #1
  svc 0x80 // not equal, exit with status 1

equal:
  mov x0, #2
  mov x16, #1
  svc 0x80 // equal, exit with status 2
```

If the branch instructions were removed, then this program would *always* exit with status 1 because those instructions appear before the exit status 2 instructions.

`.set` defines a named constant that is created at build time.

`adr` technically doesn't store the exact memory address of a label.  It stores how far away that label is in memory from the current instruction.  That field is 21 bits, so `adr` can reach about 1MB in either direction.  When we use `.text` and `.data` to separate our code instructions from pure data, the linker decides where to place each pile of info and they could be placed further apaart than `adr` can reach and the assembler won't be able to build that code.

To solve this, we use the call `adrp`: "address in page."  This lets us break the actual address of the data down to two parts:

* The memory page the data is on
* The offset within that memory page where our data starts

Given that we have a label for `big_msg`, we would be able to reference it like so:

```
adrp x1, big_msg@PAGE // x1 now holds the location where the page that holds big_msg starts
add x1, big_msg@PAGEOFF // PAGEOFF is where in that page the actual big_msg data is located
```

The address of the page that holds the data + the position within the page where the data starts = the address of the data we want.  This adrp + add two-step is very common for macOS assembly.
