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
msg4:           .asciiz "Original Array Content:"
msg5:           .asciiz "\nSpecify how many times to repeat:\n"
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
        li      $s0, 12             # $s0 = arraySize = 12
        la      $s1, numbers        # $s1 = base address of numbers
        addi    $sp, $sp, -4        # $sp -= 4
        sw		$ra, 0($sp)		    # store $ra
        jal		readArray			# jump to readArray and save position to $ra
        lw		$ra, 0($sp)		    # load $ra
        addi    $sp, $sp, 4         # $sp += 4
        
        

        # Get number of ints to be stored in numbers
        la      $a0, msg1	        # $a0 = address of msg1
        li	    $v0, 4		        # $v0 = 4
        syscall                     # print msg1
        li	    $v0, 5		        # $v0 = 5
        syscall                     # get numbersSize
        add	    $s0, $v0, 0	        # $s0 = $v0 + 0 ($s0 = numbersSize)

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
changeArrayContent: 

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
printArray:

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
        #while i < arraySize && i < length check
        slt     $t1, $t0, $s0               # if i < arraySize, $t1 = 1, else $t0 = 0
        beq		$t1, $zero, exitReadArray   # if $t0 == $zero then exitReadArray
        slt     $t1, $t0, $s2               # # if i < length, $t1 = 1, else $t0 = 0
        beq     $t1, $zero, exitReadArray   # if $t0 == $zero then exitReadArray
        la      $a0, msg2	                # $a0 = address of msg2
        li	    $v0, 4		                # $v0 = 4
        syscall                             # print msg2
        li	    $v0, 5		                # $v0 = 5
        syscall                             # get num
        sll     $t9, $t0, 2                 # $t8 = counter * 4 (address of numbers[counter])
        add     $t8, $t9, $s1               # $t8 = $t8 + $s1 (address of numbers[counter])
        lw	    $a0, 0($t8)                 # load new integer in numbers[counter]
        addi    $t0, $t0, 1                 # increment loop counter
        j		readArrayLoop				# jump to readArrayLoop
        
exitReadArray:
        jr		$ra					        # jump to $ra
        
        
