###########################################################
# Assignment #: 5
#  Name: Trey Manuszak
#  ASU email: tmanusza@asu.edu
#  Course: CSE230 TTh 6-730pm
#  Description: 
###########################################################

# data declarations
        .data
msg1:   .asciiz     "Enter an ending index:\n"
msg2:   .asciiz     "Enter an integer:\n"
msg3:   .asciiz     "Enter another integer:\n"
msg4:   .asciiz     "Result Array Content:\n"
msg5:   .asciiz     "\n"
numbers_len:        .word     11
numbers:            .word     2, 19, 23, -7, 15, -17, 11, -4, 23, -26, 27

# We will unofficially declare the following registers as
# $s0 = endingIndex
# $s1 = num1
# $s2 = num2
# $s3 = j (loop index)
# $s4 = base address of numbers
# $s5 = numbers_len

        .text
        .globl      main        # define a global function main

# The program begins execution at main()
main:
        la		$s4, numbers		    # $s4 = base address of numbers
        la      $t0, numbers_len        # $t0 = address of numbers_len
        lw		$s5, 0($t0)             # $s5 =  numbers_len
        
        # Get endingIndex
        la	    $a0, msg1	            # $a0 = address of msg1
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg1
        li	    $v0, 5		            # $v0 = 5
        syscall                         # get endingIndex
        add	    $s0, $v0, 0	            # $s0 = $v0 + 0 ($s0 = endingIndex)

        # Get num1
        la	    $a0, msg2	            # $a0 = address of msg2
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg2
        li	    $v0, 5		            # $v0 = 5
        syscall                         # get num1
        add	    $s1, $v0, 0	            # $s1 = $v0 + 0 ($s1 = num1)

        # Get num2
        la	    $a0, msg3	            # $a0 = address of msg3
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg3
        li	    $v0, 5		            # $v0 = 5
        syscall                         # get num2
        add	    $s2, $v0, 0	            # $s2 = $v0 + 0 ($s0 = num2)

        # If num1 is larger than num2, swap them.
        slt     $t0, $s2, $s1           # $t0 = 1 if num2 < num1, else $t0 = 0
        beq		$t0, $zero, loop    # if $t0 == $zero then loop
        add     $t0, $s2, 0             # $t0 = $s2
        add     $s2, $s1, 0             # $s2 = $s1
        add     $s1, $t0, 0             # $s1 = $t0

# At this point num1 will always be less or equals to num2.
# Now, change the array content.
        li      $s3, 0                  # $s3 = j = 0
loop:
        slt     $t0, $s3, $s0           # $t0 = 1 if j < ending index, else $t0 = 0
        beq     $t0, $zero, exitprint   # if $t0 = $zero then exitprint
        slt     $t0, $s3, $s5           # $t0 = 1 if j < numbers_len, else $t0 = 0
        beq		$t0, $zero, exitprint	# if $t0 == $zero then exitprint
        sll     $t1, $s3, 2             # $t1 = j * 4
        add     $t2, $t1, $s4           # $t2 = address of numbers[j]
        lw		$t3, 0($t2)		        # $t3 = numbers[j]

        # Check numbers[j] > num1 && numbers[j] < num2
        slt     $t0, $s1, $t3           # $t0 = 1 if num1 < numbers[j], else $t0 = 0
        beq     $t0, $zero, brokeif     # if $t0 = 0, then brokeif
        slt     $t0, $t3, $s2           #  $t0 = 1 if numbers[j] < num2, else $t0 = 0
        beq     $t0, $zero, brokeif     # if $t0 = 0, then brokeif

        # store numbers[j] = numbers[j]*num1 + num2
        mult	$t3, $s1			    # $t3 * $s1 = Hi and Lo registers
        mflo	$t3					    # copy Lo to $t3
        add		$t3, $t3, $s2		    # $t3 = $t3 + $s2
        sw		$t3, 0($t2)		        # numbers[j] = $t3
        addi	$s3, $s3, 1			    # $s3 = $s3 + 1
        j		loop				    # jump to loop
        
brokeif:
        addi	$s3, $s3, 1			    # $s3 = $s3 + 1
        j		loop				    # jump to loop
        
exitprint:
        la	    $a0, msg4	            # $a0 = address of msg4
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg4
        li      $s3, 0                  # $s3 = j = 0

printarray:
        slt     $t0, $s3, $s5           # $t0 = 1 if j < numbers_len, else $t0 = 0
        beq		$t0, $zero, exit	    # if $t0 == $zero then exit

        # print numbers[j]
        sll     $t1, $s3, 2             # $t1 = j * 4
        add     $t2, $t1, $s4           # $t2 = address of numbers[j]
        lw		$a0, 0($t2)		        # $t3 = numbers[j]
        li		$v0, 1		            # $v0 = 1
        syscall                         # print numbers[j]
        la	    $a0, msg5	            # $a0 = address of msg5
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print new line        
        addi    $s3, $s3, 1             # $s3 = $s3 + 1
        j		printarray				# jump to printarray
        

exit:
        jr      $ra                     # return

        
        