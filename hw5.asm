.text

init_student:

	li $t8 0 # initilizing this variable for storing the record
	
	sll $t8 $a0 10 #shifted left by 10 bits to align

	or $t8 $t8 $a1 #doing or with credits to get correct bits and not shift required

	sw $t8 0($a3) #storing word in our record

	sw $a2 4($a3) #storing the rest in by pointer

	jr $ra
	
print_student:
	lw $t0 0($a0) # loading first 32bits of a3

	srl $t1 $t0 10 # shifting right and droping bits to store id

	sll $t0 $t0 22 # shifting left to drop left bits and get credits 

	srl $t0 $t0 22 # shifting right to get the ID

	lw $t2 4($a0) # getting pointer to name

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
	
	move $t0 $a0 # loading the length of student for traversing the array
	
	li $t1 0 # using as and i for traversing
	
	move $t2 $a1 # loading address of id and storing in temp
	
	move $t3 $a2 # loading address of credit and storing in temp

	lw $t6 0($sp) # storing the record in a variable
	
	addi $sp, $sp, -4 # making a stack before calling
	
	move $t5 $a3 # loading the name
	
	sw $ra 0($sp)
	
	while: # loop for traversing the student list id and credits
	
		bge $t1 $t0 end # if counter is greater than number we come out and go in end
		
		lw $a0 0($t2) # got the element in idList storing in a0 to pass to init student
		
		lw $a1 0($t3) # got the element in credits in a1 to pass to init student
			
		move $a2 $t5
		move $a3 $t6
		
		jal init_student # jumping to init_student
		
		addi $t2 $t2 4 # moved t2 to next int so that we get next studentID
		addi $t3 $t3 4 # moved t3 to next int so that we get next credit
		addi $t6 $t6 8  # moved t6 to next pointer in the record
		addi $t1 $t1 1 # increasing counter
		
		name_loop:
			lbu $t7, 0($t5)  # Load byte at current position
			beqz $t7, update_name_pointer  # If null terminator go to update update pointer
			addi $t5, $t5, 1  # Increment name pointer
			j name_loop       # Continue loop
		update_name_pointer:
			addi $t5, $t5, 1  # Move past null terminator
		
		j while # go to while again
	end:
		lw $ra 0($sp) # storing back the stack
		addi $sp, $sp, 4
		jr $ra		
	
insert:
	jr $ra
	
search:
	jr $ra

delete:
	jr $ra
