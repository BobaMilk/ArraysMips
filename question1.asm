.text# MILA
    la $a0, array_base # Setting Array Base
    lw $a1, array_size  # Setting Array size
    jal PrintIntArrayR # Calling the fucntion that outputs the array in reverse
    jal Exit # BYE
.data # Settintg up the array 
    array_size: .word 5
    array_base: # inputting the array info
            .word 2
            .word 27
            .word 11
            .word 511
            .word 1

.data 

.include "utils.asm"
# Subprogram: PrintIntArray
# Purpose: print an array of ints
# inputs: $a0 - the base address of the array
#         $a1 - the size of the array
#
.text
PrintIntArrayR:

    addi $sp, $sp, -16        # Stack record
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    move $s0, $a0 # save the base of the array to $s0

 # initialization for counter loop
 # $s1 is the ending index of the loop
 # $s2 is the loop counter
 move $s1, $zero
 move $s2, $a1
 la $a0 open_bracket # print open bracket
 jal PrintString
loop:
 # check ending condition
 sle $t0, $s2, $s1
 bnez $t0, end_loop

 sll $t0, $s2, 2 # Multiply the loop counter by
 # by 4 to get offset (each element
 # is 4 big).
 add $t0, $t0, $s0 # address of next array element
 lw $a0, -4($t0) # Next array element
 jal PrintInt # print the integer from array
 la $a0, comma
 jal PrintString

 addi $s2, $s2, -1 #increment $s0
 b loop 
end_loop:

    li $v0, 4            # print close bracket
    la $a0, close_bracket
    syscall 


    lw $ra, 0($sp) 
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)        # restore stack and return
    addi $sp, $sp, 16
    jr $ra 

.data
    open_bracket:     .asciiz "["
    close_bracket:     .asciiz "]"
    comma:         .asciiz ","
