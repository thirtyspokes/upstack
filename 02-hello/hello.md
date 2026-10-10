# 2. Hello world

We can use labels to give a name to data:

```
// Give this ascii text the name `msg`
msg:
  .ascii "hello, world\n"

// Common idiom.  We want to compute the length of our string.
// To do that, we add a label `msg_end`.  That's the address where our ascii
// text ends (in other words: "right here").  We use .set to put the result of
// msg_end (current address) - msg, which is the length in memory of the whole
// ascii string, in the value `msg_len`.
msg_end:
.set msg_len, msg_end - msg
```

Registers only hold numbers.  In order to put text somewhere, we need to store its memory address instead.  There's an assembly instruction for this, called `adr`. 

`adr x1, msg` puts the memory address of the data labeled `msg` into the x1 register.  Observe the difference when we want to put the length of the message, which is also labeled but is a numeric literal, into a register.  It's somewhat like derefencing a pointer.

```
mov x2, #msg_len
```

To print to stdout, we can use the `write(3)` syscall which needs:

* the file descriptor to write to (1 is stdout)
* the bytes to write
* the number of bytes to write

So from the previous exercise we know that we need to put a few things into registers:

* x16 needs the name of the write syscall (4).  `mov x16, #4`
* x0 needs the first argument to write(), which is the file descriptor (1 for stdout).  `mov x0, #1`
* x1 needs the bytes we want written.  `adr x1, msg`
* x2 needs the number of bytes.  `mov x2, #msg_len`

We then use `svc`, which reads those registers to know that it's going to call `write(3)` with the arguments we list.  This writes our message "hello, world\n" to stdout.  We then do the same thing to set up a syscall to `exit(1)`.
