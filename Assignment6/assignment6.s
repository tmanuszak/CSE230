###########################################################
# Assignment #: 6
#  Name: Trey Manuszak
#  ASU email: tmanusza@asu.edu
#  Course: CSE230 TTh 6-730pm
#  Description: 
###########################################################

msg1:       .asciiz "Specify how many numbers should be stored in the array (at most 11):\n"
msg2:       .asciiz "Enter an integer: \n"
msg3:       .asciiz "\nResult Array Content:\n"
msg4:       .asciiz "\nOriginal Array Content:\n"
msg5:       .asciiz "Specify how many times to repeat:\n"
numbers:    .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# We will unofficially declare the following variables
# $s0 = numbersSize (How many numbers the user wants to input)
# $t9 = counter for looping
# $s1 = base address of numbers
# $s2 = times to repeat
# $s3 = divisor

            .globl      main        # define a global function main


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



# The main reads in an array content,
# then it prints it,
# then it asks a user how many time to repeat
# the changeArrayContent operation. 
main: 
        la      $s1, numbers            # $s1 = base address of numbers

        # Get number of ints to be stored in numbers
        la	    $a0, msg1	            # $a0 = address of msg1
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg1
        li	    $v0, 5		            # $v0 = 5
        syscall                         # get numbersSize
        add	    $s0, $v0, 0	            # $s0 = $v0 + 0 ($s0 = numbersSize)
        li      $t9, 0                  # counter = 0

# Loop to fill numbers with user input
fillArrayLoop:
        slt     $t0, $t9, $s0           # $t0 = 1 if counter < numberSize, else $t0 = 0
        beq     $t0, $zero, countinue   # if $t0 = 0, continue

        # Get int from user
        la	    $a0, msg2	            # $a0 = address of msg2
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg2
        li	    $v0, 5		            # $v0 = 5
        syscall                         # get int
        sll     $t8, $t9, 2             # $t8 = counter * 4 
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        sw		$v0, 0($t8)             # store new integer in numbers[counter]
        addi	$t9, $t9, 1			    # $t9 = $t9 + 1 (increment counter)
        j		fillArrayLoop			# jump to fillArrayLoop

continue:
        li		$t9, 0		            # $t9 = 0 (reset counter)
        la	    $a0, msg4	            # $a0 = address of msg4
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg4

        # Loop to print original numbers array
printOriginal:
        slt     $t0, $t9, $s0           # $t0 = 1 if counter < numberSize, else $t0 = 0
        beq     $t0, $zero, continue1   # if $t0 = 0, continue1
        sll     $t8, $t9, 2             # $t8 = counter * 4 (address of numbers[counter])
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        lw		$a0, 0($t8)             # load new integer in numbers[counter]
        li      $v0, 1                  # $v0 = 1
        syscall                         # print numbers[counter]
        addi	$t9, $t9, 1			    # $t9 = $t9 + 1 (increment array counter)
        j		printOriginal			# jump to printOriginal

        # ask user how many times to change array
continue1:
        la	    $a0, msg5	            # $a0 = address of msg5
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg5
        li	    $v0, 5		            # $v0 = 5
        syscall                         # get times to repeat
        add	    $s2, $v0, 0	            # $s2 = $v0 + 0 ($s0 = times to repeat)
        li      $t7, -1                  # set repeat counter

        # Loop to get the divisor to check the numbers array with
getDivisor:
        addi	$t7, $t7, 1			    # $t7 = $t7 + 1
        slt     $t0, $t7, $s2           # $t0 = 1 if counter < times to repeat, else $t0 = 0
        beq     $t0, $zero, exit        # if $t0 = 0, exit
        la	    $a0, msg2	            # $a0 = address of msg2
        li	    $v0, 4		            # $v0 = 4
        syscall                         # print msg2
        li	    $v0, 5		            # $v0 = 5
        syscall                         # get divisor
        add	    $s3, $v0, 0	            # $s3 = $v0 + 0 ($s3 = divisor)
        li      $t9, -1                 # reset array counter

        # check if numbers[counter]
changeArray:
        addi    $t9, 1                  # increment array counter
        slt     $t0, $t9, $s0           # $t0 = 1 if counter < numberSize, else $t0 = 0
        beq     $t0, $zero, getDivisor  # if $t0 = 0, getDivisor
        sll     $t8, $t9, 2             # $t8 = counter * 4 (address of numbers[counter])
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        lw		$a0, 0($t8)             # load integer in numbers[counter]
        div		$a0, $s3			    # $a0 / $s3
        mfhi    $a1
        bne		$a1, $zero, changeArray	# if $a1 != $zero then changeArray
        # numbers[counter] = numbers[counter] * divisor
        mult	$a0, $s3			    # $a0 * $s3 = Hi and Lo registers
        mflo	$a0					    # copy Lo to $a0
        sll     $t8, $t9, 2             # $t8 = counter * 4 
        add     $t8, $t8, $s1           # $t8 = $t8 + $s1 (address of numbers[counter])
        sw		$v0, 0($t8)             # store new integer in numbers[counter]
        
        

exit:
        jr		$ra					    # jump to $ra
        




        
        

