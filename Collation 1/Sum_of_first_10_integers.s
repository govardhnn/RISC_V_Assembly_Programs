# x10 is sum
# x11 is counter_variable
# x12 is the (max integer + 1) 

addi x10, x0, 0
addi x11, x0, 1
addi x12, x0, 11 # will count till 10 and bne out

loop:
    add x10, x10, x11 # sum = sum + counter_variable
    addi x11, x11, 1
    bne x11, x12, loop
    
end:
    ecall
    

