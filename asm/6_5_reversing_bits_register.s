# reversing the bits of a register *another great program*

addi s0, zero, 0b10011 # 19 is the number to be reversed, should be converted to 0b11001 ie (25)base10

addi s1, zero, 0 # register to store the reversed number

loop: 
    beq s0, zero exit # if number is reduced to 0, exit
    slli s1, s1, 0b1 # shift that number closer to the MSB by 1 bit    
    andi t0, s0, 0b1 # and the LSB of the number with 1 
    add s1, s1, t0 # then save it to s1
    srli s0, s0, 0b1 # shift the original number right, reducing it towards LSB
    j loop
    
exit:

##This program in HLL would be like
# while(s0!=0) {
# s1 = s1 << 1
# s1 = s1 + (s0 & 1)
# s0 = s0 >> 1
# }
