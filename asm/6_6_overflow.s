.text
.globl main

main: 
	addi a2, zero, 2
    addi a3, zero, -2048
    sub t0, a2, a3 
    add t1, t0, a3 
    # if t0 is not equal to t1, then there is an overflow
    bne t0, t1 , overflow # s1 = 1 indicated, overflow has occured
    j no_overflow

overflow: addi s1, zero, 1
    ret
    
no_overflow: 
    addi s1, zero, 0
	ret
    