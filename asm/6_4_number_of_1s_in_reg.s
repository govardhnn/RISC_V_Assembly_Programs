
# counting the number of bits in a reg *great program*

addi s0, zero, 0x137 # should have 6 ones since 0x137 is (0001_0011_0111)base2
addi s1, zero, 0 # sum variable

loop: 
	beq s0, zero, exit # checks if number is reduced to 0 (there are no more 1s)
    addi t0, zero, 0 # temporary variable initialized
    andi t0, s0, 0b1 # checks if number's LSB is 1
    add s1, s1, t0 # and then adds that 1 to s1 when 1 is found
    srli s0, s0, 1 # barrel shifts number to the right by one bit
    j loop 

exit:


