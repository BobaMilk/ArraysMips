.text
PrintInt: 
 # allocates memory and preserves PrintInt's ra
 addi $sp, $sp, -4
 sw $ra, 0($sp)
 # Print string. The string address is already in $a0
 li $v0, 4
 syscall
 # Print integer. The integer value is in $a1, and must
 # be first moved to $a0.
 move $a0, $a1
 li $v0, 1
 syscall
 # call PrintNewLine
 #jal PrintNewLine
 # restore PrintInt's ra and deallocate memory
 lw $ra, 0($sp)
 addi $sp, $sp, 4
 #return
 jr $ra

.text
PrintString: 
 addi $v0, $zero, 4
 syscall
 jr $ra

.text
PromptInt: 
 # Print the prompt, which is already in $a0
 li $v0, 4
 syscall
 # Read the integer value. Note that at the end of the 
 # syscall the value is already in $v0, so there is no 
 # need to move it anywhere.
 li $v0, 5
 syscall
 #return
 jr $ra
 
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
addi $a1, $zero, 100  #upper bound of range
addi $a0, $zero, 0  #Lower bound of range
li $v0, 42
syscall
jr $ra



.text
RandAllocateArray:
 addi $sp, $sp, -4 # making some same on the stack
 sw $ra, 0($sp)
 
 mul $a0, $a1, 4 # allocates 4 bits for each element
 li $v0, 9 # array stored in v0
 syscall
 move $s0, $v0 # store base of array in s0
 move $s1, $zero # store 0 in s1
 move $s2, $a1 # store array size in s2
 L_B:
  sge $s3, $s1, $s2 # s3 is set to 1 once s1 (iterator) equals s2 (array size)
  bnez $s3, END # if s3 equals 1, end loop
  sll $s4, $s1, 2 # multiply iterator by 4 to account for memory
  add $s4, $s4, $s0 # add result to base of array to access element location

  
  jal RANNUMS
  move $s5, $a0 # Random number stored in $t1

  sw $s5, 0($s4) # store random number in the array
  addi $s1, $s1, 1 # iterate s1
 b L_B
 END:
 
 lw $ra, 0($sp)
 addi $sp, $sp, 4
 jr $ra

.text
BubbleSort:
    addi $sp, $sp -20      # save stack information
    sw $ra, 0($sp)
    sw $s0, 4($sp)    # need to keep and restore save registers
    sw $s1, 8($sp) 
    sw $s2, 12($sp)
    sw $s3, 16($sp)

    move $s0, $a0
    move $s1, $a1

    addi $s2, $zero, 0    #outer loop counter
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

            sll $t4, $s3, 2    # load data[j].  Note offset is 4 bytes
            add $t5, $s0, $t4
            lw $t2, 0($t5)

            addi $t6, $t5, 4    # load data[j+1]
            lw $t3, 0($t6)

            sgt $t0, $t2, $t3
            beqz $t0, NotGreater
                move $a0, $s0
                move $a1, $s3
                addi $t0, $s3, 1
                move $a2, $t0
                jal SwapB      # t5 is &data[j], t6 is &data[j=1]

            NotGreater:
            addi $s3, $s3, 1
            b InnerLoop
        EndInnerLoop:

        addi $s2, $s2, 1
        b OuterLoop
    EndOuterLoop:

    lw $ra, 0($sp)    #restore stack information
    lw $s0, 4($sp)
    lw $s1, 8($sp) 
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp 20
    jr $ra
    
.text
SwapB:
    sll $t0, $a1, 2    # calcualate address of element 1
    add $t0, $a0, $t0
    sll $t1, $a2, 2    # calculate address of element 2
    add $t1, $a0, $t1

    lw $t2, 0($t0)     #swap elements
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
li $v0, 10
syscall



