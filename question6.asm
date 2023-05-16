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


# Subprogram: 		swap
# Purpose: 		to swap values in an array of integers
# Input parameters:	$a0 - the array containing elements to swap
# 			$a1 - index of element 1
#			$a2 - index of elelemnt 2
# Side Effects:		Array is changed to swap element 1 and 2
.text
SwapB:
    sll $t0, $a1, 2	# calcualate address of element 1
    add $t0, $a0, $t0
    sll $t1, $a2, 2	# calculate address of element 2
    add $t1, $a0, $t1

    lw $t2, 0($t0) 	#swap elements
    lw $t3, 0($t1)
    sw $t2, 0($t1)
    sw $t3, 0($t0)
    
    jr $r

# Subproram: 	Bubble Sort
# Purpose:   	Sort data using a Bubble Sort algorithm
# Input Params:	$a0 - array
#		$a1 - array size
# Register conventions:
#		$s0 - array base
#		$s1 - array size
#		$s2 - outer loop counter
#		$s3 - inner loop counter


.text		
BubbleSort:
    addi $sp, $sp -20  	# save stack information
    sw $ra, 0($sp)	
    sw $s0, 4($sp)	# need to keep and restore save registers
    sw $s1, 8($sp) 
    sw $s2, 12($sp)  
    sw $s3, 16($sp)
    
    move $s0, $a0
    move $s1, $a1
    
    addi $s2, $zero, 0	#outer loop counter
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
            
            sll $t4, $s3, 2	# load data[j].  Note offset is 4 bytes
            add $t5, $s0, $t4
            lw $t2, 0($t5)	
            
            addi $t6, $t5, 4	# load data[j+1]
            lw $t3, 0($t6)
            
            sgt $t0, $t2, $t3
            beqz $t0, NotGreater
                move $a0, $s0
                move $a1, $s3
                addi $t0, $s3, 1
                move $a2, $t0
                jal SwapB  	# t5 is &data[j], t6 is &data[j=1]
                
            NotGreater:    
            addi $s3, $s3, 1
            b InnerLoop
        EndInnerLoop:
        
        addi $s2, $s2, 1
        b OuterLoop
    EndOuterLoop:
    
    lw $ra, 0($sp)	#restore stack information	
    lw $s0, 4($sp)
    lw $s1, 8($sp) 
    lw $s2, 12($sp)  
    lw $s3, 16($sp)  
    addi $sp, $sp 20
    jr $ra



# subprogram: Exit
# purpose: to use syscall service 10 to exit a program
# input: None
# output: None
.text
Exit:
li  $v0, 4
la  $a0, GOODBYE
syscall 
li $v0, 10
syscall
