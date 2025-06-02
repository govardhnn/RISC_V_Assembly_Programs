.section .text
.globl _start

_start:
addi s1, zero, 15
addi s2, zero, 10
bgt s1, s2, g_sum
addi s2, s2, -1
j exit

g_sum: 
addi s1, s1, 1
j exit

# Standard exit sequence
li a0, 0    # Exit code 0
li a7, 93  # Service 93 is exit
ecall

exit:

