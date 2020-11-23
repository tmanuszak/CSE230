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
msg6:           .asciiz " repetitions\n"
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
#	$f4 = # with most appearances
#	$s2 = # of appearances
############################################################################
main:
	# get arraysize
	la	$a0, msg1			# $a0 = address of msg1
	li	$v0, 4				# $v0 = 4
	syscall					# print msg1
	li	$v0, 5				# $v0 = 5
	syscall					# get arraysize
	slti	$t0, $v0, 15			# if $v0 < 15 then $t0 = 1, else $t0 = 0
	bne	$t0, $zero, mainContinue	# jump to mainContinue if $v0 < 15
	li	$v0, 15				# $v0 = 15		

mainContinue:
	addi	$s0, $v0, 0			# $s0 = arraySize
	la	$s1, numbers			# $s1 = base address of numbers
	# call readArray
	addi 	$sp, $sp, -4			# $sp -= 4
	sw	$ra, 0($sp)			# store $ra
	jal	readArray			# jump to readArray and save position to $ra
	lw	$ra, 0($sp)			# load $ra
	addi	$sp, $sp, 4			# $sp += 4
	
	# print msg3
	la	$a0, msg3			# $a0 = address of msg3
	li	$v0, 4				# $v0 = 4
	syscall					# print msg3

	# call printArray
	addi 	$sp, $sp, -4			# $sp -= 4
	sw	$ra, 0($sp)			# store $ra
	jal	printArray			# jump to printArray and save position to $ra
	lw	$ra, 0($sp)			# load $ra
	addi	$sp, $sp, 4			# $sp += 4

	# find most appearances
	addi 	$sp, $sp, -4			# $sp -= 4
	sw	$ra, 0($sp)			# store $ra
	jal	mostInArray			# jump to mostInArray and save position to $ra
	lw	$ra, 0($sp)			# load $ra
	addi	$sp, $sp, 4			# $sp += 4

	# print most occurrences info
	la	$a0, msg4			# $a0 = address of msg4
	li	$v0, 4				# $v0 = 4
	syscall					# print msg4
	mov.s	$f12, $f4			# $f12 = $f4
	li	$v0, 2				# $v0 = 2
	syscall					# print $f12
	la	$a0, msg5			# $a0 = address of msg5
	li	$v0, 4				# $v0 = 4
	syscall					# print msg5
	move	$a0, $s2			# $a0 = $s2
	li	$v0, 1				# $v0 = 1
	syscall					# print $s2
	la	$a0, msg6			# $a0 = address of msg6
	li	$v0, 4				# $v0 = 4
	syscall					# print msg1

	# printChangeArray
	addi 	$sp, $sp, -4			# $sp -= 4
	sw	$ra, 0($sp)			# store $ra
	jal	printChangeArray		# jump to printChangeArray and save position to $ra
	lw	$ra, 0($sp)			# load $ra
	addi	$sp, $sp, 4			# $sp += 4

	# exit program
	jr	$ra				# jump to $ra


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
	swc1	$f0, 0($t8)			# store float in numbers[i]
	addi	$t0, $t0, 1			# i += 1
	j	readArrayLoop			# jump to readArrayLoop

exitReadArray:
	jr	$ra				# jump to $ra



###########################################################################
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
	lwc1	$f12, 0($t8)			# $f12 = numbers[i]
	li	$v0, 2				# $v0 = 2
	syscall					# print numbers[i]
	la 	$a0, msg8			# $a0 = address of newline
	li	$v0, 4				# $v0 = 4
	syscall					# print newline
	addi	$t0, $t0, 1			# $t0 += 1
	j	printArrayLoop			# jump to printArrayLoop

exitPrintArray:
	jr	$ra				# jump to $ra



############################################################################
# Procedure/Function: mostInArray
# Description: Go through numbers and find number with most occurences and
#		# of appearances
# Parameters: 
# 	$s0 = arraysize
# 	$s1 = base address of numbers
#	$f4 = # with most appearances
#	$s2 = # of appearances
#	$t0 = loop counter i
#	$t1 = loop counter j
#	$t2 = current count of numbers[i]
############################################################################
mostInArray:
	li	$t0, 0				# i = 0
	li	$s2, 0				# most # of appearances = 0

mostInArrayLoop1:
	# while i < arraysize
	slt	$t3, $t0, $s0			# if i < arraysize, $t3 = 1, else $t3 = 0
	beq	$t3, $zero, exitMostInArray	# if $t3 = $zero then exitMostInArray
	add	$t1, $t0, $zero			# j = i
	li	$t2, 0				# current count of numbers[i] = 0
	sll	$t9, $t0, 2			# $t9 = i * 4
	add	$t8, $t9, $s1			# $t8 = base address of numbers[i]
	lwc1	$f6, 0($t8)			# $f6 = numbers[i]
	j	mostInArrayLoop2		# jump to mostInArrayLoop2

mostInArrayLoop2:
	# while j < arraysize
	slt	$t3, $t1, $s0			# if j < arraysize, $t3 = 1, else $t3 = 0
	beq	$t3, $zero, check		# if $t3 = $zero then check
	sll	$t9, $t1, 2			# $t9 = j * 4
	add	$t8, $t9, $s1			# $t8 = base address of numbers[j]
	lwc1	$f8, 0($t8)			# $f8 = numbers[j]
	c.eq.s	$f6, $f8			# if $f6 = $f8, then bc1t
	bc1t	increaseCount			# jump to increaseCount
	addi	$t1, $t1, 1			# j++
	j	mostInArrayLoop2		# jump to mostInArrayLoop2

increaseCount:
	addi	$t2, $t2, 1			# current count of numbers[i] ++
	addi	$t1, $t1, 1			# j++
	j	mostInArrayLoop2		# jump to mostInArrayLoop2

check:
	slt	$t3, $t2, $s2			# if count of numbers[i] < most appearances $t3 = 1 else $t3 = 0
	beq	$t3, $zero, replace		# if $t3 = $zero, then we need to update most occurences
	addi	$t0, $t0, 1			# i++
	j	mostInArrayLoop1		# jump to mostInArrayLoop1

replace:
	mov.s	$f4, $f6			# update most occurred number
	move	$s2, $t2			# update number of appearances
	addi	$t0, $t0, 1			# i++
	j	mostInArrayLoop1		# jump to mostInArrayLoop1	

exitMostInArray:
	jr	$ra				# jump to $ra

###########################################################################
# Procedure/Function: printChangeArray
# Description: print numbers array with zero where most occurred number is located
# Parameters: 
# 	$s0 = arraysize
# 	$s1 = base address of numbers
#	$f4 = float that is occurred the most
#	$t0 = loop counter
############################################################################
printChangeArray:
	li 	$t0, 0				# i = 0
	sub.s	$f10, $f10, $f10		# $f10 = 0

printChangeArrayLoop:
	# while i < arraysize
	slt	$t1, $t0, $s0			# if i < arraysize, $t1 = 1, else $t1 = 0
	beq	$t1, $zero, exitPrintChangeArray	# if $t1 = $zero then exitPrintArray
	sll	$t9, $t0, 2			# $t9 = i * 4
	add	$t8, $t9, $s1			# $t8 = base address of numbers[i]
	lwc1	$f12, 0($t8)			# $f12 = numbers[i]
	c.eq.s	$f12, $f4			# if $f12 = $f4 then bc1t
	bc1t	printZero			# jump to printZero
	li	$v0, 2				# $v0 = 2
	syscall					# print numbers[i]
	la 	$a0, msg8			# $a0 = address of newline
	li	$v0, 4				# $v0 = 4
	syscall					# print newline
	addi	$t0, $t0, 1			# $t0 += 1
	j	printChangeArrayLoop		# jump to printChangeArrayLoop

printZero:
	mov.s	$f12, $f10			# $f12 = floating pt zero
	li	$v0, 2				# $v0 = 2
	syscall					# print float pt zero
	la 	$a0, msg8			# $a0 = address of newline
	li	$v0, 4				# $v0 = 4
	syscall					# print newline
	addi	$t0, $t0, 1			# $t0 += 1
	j	printChangeArrayLoop		# jump to printChangeArrayLoop
	

exitPrintChangeArray:
	jr	$ra				# jump to $ra

