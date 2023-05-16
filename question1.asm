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
 cycle:
  sge $s3, $s1, $s2 # s3 is set to 1 once s1 (iterator) equals s2 (array size)
  bnez $s3, fin # if s3 equals 1, end loop
  sll $t0, $s1, 2 # multiply iterator by 4 to account for memory
  add $t0, $t0, $s0 # add result to base of array to access element location

  li $v0, 42 # generate random number
  la $a0, 1 # Lower bound is 1
  li $a1, 50 # Upper bound is 50
  syscall
  move $t1, $a0 # Random number stored in $t1

  sw $t1, 0($t0) # store random number in the array
  addi $s1, $s1, 1 # iterate s1
 b cycle
 fin:
 
 lw $ra, 0($sp)
 addi $sp, $sp, 4
 jr $ra
