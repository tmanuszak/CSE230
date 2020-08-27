###########################################################
# Assignment #: 2
#  Name: Trey Manuszak
#  ASU email: tmanusza@asu.edu
#  Course: CSE230 TTh 6-730pm
#  Description: This program adds and subtracts two integers then displays the sum and the difference.
###########################################################

# data declarations
        .data
msg1:   .asciiz     "num1 is: "
msg2:   .asciiz     "\nnum2 is: "
msg3:   .asciiz     "\nnum1+num2 = "
msg4:   .asciiz     "\nnum1-num2 = "
num1:   .word       91543
num2:   .word       0xD8C

        .text
        .globl      main        # define a global function main

# the program begins execution at main()
main:
        la              $t0, num1       # $t0 = address of num1
        lw		$t1, 0($t0)     # $t1 =  91543
        la		$t2, num2       # $t2 = address of num2 
        lw              $t3, 0($t2)     # $t3 = 0xD8C
        la		$a0, msg1   	# $a0 = address of msg1 
        li		$v0, 4		# $v0 = 4
        syscall                         # print msg1
        add		$a0, $t1, 0	# $a0 = $t1 + 0
        li		$v0, 1      	# $v0 = 1
        syscall                         # print num1
        la		$a0, msg2   	# $a0 = address of msg2 
        li		$v0, 4		# $v0 = 4
        syscall                         # print msg2        
        add		$a0, $t3, 0	# $a0 = $t3 + 0
        li		$v0, 1      	# $v0 = 1
        syscall                         # print num2        
        la		$a0, msg3   	# $a0 = address of msg3 
        li		$v0, 4		# $v0 = 4
        syscall                         # print msg3
        add		$a0, $t1, $t3	# $a0 = $t1 + $t3 (i.e. $a0 = 91543 + 0xD8C = 95011)
        li		$v0, 1      	# $v0 = 1
        syscall                         # print num1 + num2                
        la		$a0, msg4   	# $a0 = address of msg4 
        li		$v0, 4		# $v0 = 4
        syscall                         # print msg4        
        sub		$a0, $t1, $t3	# $a0 = $t1 - $t3 (i.e. $a0 = 91543 - 0xD8C = 88075)
        li		$v0, 1          # $v0 = 1
        syscall                         # print num1 - num2
        jr              $ra             # return