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
msg4:   .asciiz     "\nnum4+num1="
msg5:   .asciiz     "\nnum1-num2="
msg6:   .asciiz     "\nnum4*num2="
msg7:   .asciiz     "\nnum1/num3="
msg8:   .asciiz     "\nnum3 mod num1="
msg9:   .asciiz     "\nnum1-num2="

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
# $t6 = ans6

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



        jr		$ra					# jump to $ra
        