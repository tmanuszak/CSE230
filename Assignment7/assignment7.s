###########################################################
#  Assignment #: 7
#  Name: Trey Manuszak
#  ASU email: tmanusza@asu.edu
#  Course: CSE230 TTh 6-730pm
#  Description: Get n from user and calculate then print function1(n) defined as 
#               5*n + 14 if n <= 3, function1(n-1)/n + n*function1(n-3) + 4*n else.
###########################################################

        .data
msg1:           .asciiz "Enter an integer: \n"
msg2:           .asciiz "The solution is: "

        .text
        .globl      main        # define a global function main

############################################################################
# Procedure/Function: main
# Description: Get n from user and calculate then print function1(n)
# parameters: 
# $s0 = n
# $s1 = ans
############################################################################
main:
        # get n
        la	$a0, msg1       # $a0 = address of msg1
        li	$v0, 4		# $v0 = 4
        syscall                 # print msg1
        li	$v0, 5      	# $v0 = 5  
        syscall                 # Get n
        addi	$s0, $v0, 0	# $s0 = $v0 + 0

        # call function1
        addi	$sp, $sp, -4	# $sp -= 4
        sw	$ra, 0($sp)	# store $ra in $sp
        jal	function1	# jump to function1 and save position to $ra
        lw	$ra, 0($sp)	# load $ra from $sp
        addi	$sp, $sp, 4	# $sp = $sp + 4
        
        # print ans
        la	$a0, msg2	# $a0 = base address of msg2
        li	$v0, 4		# $v0 = 4
        syscall                 # print msg2
        addi	$a0, $s1, 0	# $a0 = $s1 + 0
        li	$v0, 1      	# $v0 = 1
        syscall                 # print ans

        jr	$ra		# jump to $ra

############################################################################
# Procedure/Function function1
# Description: Calculate 5*n + 14 if n <= 3, function1(n-1)/n + n*function1(n-3) + 4*n else
# parameters: 
# $s0 = n
# $s1 = ans
# return value: $s1
############################################################################
function1: 
        # Test if n <= 3
        li	$t0, 4		        # $t0 = 4
        slt     $t1, $s0, $t0           # if n < 4 $t1 = 1, else $t1 = 0
        beq	$t1, $zero, otherwise	# if $t1 == $zero then otherwise

        # ans = 5*n + 14
        li	$t0, 5		        # $t0 = 5
        mult	$s0, $t0	        # $s0 * $t0 = Hi and Lo registers
        mflo	$s1			# copy Lo to $s1
        addi	$s1, $s1, 14		# $s1 = $s1 + 14
        jr	$ra			# jump to $ra
        
############################################################################
# Procedure/Function: otherwise (function1 else case)
# Description: Calculate function1(n-1)/n + n*function1(n-3) + 4*n
# parameters: 
# $s0 = n
# $s1 = ans
# $s2 = function1(n-1)
# $s3 = function1(n-3)
# return value: $s1
############################################################################
otherwise:
        # get function(n-1)
        addi	$sp, $sp, -8	# $sp = $sp + -8
        sw	$ra, 0($sp)	# store $ra
        sw	$s0, 4($sp)	# store n
        addi	$s0, $s0, -1	# $s0 = $s0 + -1
        jal	function1	# jump to function1 and save position to $ra
        lw	$s0, 4($sp)	# load n
        lw	$ra, 0($sp)	# load $ra
        addi	$sp, $sp, 8	# $sp = $sp + 8
        addi	$s2, $s1, 0	# $s2 = function(n-1)

        # get function(n-3)
        addi	$sp, $sp, -12	# $sp = $sp + -12
        sw	$ra, 0($sp)	# store $ra
        sw	$s0, 4($sp)	# store n
        sw	$s2, 8($sp)	# store $s2
        addi	$s0, $s0, -3	# $s0 = $s0 + -3
        jal	function1	# jump to function1 and save position to $ra
        lw      $s2, 8($sp)     # load $s2
        lw	$s0, 4($sp)	# load n
        lw	$ra, 0($sp)	# load $ra
        addi	$sp, $sp, 12	# $sp = $sp + 12
        addi	$s3, $s1, 0	# $s3 = function(n-3)
        
        # ans = function1(n-1)/n + n*function1(n-3) + 4*n
        div	$s2, $s0	# $s2 / $s0
        mflo	$s1		# $s1 = floor($s2 / $s0) 
        mult	$s0, $s3	# $s0 * $s3 = Hi and Lo registers
        mflo	$t0		# copy Lo to $t2
        add	$s1, $s1, $t0	# $s1 = $s1 + $t0
        li	$t0, 4		# $t0 = 4
        mult	$t0, $s0	# $t0 * $s0 = Hi and Lo registers
        mflo	$t0		# copy Lo to $t0
        add	$s1, $s1, $t0	# $s1 = $s1 + $t0

        jr	$ra		# jump to $ra