
addi s2, zero, 1 # a = 1
addi s3, zero, 2 # b = 2

addi sp, zero, -4 # assigning stack for one register

sw s2, 0(sp) # storing a = 1 in stack

add s2, zero, s3 # assigning a = b 
lw s3, 0(sp) # assigning b = stack memory at 0 ie. 1
