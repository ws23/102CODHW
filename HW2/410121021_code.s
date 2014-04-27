# 資工二 410121021 林育慈

	.data
inputMsg: 
	.asciiz "Enter the integer values to sorting. (0 to terminate input): \n" # the message that show at screen before user type in

outputMsg: 
	.asciiz "The sorted sequence is: \n" #the message that show at screen before showing the sorted sequence

comma: 
	.asciiz " " # white-space to seperate the integer in sequence

newline: 
	.asciiz "\n"

	.text

	.globl main
main: 
	move $s0, $gp #get the initiall pointer to save array
	addi $t0, $zero, 1 # set $t0 = 1

	add $t1, $zero, $zero # initialization
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	add $t5, $zero, $zero
	add $t6, $zero, $zero

	li $v0, 4 # set the system code: 4(print_string)
	la $a0, inputMsg # set the argument of print_string system call
	syscall
	add $s1, $s0, $zero # set $s1 to point to the address of $s0

enterValues:
	li $v0, 5 # set the system call code: 5(read_int)
	syscall
	beq $v0, $zero, bubbleSort # if $v0=0 jump to bubbleSort tag
	sb $v0, 0($s1) # store byte from register $s1 to memory $v0
	addi $s1, $s1, 1 # set the pointer $s1 to the next address from origin
	add $t5, $s1, $zero 
	j enterValues # loop the enterValues action

bubbleSort: # first layer of loop 
	beq $t5, $zero, exit # if no input, exit the program
	add $t4, $s0, $zero # set $t4 = the first point of array
	addi $t6, $zero, 1 # set $t6 = 0
	sub $s1, $s1, $t0 # let the pointer $s1 to point to prefix element
	beq $s1, $s0, end # if $s1, $s0 are the same, it means the sequence has completed the calculation
	add $s2, $s0, $zero # set $s2 pointer initial as $s0 (use at loopElement)

loopElements: # second layer of loop
	lb $t1, 0($s2) # load $s2 into $t1
	lb $t2, 1($s2) # load $s2+1 into $t2
	slt $t3, $t2, $t1 # compare $t1, $t2
	beq $t3, $zero, tail # if $t1<$t2 goto tail tag
	sb $t2, 0($s2) # store $t2 into $s2+1
	sb $t1, 1($s2) # store $t1 into $s2 // means swap

tail:
	addi $s2, $s2, 1 # $s2++ // prepare to compare next element
	bne $s2, $s1, loopElements # to do the loopElements until $s1 = $s2
	jal bubbleSort # end the second layer of loop 

end: 
	li $v0, 4 # set the system call code: 4(print_string)
	la $a0, outputMsg # set the argument of print_string system call
	syscall

show:
	li $v0, 1 # set the system call code: 1(print_integer)
	lb $a0, 0($t4) # set the argument of print_integer system call
	syscall
	li $v0, 4 #set the system call code: 4(print_string)
	la $a0, comma # set the argument of printf_string system call to seperate the element
	syscall
	addi $t4, $t4, 1 # $t4++ // means to get the next pointer of the array
	bne $t4, $t5, show # if $t4 != $t5 means it doesn't get the final element of the sequence, so loop the show 
	li $v0, 4 # set the system call code: 4(print_string)
	la $a0, newline # set the argument of print_string system call to have new line
	syscall
	syscall
	jal main # jump to the main, loop this program 

exit: 
	li $v0, 10 # set the system call code: 10(exit)
	syscall
