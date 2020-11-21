###########################################################
#  Assignment #: 11
#  Name: Trey Manuszak
#  ASU email: tmanusza@asu.edu
#  Course: CSE230 TTh 6-730pm
#  Description: Program that recieves floating point numbers from a user 
#		and makes multiple comparisons and edits for the user..
###########################################################

        .data
msg1:           .asciiz "Specify how many numbers should be stored in the array (at most 15):\n"
msg2:           .asciiz "Enter a number:\n"
msg3:           .asciiz "The array contains the following:\n"
msg4:           .asciiz "The number that appears the most is "
msg5:           .asciiz " with "
msg6:           .asciiz "repetitions\n"
msg7:           .asciiz "The result array contains the following:\n"
msg8:		.asciiz	"\n"
numbers:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        .text
        .globl      main        # define a global function main

############################################################################
# Procedure/Function: main
# Description: main function to call functions to run program from
# Parameters: 
# 	$s0 = arraysize
# 	$s1 = base address of numbers
############################################################################
main:
	# get arraysize
	la	$a0, msg1	# $a0 = address of msg1
	li	$v0, 4		# $v0 = 4
	syscall			# print msg1
	li	$v0, 5		# $v0 = 5
	syscall			# get arraysize
	addi	$s0, $v0, 0	# $s0 = arraysize
	la	$s1, numbers	# $s1 = base address of numbers

	# call readArray
	addi 	$sp, $sp, -4	# $sp -= 4
	sw	$ra, 0($sp)	# store $ra
	jal	readArray	# jump to readArray and save position to $ra
	lw	$ra, 0($sp)	# load $ra
	addi	$sp, $sp, 4	# $sp += 4
	
	# print msg3
	la	$a0, msg3	# $a0 = address of msg3
	li	$v0, 4		# $v0 = 4
	syscall			# print msg3

	# call printArray
	addi 	$sp, $sp, -4	# $sp -= 4
	sw	$ra, 0($sp)	# store $ra
	jal	printArray	# jump to printArray and save position to $ra
	lw	$ra, 0($sp)	# load $ra
	addi	$sp, $sp, 4	# $sp += 4



############################################################################
# Procedure/Function: readArray
# Description: read floating pt numbers from user and store in numbers
# Parameters: 
# 	$s0 = arraysize
# 	$s1 = base address of numbers
#	$t0 = loop counter
############################################################################
readArray:
	li 	$t0, 0				# i = 0

readArrayLoop:
	# while i < arraysize
	slt	$t1, $t0, $s0			# if i < arraysize, $t1 = 1, else $t1 = 0
	beq	$t1, $zero, exitReadArray	# if $t1 = $zero then exitReadArray
	la	$a0, msg2			# $a0 = address of msg2
	li	$v0, 4				# $v0 = 4
	syscall					# print msg2
	li	$v0, 6				# $v0 = 6
	syscall					# read float from user
	sll	$t9, $t0, 2			# $t9 = 4 * i
	add	$t8, $t9, $s1			# $t8 = address of numbers[i]
	swcl	$f0, 0($t8)			# store float in numbers[i]
	addi	$t0, $t0, 1			# i += 1
	j	readArrayLoop			# jump to readArrayLoop

exitReadArray:
	jr	$ra				# jump to $ra



############################################################################
# Procedure/Function: printArray
# Description: print floating pt numbers from numbers
# Parameters: 
# 	$s0 = arraysize
# 	$s1 = base address of numbers
#	$t0 = loop counter
############################################################################
printArray:
	li 	$t0, 0				# i = 0

printArrayLoop:
	# while i < arraysize
	slt	$t1, $t0, $s0			# if i < arraysize, $t1 = 1, else $t1 = 0
	beq	$t1, $zero, exitPrintArray	# if $t1 = $zero then exitPrintArray
	sll	$t9, $t0, 2			# $t9 = i * 4
	add	$t8, $t9, $s1			# $t8 = base address of numbers[i]
	lwcl	$f12, 0($t8)			# $f12 = numbers[i]
	li	$v0, 2				# $v0 = 2
	syscall					# print numbers[i]
	la 	$a0, msg8			# $a0 = address of newline
	li	$v0, 4				# $v0 = 4
	syscall					# print newline
	addi	$t0, $t0, 1			# $t0 += 1
	j	printArrayLoop			# jump to printArrayLoop

exitReadArray:
	jr	$ra				# jump to $ra
