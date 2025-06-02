# vrgather_full_test.S
    .section .data
    .align 3 # Ensure 8-byte alignment for vector data

source_elements_full:
    .word 100,  200,  300,  400,  500  # Indices 0-4 (values for v4[0] to v4[4])
    .word 600,  700,  800,  900, 1000  # Indices 5-9 (values for v4[5] to v4[9])
    .word 1100                           # Index 10  (value for v4[10])
                                         # Total 11 elements

gather_indices_full:
    .word   1,   2,   3,   4,   5      # Values 1-5 for v8[0] to v8[4]
    .word   6,   7,   8,   9,  10      # Values 6-10 for v8[5] to v8[9]
                                         # Total 10 elements

    .section .text
    .globl _start

_start:
    # --- Load source_elements_full into v4 (LMUL=m4 group) ---
    # Set vl=11, SEW=32, LMUL=m4 to load all 11 source elements.
    # For VLEN=128, AVLMAX = (4 * 128) / 32 = 16. So vl will be 11.
    li      t0, 11
    vsetvli t1, t0, e32, m4, ta, ma

    la      a0, source_elements_full
    vle32.v v4, (a0)                  # v4 group now holds {100, 200, ..., 1100}

    # --- Load gather_indices_full into v8 (LMUL=m4 group) ---
    # Set vl=10, SEW=32, LMUL=m4. This vl will also be used for vrgather.
    # For VLEN=128, AVLMAX = 16. So vl will be 10.
    li      t0, 10
    vsetvli t1, t0, e32, m4, ta, ma   # vtype is e32,m4, vl is 10

    # Calculate address of gather_indices_full.
    # source_elements_full has 11 words * 4 bytes/word = 44 bytes.
    # a0 still holds the address of source_elements_full.
    addi    a1, a0, 44
    vle32.v v8, (a1)                  # v8 group now holds {1, 2, ..., 10}

    # --- Explicitly set v0 to all 1s for the mask ---
    # Assumes v0 is initially zero or its prior state is irrelevant.
    # vl is 10 from the vsetvli above.
    li      t2, 0                   # Load 0 into a scalar register
    vmseq.vx v0, v0, t2             # v0[i] = (v0[i] == x[t2]) ? 1 : 0. Sets v0 to all 1s.

    # --- Perform vector register gather ---
    # Current vl is 10.
    # vd[i] = (vs1[i] >= VLMAX_for_vs2) ? 0 : vs2[vs1[i]]
    # vs2 is v4, vs1 is v8.
    # VLMAX_for_v4 (LMUL=m4, SEW=32, VLEN=128 assumed) = 16.
    # Indices in v8 are {1, 2, ..., 10}, all are < 16.
    # So, v12[i] = v4[v8[i]].
    # v12[0] = v4[v8[0]] = v4[1] = 200
    # v12[1] = v4[v8[1]] = v4[2] = 300
    # ...
    # v12[9] = v4[v8[9]] = v4[10] = 1100
    # Expected v12 (10 elements) = {200, 300, ..., 1000, 1100}
    vrgather.vv v12, v4, v8, v0.t     # v0.t for unmasked (v0 reg still contains all 1s from vmseq)

    # Standard exit sequence
    li      a0, 0    # Exit code 0
    li      a7, 93   # Service 93 is exit
    ecall

