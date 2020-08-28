###########################################################
# Assignment #: 3
#  Name: Trey Manuszak
#  ASU email: tmanusza@asu.edu
#  Course: CSE230 TTh 6-730pm
#  Description: This program asks the user for 4 integers, then displays them and makes a few calculations.
###########################################################

# data declarations
        .data
msg1:   .asciiz     "Enter a value:\n"
msg2:   .asciiz     "Enter another value:\n"
msg3:   .asciiz     "Enter one more value:\n"
msg4:   .asciiz     "num4+num1="
msg5:   .asciiz     "\nnum1-num2="
msg6:   .asciiz     "\nnum4*num2="
msg7:   .asciiz     "\nnum1/num3="
msg8:   .asciiz     "\nnum3 mod num1="
msg9:   .asciiz     "\n((((num2 mod 4) + num3) * 2) / num4) + num1="

# We will "unofficially" define the following integers and registers as needed
# $s1 = num1
# $s2 = num2
# $s3 = num3
# $s4 = num4
# $t1 = ans1
# $t2 = ans2
# $t3 = ans3
# $t4 = ans4
# $t5 = ans5
# ans6 (this will alternate between $t6 and $t7 when calculated)

        .text
        .globl      main        # define a global function main

# the program begins execution at main()
main:
        # Get num1
        la		$a0, msg1	# $a0 = address of msg1
        li		$v0, 4		# $v0 = 4
        syscall                         # print msg1
        li		$v0, 5		# $v0 = 5
        syscall                         # get num4
        add		$s1, $v0, 0	# $s1 = $v0 + 0 ($s1 = num1)
        
        # Get num2
        la		$a0, msg2	# $a0 = address of msg2
        li		$v0, 4		# $v0 = 4
        syscall                         # print msg2
        li		$v0, 5		# $v0 = 5
        syscall                         # get num4
        add		$s2, $v0, 0	# $s2 = $v0 + 0 ($s2 = num2)

        # Get num3
        la		$a0, msg3	# $a0 = address of msg3
        li		$v0, 4		# $v0 = 4
        syscall                         # print msg3
        li		$v0, 5		# $v0 = 5
        syscall                         # get num4
        add		$s3, $v0, 0	# $s3 = $v0 + 0 ($s3 = num3)

        # Get num4
        la		$a0, msg3	# $a0 = address of msg3
        li		$v0, 4		# $v0 = 4
        syscall                         # print msg3
        li		$v0, 5		# $v0 = 5
        syscall                         # get num4
        add		$s4, $v0, 0	# $s4 = $v0 + 0 ($s4 = num4)

        # Calculate and print ans1 = num4+num1
        add             $t1, $s4, $s1   # $t1 = num4 + num1
        li		$v0, 4		# $v0 = 1
        la		$a0, msg4	# $a0 = address of msg4
        syscall                         # print msg4
        li		$v0, 1		# $v0 = 1
        add		$a0, $t1, 0	# $a0 = $t1 + 0
        syscall                         # print ans1

        # Calculate and print ans2 = num1-num2
        sub             $t2, $s1, $s2   # $t1 = num1 - num2
        li		$v0, 4		# $v0 = 1
        la		$a0, msg5	# $a0 = address of msg5
        syscall                         # print msg5
        li		$v0, 1		# $v0 = 1
        add		$a0, $t2, 0	# $a0 = $t2 + 0
        syscall                         # print ans2

        # Calculate and print ans3 = num4*num2
        mult            $s4, $s2        # num4*num2
        mflo            $t3             # lower register of ans3 stored in $t3, which is adequate for 4 inputs
        li		$v0, 4		# $v0 = 1
        la		$a0, msg6	# $a0 = address of msg6
        syscall                         # print msg6
        li		$v0, 1		# $v0 = 1
        add		$a0, $t3, 0	# $a0 = $t3 + 0
        syscall                         # print ans3
        
        # Calculate and print ans4 = num1/num3
        div             $s1, $s3        # num1 / num3
        mflo            $t4             # ans4 is the quotient of num1 / num3
        li		$v0, 4		# $v0 = 1
        la		$a0, msg7	# $a0 = address of msg7
        syscall                         # print msg7
        li		$v0, 1		# $v0 = 1
        add		$a0, $t4, 0	# $a0 = $t4 + 0
        syscall                         # print ans4

        # Calculate and print ans4 = num3 mod num1
        div             $s3, $s1        # num3 / num1
        mfhi            $t5             # ans5 is the remainder of num3 / num1
        li		$v0, 4		# $v0 = 1
        la		$a0, msg8	# $a0 = address of msg8
        syscall                         # print msg8
        li		$v0, 1		# $v0 = 1
        add		$a0, $t5, 0	# $a0 = $t5 + 0
        syscall                         # print ans5

        # Calculate and print ans6 = ((((num2 mod 4) + num3) * 2) / num4) + num1
        addi            $t0, 4          # $t0 = 4
        div             $s2, $t0        # num2 / 4
        mfhi            $t6             # ans6 is the remainder of num2 / num4
        add             $t7, $t6, $s3   # ans6 = ans6 + num3
        addi            $t0, -2         # $t0 = 2
        mult            $t7, $t0        # ans * 2
        mflo            $t7             # ans6 is the result of the multiplication
        div             $t7, $s4        # ans6 / num4
        mflo            $t7             # ans6 is the quotient of ans6 / num4
        add             $t6, $t7, $s1   # ans6 = ans6 + num1
        li		$v0, 4		# $v0 = 1
        la		$a0, msg9	# $a0 = address of msg9
        syscall                         # print msg9
        li		$v0, 1		# $v0 = 1
        add		$a0, $t6, 0	# $a0 = $t6 + 0
        syscall                         # print ans6

        jr		$ra		# jump to $ra
        