.text

init_student:

	li $t0 0 # initilizing this variable for storing the record
	
	sll $t0 $a0 10 #shifted left by 10 bits to align

	or $t0 $t0 $a1 #doing or with credits to get correct bits and not shift required

	sw $t0 0($a3) #storing word in our record

	sw $a2 4($a3) #storing the rest in by pointer

	jr $ra
	
print_student:
	lw $t0 0($a3) # loading first 32bits of a3

	srl $t1 $t0 10 # shifting right and droping bits to store id

	sll $t0 $t0 22 # shifting left to drop left bits and get credits 

	srl $t0 $t0 22 # shifting right to get the ID

	lw $t2 4($a3) # getting pointer to name

	move $a0 $t1 #printing ID
	li $v0 1
	syscall

	li $a0 ' ' #printing space
	li $v0 11
	syscall	

	move $a0 $t0 #printing credits
	li $v0 1
	syscall

	li $a0 ' ' #printing space
	li $v0 11
	syscall

	move $a0 $t2 #printing name
	li $v0 4
	syscall

	jr $ra
	
init_student_array:
	jr $ra
	
insert:
	jr $ra
	
search:
	jr $ra

delete:
	jr $ra
