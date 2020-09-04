###########################################################
# Assignment #: 4
#  Name: Trey Manuszak
#  ASU email: tmanusza@asu.edu
#  Course: CSE230 TTh 6-730pm
#  Description: This program asks the user for KWH usage then calculates the power bill.
###########################################################

# data declarations
        .data
msg1:   .asciiz     "Please enter the new electricity meter reading:\n"
msg2:   .asciiz     "Please enter the old electricity meter reading:\n"
msg3:   .asciiz     "Please enter a month to compute their electricity bill,\nUse an integer between 1 and 12 (1 for January, etc.):\n"
msg4:   .asciiz     "Your total bill amount for this month: "
msg5:   .asciiz     " dollar(s) for "
msg6:   .asciiz     " KWH\n"
msg7:   .asciiz     "No bill to pay this month.\n"

# We will unofficially declare the following registers as
# $s0 = newMeter
# $s1 = oldMeter
# $s2 = KWHforMonth
# $s3 = month
# $s4 = billAmount

# int newMeter;
# int oldMeter;
# int KWHforMonth;
# int month;
# int billAmount;

# printf("Please enter the new electricity meter reading:\n");

# //read an integer from a user input and store it in newMeter
# scanf("%d", &newMeter);

# printf("Please enter the old electricity meter reading:\n");

# //read an integer from a user input and store it in oldMeter
# scanf("%d", &oldMeter);

# printf("Please enter a month to compute their electricity bill,\n");
# printf("Use an integer between 1 and 12 (1 for January, etc.):\n");

# //read an integer from a user input and store it in month
# scanf("%d", &month);

# KWHforMonth = newMeter - oldMeter;

# if (KWHforMonth <= 0)
#  {
#    printf("No bill to pay this month.\n");
#  }
# else
#  {
#     //compute its bill 
#     if (KWHforMonth <= 250)
#      {
#        billAmount = 25;
#      }
#     else if (KWHforMonth > 250 && month >= 6 && month <= 9)
#      {
#        billAmount = (KWHforMonth-250)/18 + 25;
#      }
#     else
#      {
#        billAmount = (KWHforMonth-250)/20 + 25;
#      }

#     //print out the billAmount
#     printf("Your total bill amount for this month: %d dollar(s) for %d KWH\n", billAmount,    KWHforMonth);

#   } //end of else

        .text
        .globl      main        # define a global function main

# the program begins execution at main()
main: 

        #Get new meter reading
        la	$a0, msg1	        # $a0 = address of msg1
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg1
        li	$v0, 5		        # $v0 = 5
        syscall                         # get newMeter
        add	$s0, $v0, 0	        # $s0 = $v0 + 0 ($s0 = newMeter)

        # Get old meter reading
        la	$a0, msg2	        # $a0 = address of msg2
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg2
        li	$v0, 5		        # $v0 = 5
        syscall                         # get oldMeter
        add	$s1, $v0, 0	        # $s1 = $v0 + 0 ($s1 = oldMeter)

        # Get month
        la	$a0, msg3	        # $a0 = address of msg3
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg3
        li	$v0, 5		        # $v0 = 5
        syscall                         # get month
        add	$s3, $v0, 0	        # $s3 = $v0 + 0 ($s3 = month)

        #Calculate KWHforMonth
        sub	$s2, $s0, $s1		# $s2 = $s0 - $s1 (KWHforMonth = newMeter - oldMeter)

        #Check if KWHforMonth <= 0
        slt     $t0, $zero, $s2         #if KWHforMonth < 0: $t0 = 1, ekse 0
        bne	$t0, $zero, continue0	# if $t0 = $zero then continue
        # do if KWHforMonth < 0
        la	$a0, msg7	        # $a0 = address of msg7
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg7
        jr	$ra		        # jump to $ra

continue0:
        addi	$t0, $zero, 250		# $t0 = $zero + 250
        slt     $t1, $t0, $s2           # if 250 < KWHforMonth: $t1 = 1, else 0
        bne     $t1, $zero, continue1   # if $t1 != $zero then continue1
        # do if KWHforMonth <= 250
        addi    $s4, $zero, 25          # billAmount = 25
        j	exitprint		# jump to exitprint

continue1:        
        addi    $t0, $zero, 6           # $t0 = 6
        slt     $t1, $s3, $t0           # if month < 6: $t1 = 1, else 0
        beq     $t1, $zero, continue2   # if $t1 = $zero then continue2
        # set billAmount = (KWHforMonth-250)/20 + 25;
        addi    $s4, $s2, -250          # billAmount = KWHforMonth - 250
        addi    $t1, $zero, 20          # t1 = 20
        div	$s4, $t1		# $s4 / $t1
        mflo	$s4			# billAmount = floor($s4 / $t1)
        addi    $s4, $s4, 25            # billAmount += 25
        j	exitprint		# jump to exitprint

continue2: 
        addi    $t0, $zero, 9           # $t0 = 6
        slt     $t1, $t0, $s3           # if 9 < month: $t1 = 1, else 0
        beq     $t1, $zero, continue3   # if $t1 = $zero then continue3
        # set billAmount = (KWHforMonth-250)/20 + 25;
        addi    $s4, $s2, -250          # billAmount = KWHforMonth - 250
        addi    $t1, $zero, 20          # t1 = 20
        div	$s4, $t1	        # $s4 / $t1
        mflo	$s4			# billAmount = floor($s4 / $t1)
        addi    $s4, $s4, 25            # billAmount += 25
        j	exitprint		# jump to exitprint

continue3: 
        # set billAmount = (KWHforMonth-250)/18 + 25;
        addi    $s4, $s2, -250          # billAmount = KWHforMonth - 250
        addi    $t1, $zero, 18          # t1 = 18
        div	$s4, $t1		# $s4 / $t1
        mflo	$s4			# billAmount = floor($s4 / $t1)
        addi    $s4, $s4, 25            # billAmount += 25
        j	exitprint		# jump to exitprint

exitprint:
        la	$a0, msg4	        # $a0 = address of msg4
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg4
        li	$v0, 1		        # $v0 = 1
        add	$a0, $s4, 0	        # $a0 = $s4 + 0
        syscall                         # print billAmount
        la	$a0, msg5	        # $a0 = address of msg5
        li	$v0, 4		        # $v0 = 4
        syscall                         # print msg5
        li	$v0, 1		        # $v0 = 1
        add	$a0, $s2, 0	        # $a0 = $s4 + 0
        syscall                         # print KWHforMonth
        la	$a0, msg6	        # $a0 = address of msg6
        li	$v0, 4		        # $v0 = 1
        syscall                         # print msg6
        jr      $ra                     # jump to $ra


        
        