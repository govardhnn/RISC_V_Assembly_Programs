    .section .data
    .align 3
source_vec:
    .word 11, 22, 33, 44  # Source data: {11, 22, 33, 44}
mask_vec:
    .word 1, 1, 1, 0      # Mask: keep 1st, 2nd, and 3rd elements {1, 1, 1, 0}

    .section .text
    .globl _start

_start:
    # Set vector length for 4 elements, 32-bit, LMUL=1
    li      t0, 4
    vsetvli t1, t0, e32, m2, ta, ma   # vl will be 4

    # Load source data into v2
    la      a0, source_vec
    vle32.v v2, (a0)

    # Calculate mask_vec address: a1 = a0 (address of source_vec) + 16 bytes
    addi    a1, a0, 16
    vle32.v v0, (a1)

    # Perform vector compress
    # v4 will contain elements from v2 where the LSB of the corresponding element in v0 is 1.
    # Expected result in v4 (first two 32-bit elements): {11, 33}
    # The remaining elements in v4 depend on the tail policy (ta - tail agnostic).
    vcompress.vm v4, v2, v0

    # Standard exit sequence
    li      a0, 0    # Exit code 0
    li      a7, 93   # Service 93 is exit
    ecall

