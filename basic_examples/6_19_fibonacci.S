.section .text

.globl _start

# Fibonacci Series 
# 1 1 2 3 5 8 13 21 34 55 
_start: 
	addi s0, zero, 1 # first number
	addi s1, zero, 1 # second number


	addi s3, zero, 0 # pointer variable
	addi s4, zero, 7 # range of the series
	addi s2, s2, 0 # variable for adding the prev. two numbers

	loop: 
		add s2, s0, s1 # sum of previous two numbers
		add s0, zero, s1 # s0 = s1
   		add s1, zero, s2 # s1 = s2
    	addi s3, s3, 1 # incrementing the pointer
    	bgt s3, s4, exit # loop condition check
    	j loop
   
exit:
	li a7, 93
	ecall