.text
la $a0, USERINPUT
jal PromptInt
move $a1, $v0 # store size of array in a1
jal RandAllocateArray # creates an array of input size with random ints between 1 and 50
move $a0, $s0 # new base in s0
move $a1, $s1 # new size in a1
jal PrintIntArray # outputs the array
move $a0, $s0 # restore base in a0
move $a1, $s2 # restore size a1
jal BubbleSort # sorts the array using BubbleSor
move $a0, $s0 # restore base in a0
move $a1, $s1 # restore size a1
jal PrintIntArray # outputs sorted array
jal Exit
.data
USERINPUT: .asciiz "Enter the length of the array: "
.include "utils.asm"
.text
PrintIntArray:
addi $sp, $sp, -16 # Stack record
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
move $s0, $a0 # save the base of the array to $s0
# initialization for counter loop
# $s1 is the ending index of the loop
# $s2 is the loop counter
move $s1, $a1
move $s2, $zero
la $a0 open_bracket # print open bracket
jal PrintString
loop:
# check ending condition
sge $t0, $s2, $s1
bnez $t0, end_loop
sll $t0, $s2, 2 # Multiply the loop counter by
# by 4 to get offset (each element
# is 4 big).
add $t0, $t0, $s0 # address of next array element
lw $a1, 0($t0) # Next array element
la $a0, comma
jal PrintInt # print the integer from array
addi $s2, $s2, 1 #increment $s0
b loop
end_loop:
li $v0, 4 # print close bracket
la $a0, close_bracket
syscall
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp) # restore stack and return
addi $sp, $sp, 16
jr $ra
.data
open_bracket: .asciiz "["
close_bracket: .asciiz "]"
comma: .asciiz " "
# subprogram: RANDOM-NUMS
# purpose: Return a randaom numuber
# input: $s0
# output: $s1
.text
RANNUMS:
addi $a1, $zero, 1000 #upper bound of range
addi $a0, $zero, 1 #Lower of range
li $v0, 42
syscall
jr $ra
.text
RandAllocateArray:
addi $sp, $sp, -4 # making space stack
sw $ra, 0($sp)
mul $a0, $a1, 4 # makes each element
li $v0, 9
syscall
move $s0, $v0
move $s1, $zero # store 0 in s1
move $s2, $a1 # store array size in s2
L_B:
 sge $s3, $s1, $s2 # = 1
 bnez $s3, END # if s3 = 1 then leave
 sll $s4, $s1, 2 # multiply by 4
 add $s4, $s4, $s0 # base++

 jal RANNUMS
 move $s5, $a0 # Random number stored in $t1
 sw $s5, 0($s4) # random = array
 addi $s1, $s1, 1
b L_B
END:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra # bye
.text
BubbleSort:
 addi $sp, $sp -20 # save stack information
 sw $ra, 0($sp)
 sw $s0, 4($sp) # need to keep and restore save registers
 sw $s1, 8($sp)
 sw $s2, 12($sp)
 sw $s3, 16($sp)
 move $s0, $a0
 move $s1, $a1
 addi $s2, $zero, 0 #outer loop counter
 OuterLoop:
 addi $t1, $s1, -1
 slt $t0, $s2, $t1
 beqz $t0, EndOuterLoop
 addi $s3, $zero, 0 #inner loop counter
 InnerLoop:
 addi $t1, $s1, -1
 sub $t1, $t1, $s2
 slt $t0, $s3, $t1
 beqz $t0, EndInnerLoop
 sll $t4, $s3, 2 # load data[j]. Note offset is 4 bytes
 add $t5, $s0, $t4
 lw $t2, 0($t5)
 addi $t6, $t5, 4 # load data[j+1]
 lw $t3, 0($t6)
 sgt $t0, $t2, $t3
 beqz $t0, NotGreater
 move $a0, $s0
 move $a1, $s3
 addi $t0, $s3, 1
 move $a2, $t0
 jal SwapB # t5 is &data[j], t6 is &data[j=1]
 NotGreater:
 addi $s3, $s3, 1
 b InnerLoop
 EndInnerLoop:
 addi $s2, $s2, 1
 b OuterLoop
 EndOuterLoop:
 lw $ra, 0($sp) #restore stack information
 lw $s0, 4($sp)
 lw $s1, 8($sp)
 lw $s2, 12($sp)
 lw $s3, 16($sp)
 addi $sp, $sp 20
 jr $ra

.text
SwapB:
 sll $t0, $a1, 2 # calcualate address of element 1
 add $t0, $a0, $t0
 sll $t1, $a2, 2 # calculate address of element 2
 add $t1, $a0, $t1
 lw $t2, 0($t0) #swap elements
 lw $t3, 0($t1)
 sw $t2, 0($t1)
 sw $t3, 0($t0)
 jr $ra

# subprogram: Exit
# purpose: to use syscall service 10 to exit a program
# input: None
# output: None
.text
Exit:
li $v0, 4
la $a0, GOODBYE
syscall
li $v0, 10
syscall
.data
GOODBYE: .asciiz "\nGOOODBYE\n"
