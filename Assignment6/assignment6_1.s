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
msg4:           .asciiz "Original Array Content:\n"
msg5:           .asciiz "Specify how many times to repeat:\n"
newline:        .asciiz "\n"
numbers:        .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        .text
        .globl      main        # define a global function main

# //The main reads in an array content,
# //then it prints it,
# //then it asks a user how many time to repeat
# //the changeArrayContent operation. 
# void main()
# {
#     int arraysize = 12, length;
#     int numbers[arraysize];
#     int howMany;
#     int i;

#     length = readArray(numbers, arraysize);
#     printf("\nOriginal Array Content:\n");
#     printArray(numbers, arraysize, length);
    
#     printf("Specify how many times to repeat:\n");
#     scanf("%d", &howMany);

#     i=0;
#     while (i < howMany)
#     {
#         changeArrayContent(numbers, arraysize, length);   
#         i++;
#     }

#     return;
# }

# Parameters
# $s0 = arraySize = 12
# $s1 = base address of array
# $s2 = length
# $s3 = howMany
# $t0 = loop counter
main: 
        li      $s0, 12                 # $s0 = arraySize = 12
        la      $s1, numbers            # $s1 = base address of numbers

        # call readArray
        addi    $sp, $sp, -4            # $sp -= 4
        sw		$ra, 0($sp)		        # store $ra
        jal		readArray			    # jump to readArray and save position to $ra
        lw		$ra, 0($sp)		        # load $ra
        addi    $sp, $sp, 4             # $sp += 4

        la      $a0, msg4	            # $a0 = address of msg4
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg4

        # call printArray
        addi    $sp, $sp, -4            # $sp -= 4
        sw		$ra, 0($sp)		        # store $ra
        jal		printArray			    # jump to printArray and save position to $ra
        lw		$ra, 0($sp)		        # load $ra
        addi    $sp, $sp, 4             # $sp += 4

        # get howMany
        la      $a0, msg5	            # $a0 = address of msg5
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg5
        li	    $v0, 5		            # $v0 = 5
        syscall                         # get howMany
        add     $s3, $v0, $zero         # $s3 = howMany
        li      $t0, 0                  # reset loop counter

mainLoop:
        # check i < howMany
        slt     $t1, $t0, $s3           # if i < howMany, $t1 = 1, else $t0 = 0
        beq     $t1, $zero, exitMain    # if $t1 == $zero, exitMain

        # call changeArray
        addi    $sp, $sp, -8            # $sp -= 8
        sw      $ra, 0($sp)             # store $ra
        sw      $t0, 4($sp)             # store loop counter
        jal     changeArray             # jump to changeArray and save position to $ra
        lw      $t0, 4($sp)             # load loop counter
        lw      $ra, 0($sp)             # load $ra
        addi    $sp, $sp, 8             # $sp += 8

        addi    $t0, $t0, 1             # increment loop counter
        j		mainLoop				# jump to mainLoop

exitMain:
        jr      $ra                     # exit program
        
        

# //The changeArrayContent reads in an integer
# //Then it goes through the parameter array, and if an element
# //is divisible by the entered integer, then it multiplies the element
# //by the entered integer.
# void changeArrayContent(int numbers[], int arraysize, int length)
#  {
#      int i;
#      int num1;
     
#      printf("Enter an integer:\n");
     
#      //read an integer from a user input
#      scanf("%d", &num1);
     
     
#      //It goes through each element of array
#      //and change their values if the condition holds
#      i = 0;
#      while (i < arraysize && i < length)
#       {
#           if (numbers[i]%num1 == 0)
#             numbers[i] = numbers[i]*num1;

#           i++;
#       }

#      printf("\nResult Array Content:\n");
#      printArray(numbers, arraysize, length);

#      return;
#  }
# Parameters
# $s0 = arraySize = 12
# $s1 = base address of array
# $s2 = length
# $s4 = divisor
# $t0 = loop counter
changeArray: 
        la      $a0, msg2	                # $a0 = address of msg2
        li	    $v0, 4		                # $v0 = 4
        syscall                             # print msg2
        li	    $v0, 5		                # $v0 = 5
        syscall                             # get divisor
        add     $s4, $v0, $zero             # $s4 = divisor
        li      $t0, 0                      # reset loop counter

changeArrayLoop:
        # while i < arraySize && i < length check
        slt     $t1, $t0, $s0               # if i < arraySize, $t1 = 1, else $t0 = 0
        beq		$t1, $zero, exitChangeArray # if $t0 == $zero then exitChangeArray
        slt     $t1, $t0, $s2               # if i < length, $t1 = 1, else $t0 = 0
        beq     $t1, $zero, exitChangeArray # if $t0 == $zero then exitChangeArray

        # check numbers[$t0] % divisor == 0
        sll     $t9, $t0, 2                 # $t9 = counter * 4 (address of numbers[counter])
        add     $t8, $t9, $s1               # $t8 = $t9 + $s1 (address of numbers[counter])
        lw	    $a0, 0($t8)                 # load new integer in numbers[counter]
        div		$a0, $s4			        # $a0 / $s4
        mfhi	$t2					        # $t2 = $a0 mod $s4 
        bne		$t2, $zero, incChangeLoop	# if $t2 != $zero then incChangeLoop

        # numbers[$t0] = numbers[$t0]*num1
        mult	$a0, $s4			        # $a0 * $s4 = Hi and Lo registers
        mflo	$a0					        # copy Lo to $a0
        sw      $a0, 0($t8)                 # store numbers[$t0] = numbers[$t0]*num1
        
incChangeLoop:
        addi	$t0, $t0, 1			        # increment loop counter
        j		changeArrayLoop				# jump to changeArrayLoop

exitChangeArray:
        la      $a0, msg3	                # $a0 = address of msg3
        li	    $v0, 4		                # $v0 = 4
        syscall                             # print msg3

        # call printArray
        addi    $sp, $sp, -4                # $sp -= 4
        sw		$ra, 0($sp)		            # store $ra
        jal		printArray			        # jump to printArray and save position to $ra
        lw		$ra, 0($sp)		            # load $ra
        addi    $sp, $sp, 4                 # $sp += 4

        jr		$ra					        # jump to $ra

# //The printArray function prints integers of the array
# void printArray(int array[], int arraysize, int length)
# {
#     int i;

#     i = 0;
#     while (i < arraysize && i < length)
#     {
#         printf("%d\n", array[i]);
#         i++;
#     }
    
#     return;
# }
# Parameters
# $s0 = arraySize = 12
# $s1 = base address of array
# $s2 = length
# $t0 = loop counter
printArray:
        li  $t0, 0                          # Reset loop counter

printArrayLoop:
        # while i < arraySize && i < length check
        slt     $t1, $t0, $s0               # if i < arraySize, $t1 = 1, else $t0 = 0
        beq		$t1, $zero, exitPrintArray  # if $t0 == $zero then exitPrintArray
        slt     $t1, $t0, $s2               # if i < length, $t1 = 1, else $t0 = 0
        beq     $t1, $zero, exitPrintArray  # if $t0 == $zero then exitPrintArray
        sll     $t9, $t0, 2                 # $t9 = counter * 4 (address of numbers[counter])
        add     $t8, $t9, $s1               # $t8 = $t9 + $s1 (address of numbers[counter])
        lw	    $a0, 0($t8)                 # load new integer in numbers[counter]
        li      $v0, 1                      # $v0 = 1
        syscall                             # print numbers[counter]
        la      $a0, newline                # $a0 = address of newline
        li	    $v0, 4		                # $v0 = 4
        syscall                             # print newline
        addi    $t0, $t0, 1                 # increment loop counter
        j		printArrayLoop				# jump to printArrayLoop

exitPrintArray:
        jr		$ra					        # jump to $ra

# int readArray(int array[], int arraysize)
# {
#     int num, i = 0;
#     int length;
    
#     printf("Specify how many numbers should be stored in the array (at most 11):\n");
#     scanf("%d", &length);

#     while (i < arraysize && i < length)
#     {
#         printf("Enter an integer: \n");

#         //read an integer from a user input and store it in num1
#         scanf("%d", &num);
#         array[i] = num;

#         i++;
#     }

#     return length;
# }
# Parameters
# $s0 = arraySize = 12
# $s1 = base address of array
# $s2 = length
# $s3 = how many times to repeat change
# $t0 = loop counter 
readArray:
        la      $a0, msg1	                # $a0 = address of msg1
        li	    $v0, 4		                # $v0 = 4
        syscall                             # print msg1
        li	    $v0, 5		                # $v0 = 5
        syscall                             # get length
        add	    $s2, $v0, 0	                # $s2 = $v0 + 0 ($s2 = length)

readArrayLoop:
        # while i < arraySize && i < length check
        slt     $t1, $t0, $s0               # if i < arraySize, $t1 = 1, else $t0 = 0
        beq		$t1, $zero, exitReadArray   # if $t0 == $zero then exitReadArray
        slt     $t1, $t0, $s2               # if i < length, $t1 = 1, else $t0 = 0
        beq     $t1, $zero, exitReadArray   # if $t0 == $zero then exitReadArray
        la      $a0, msg2	                # $a0 = address of msg2
        li	    $v0, 4		                # $v0 = 4
        syscall                             # print msg2
        li	    $v0, 5		                # $v0 = 5
        syscall                             # get num
        sll     $t9, $t0, 2                 # $t9 = counter * 4 (address of numbers[counter])
        add     $t8, $t9, $s1               # $t8 = $t9 + $s1 (address of numbers[counter])
        sw	    $v0, 0($t8)                 # store new integer in numbers[counter]
        addi    $t0, $t0, 1                 # increment loop counter
        j		readArrayLoop				# jump to readArrayLoop
        
exitReadArray:
        jr		$ra					        # jump to $ra
        
        
