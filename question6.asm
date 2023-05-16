.text
 la $a0, USERINPUT
 jal PromptInt
 move $a1, $v0 # store size of array in a1
 jal RandAllocateArray # creates an array of input size with random ints between 1 and 50
 
 move $a0, $s0 #  new base in s0
 move $a1, $s1 # new size in a1
 jal PrintIntArray # outputs the array

 
 move $a0, $s0 # restore base in a0
 move $a1, $s2 # restore size  a1
 jal BubbleSort # sorts the array using BubbleSor
 
 move $a0, $s0  # restore base in a0
 move $a1, $s1 # restore size  a1
 jal PrintIntArray # outputs sorted array
 
 jal Exit
 
.data
 USERINPUT: .asciiz "Enter the length of the array: "
 
.include "utils.asm"
