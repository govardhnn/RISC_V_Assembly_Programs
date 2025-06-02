# Basic RISC-V Assembly Programs

|#|Problem|Solution|
|---|----|----|
||Fibonacci Series|[Solution](./basic_examples/6_19_fibonacci.s)|
|| Write a RISC-V assembly language program for swapping the contents of two registers, a0 and a1. You may not use any other registers.|[Solution](./basic_examples/6_1_swap_without_additional_reg.s)|
|| Write a RISC-V assembly language program to count the number of ones in a 32-bit number.|[Solution](./basic_examples/6_4_number_of_1s_in_reg.s)|
|| Write a RISC-V assembly language program to reverse the bits in a register. Use as few instructions as possible.|[Solution](./basic_examples/6_5_reversing_bits_register.s)|
|| Write a succinct RISC-V assembly language program to test whether overflow occurs when a2 is subtracted from a3.|[Solution](./basic_examples/6_6_overflow.s)|
<!--|| Write a RISC-V assembly language program for testing whether a given string is a palindrome. (Recall that a palindrome is a word that is the same forward and backward. For example, the words “wow” and “racecar” are palindromes.)|| -->
<!--|| Suppose you are given an array of both positive and negative integers. Write RISC-V assembly code that finds the subset of the array with the largest sum. Assume that the array’s base address and the number of array elements are in a0 and a1, respectively. Your code should place the resulting subset of the array starting at the base address in a2. Write code that runs as fast as possible.||
|| You are given an array that holds a sentence in a null-terminated string. Write a RISC-V assembly language program to reverse the words in the sentence and store the new sentence back in the array.||-->

# Vector ISA Assembly Programs

|#|Problem|Solution|
|---|----|----|
|| Test `vrgather.vv` with full vectors |[Solution](./vector/vrgather_full_test.S)|
|| *TODO Add more vector examples here* | *Link to solution* |

# Build Steps

### 1. Set the target directory and source file in the makefile.inc file `TARGET_DIR` and `TARGET_SRC`

### 2. Generate the ELF File for the assembly program

```bash
make all
```

### 3. Generate the Object dump for the assembly program

```bash
make objdump
```

### 4. Using Spike to debug the assembly program

```bash
make spike_debug
```

### 5. Using QEMU to debug the assembly program

```bash
make run &
```
Here the QEMU will run in the background on port 1234

```bash
make gdb
```

### Within the GDB, you can use the following commands

```bash
target remote :1234
stepi
continue
info registers
info vector
```

### Clean up the generated files

```bash
make clean
```

References: 

. Digital Design and Computer Architecture: RISC-V Edition by Sarah L. Harris and David Harris 

. RISC-V Assembly Language Programmer Manual Part I developed by: SHAKTI Development Team @ iitm ’20
