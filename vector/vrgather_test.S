    .section .data
    .align 3
source_elements:
    .word 10, 20, 30, 40, 50, 60, 70, 80

gather_indices:
    .word 3, 0, 1, 0, 7, 5

    .section .text
    .globl _start

_start:
    li      t0, 4
    vsetvli t1, t0, e32, m1, ta, ma

    la      a0, source_elements
    vle32.v v2, (a0)

    addi    a1, a0, 32              # a1 = address_of_source_elements + 32
    vle32.v v1, (a1)                  # v1 = {3, 0, 1, 0} (first vl elements)

    vrgather.vv v3, v2, v1, v0.t

    # Standard exit sequence
    li      a0, 0    # Exit code 0
    li      a7, 93   # Service 93 is exit
    ecall

