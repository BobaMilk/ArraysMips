.text
.globl main
main:
 la $a0, array_base # Setting Array Base
 lw $a1, array_size # Setting Array size
 jal PrintIntArrayR # Calling the fucntion that outputs the array in reverse
 jal Exit # BYE
.data # Settintg up the array
 array_size: .word 5
 array_base: # inputting the array info
 .word 12
 .word 7
 .word 3
 .word 5
 .word 1
.data
.include "utils.asm"
