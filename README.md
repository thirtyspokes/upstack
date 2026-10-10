# Upstack: Learning my way up the computing stack

An experiment in using Claude Code to teach myself assembly.

## Learning ARM64 Assembly (Apple Silicon)

Each numbered directory is one lesson. Every lesson has a `.s` file you can
read top to bottom, a `Makefile`, and a goal to verify by running and
debugging the program.  Each directory also has a markdown file with my notes that
try to summarize what I learned in the section.

## The loop for every lesson

```sh
cd 0N-name
make              # assemble + link
./program         # run it
lldb ./program    # step through it
```

## Curriculum

| # | Lesson | What you learn |
|---|--------|----------------|
| 01 | `exit` | Registers, `mov`, syscalls, the build/run/debug loop |
| 02 | `hello` | Memory, labels, the `write` syscall, `adr`/`adrp` addressing |
| 03 | `arith` | `add`/`sub`/`mul`, flags, `cmp`, conditional branches |
| 04 | `loop` | Loops and branches: sum 1..N, countdown |
| 05 | `stack` | `sp`, push/pop via `stp`/`ldp`, the frame pointer |
| 06 | `call` | `bl`/`ret`, the calling convention, writing a function |
| 07 | `libc` | Calling `printf` from assembly; why the stack must stay 16-byte aligned |
| 08 | `c-interop` | Call your assembly from C, and C from assembly |
| 09 | `compiler` | Compile C with `clang -S -O0` vs `-O2` and read what the compiler emits |
| 10 | `bugs` | Deliberately broken programs: find the fault with lldb |

## The mental model (lesson 1)

- The CPU has 31 general-purpose 64-bit registers, `x0`..`x30`. Think of them as
  the only variables that exist. `w0`..`w30` are the low 32 bits of the same registers.
- `x0`..`x7` carry function (and syscall) arguments; `x0` also carries the return value.
- `x16` holds the syscall number on macOS. `svc #0x80` hands control to the kernel.
- `sp` is the stack pointer, `pc` is the address of the next instruction.
- Every instruction is exactly 4 bytes. `objdump -d` shows you the encoding.
