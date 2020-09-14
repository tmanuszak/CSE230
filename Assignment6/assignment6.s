###########################################################
#  Assignment #: 6
#  Name: Trey Manuszak
#  ASU email: tmanusza@asu.edu
#  Course: CSE230 TTh 6-730pm
#  Description: Ask the user how many elements to store in an array and fills the array.
#  Then ask how many times to change the array. Then asks for a divisor. Check each element
#  if divisible by divisor. If so, multiply element by the divisor, else do nothing.
###########################################################

        .data
msg1:           .asciiz "Specify how many numbers should be stored in the array (at most 11):\n"
msg2:           .asciiz "Enter an integer: \n"
msg3:           .asciiz "Result Array Content:\n"
msg4:           .asciiz "Original Array Content:"
msg5:           .asciiz "\nSpecify how many times to repeat:\n"
newline:        .asciiz "\n"
numbers:        .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# We will unofficially declare the following variables
# $s0 = numbersSize (How many numbers the user wants to input)
# $t9 = counter for looping
# $s1 = base address of numbers
# $s2 = times to repeat
# $s3 = divisor

        .text
        .globl      main        # define a global function main

# The main reads in an array content,
# then it prints it,
# then it asks a user how many time to repeat
# the changeArrayContent operation. 
main: 
        la      $s1, numbers            # $s1 = base address of numbers

        # Get number of ints to be stored in numbers
        la      $a0, msg1	        # $a0 = address of msg1
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg1
        li	$v0, 5		        # $v0 = 5
        syscall                         # get numbersSize
        add	$s0, $v0, 0	        # $s0 = $v0 + 0 ($s0 = numbersSize)
        li      $t9, 0                  # counter = 0

# Loop to fill numbers with user input
fillArrayLoop:
        slt     $t0, $t9, $s0           # $t0 = 1 if counter < numberSize, else $t0 = 0
        beq     $t0, $zero, continue    # if $t0 = 0, continue

        # Get int from user
        la	$a0, msg2	        # $a0 = address of msg2
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg2
        li	$v0, 5		        # $v0 = 5
        syscall                         # get int
        sll     $t8, $t9, 2             # $t8 = counter * 4 
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        sw	$v0, 0($t8)             # store new integer in numbers[counter]
        addi	$t9, $t9, 1		# $t9 = $t9 + 1 (increment counter)
        j	fillArrayLoop		# jump to fillArrayLoop

continue:
        li	$t9, 0		        # $t9 = 0 (reset counter)
        la	$a0, msg4	        # $a0 = address of msg4
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg4

        # Loop to print original numbers array
printOriginal:
        slt     $t0, $t9, $s0           # $t0 = 1 if counter < numberSize, else $t0 = 0
        beq     $t0, $zero, continue1   # if $t0 = 0, continue1
        # print newline
        la      $a0, newline            # $a0 = address of newline
        li	$v0, 4		        # $v0 = 4
        syscall                         # print newline
        sll     $t8, $t9, 2             # $t8 = counter * 4 (address of numbers[counter])
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        lw	$a0, 0($t8)             # load new integer in numbers[counter]
        li      $v0, 1                  # $v0 = 1
        syscall                         # print numbers[counter]
        addi	$t9, $t9, 1		# $t9 = $t9 + 1 (increment array counter)
        j	printOriginal		# jump to printOriginal

        # ask user how many times to change array
continue1:
        la	$a0, msg5	        # $a0 = address of msg5
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg5
        li	$v0, 5		        # $v0 = 5
        syscall                         # get times to repeat
        add	$s2, $v0, 0	        # $s2 = $v0 + 0 ($s2 = times to repeat)
        li      $t7, -1                 # set repeat counter

        # Loop to get the divisor to check the numbers array with
getDivisor:
        addi	$t7, $t7, 1		# $t7 = $t7 + 1
        slt     $t0, $t7, $s2           # $t0 = 1 if counter < times to repeat, else $t0 = 0
        beq     $t0, $zero, exit        # if $t0 = 0, exit
        la	$a0, msg2	        # $a0 = address of msg2
        li	$v0, 4	        	# $v0 = 4
        syscall                         # print msg2
        li	$v0, 5	        	# $v0 = 5
        syscall                         # get divisor
        add	$s3, $v0, 0	        # $s3 = $v0 + 0 ($s3 = divisor)
        li      $t9, 0                  # reset array counter
        # print result array message
        la	$a0, msg3	        # $a0 = address of msg3
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg3

        # check if numbers[counter]
changeArray:
        slt     $t0, $t9, $s0           # $t0 = 1 if counter < numberSize, else $t0 = 0
        beq     $t0, $zero, getDivisor  # if $t0 = 0, getDivisor
        sll     $t8, $t9, 2             # $t8 = counter * 4 (address of numbers[counter])
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        lw	$a0, 0($t8)             # load integer in numbers[counter]
        div	$a0, $s3		# $a0 / $s3
        mfhi    $a1
        bne	$a1, $zero, printNumber	# if $a1 != $zero then printNumber
        # numbers[counter] = numbers[counter] * divisor
        mult	$a0, $s3	        # $a0 * $s3 = Hi and Lo registers
        mflo	$a0			# copy Lo to $a0
        sll     $t8, $t9, 2             # $t8 = counter * 4 
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        sw	$a0, 0($t8)             # store new integer in numbers[counter]

        # print numbers[counter]
printNumber:                         
        sll     $t8, $t9, 2             # $t8 = counter * 4 
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        lw	$a0, 0($t8)	        # $a0 = numbers[counter]
        li      $v0, 1                  # $v0 = 1
        syscall                         # print numbers[counter]
        la      $a0, newline            # $a0 = address of newline
        li	$v0, 4		        # $v0 = 4
        syscall                         # print newline
        addi    $t9, $t9, 1             # $t9 = $t9 + 1
        j	changeArray		# jump to changeArray
        
        
exit:
        jr	$ra			# jump to $ra
        