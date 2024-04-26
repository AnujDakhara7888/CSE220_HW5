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
	
	move $t5 $a3 # loading the name
	
	addi $sp, $sp, -4 # making a stack before calling
	
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
     	
    	lw $t0, 0($a0)                # Load the first 32 bits of the student record
    	srl $t0, $t0, 10              # Extract the student ID (shift right by 10 bits)
    	
    	move $t1, $a1                 # Copy the hash table base address
    	
    	move $t2 $a2 		       # Getting the table size
    	
    	divu $t0 $t2 # dividng to do linear probing
    	mfhi $t3 # storing number after modulo in t4
    	
    	li $t4 0 # traversel for probing
    	
    	loop:
    		bge $t4 $t2 out # getting out if exceeded basically when my $t4 goes out
    		
    		lw $t5 0($t1) # getting the id of that position
    		
    		srl $t5 $t5 10 # right shift to set proper
    		
    		beq $t4 $t3 got # once I get the hash table ID it means I can check now
    		
    		addi $t4 $t4 1 # continue the loop
    		
    		addi $t1 $t1 4 # adding by 8 to reach next hash tble element
    		
    		j loop
    		
    	got:
    		beqz $t5 canPlace # if hash table id 0 then canPlace
    		li $t6 -1
    		beq $t5 $t6 canPlace # if hash table id null then canPlace

    		li $t7 1 # counter number of values now stored
    		
    		addi $t4 $t4 1 # continue the loopAgain
    		
    		addi $t1 $t1 4 # adding by 4 to reach next hash tble element
    		
    		
    		loopAgain:
    			bge $t7 $t2 out # going our if count becomes equal to table size
    			
    			lw $t5 0($t1) # getting the id of that position
    			
    			beqz $t5 canPlace # if hash table id 0 then canPlace
    			li $t6 -1
    			beq $t5 $t6 canPlace # if hash table id null then canPlace
    		
    			addi $t1 $t1 4 # adding by 4 to reach next hash tble element
    			addi $t7 $t7 1 # adding by 1 to reach new counter counting elements we checked
    			addi $t4 $t4 1 # adding by 1 to reach next hash tble elementprevious counter for seeing if we reach end of loop
    			beq $t4 $t2 do # calling function again to ste values again
    			
    		j loopAgain
    		
    	
    		
    	do:
    		beq $t7 $t2 out
    		
    		#addi $t4 $t4 1 # continue the loopAgain
    		
    		#addi $t2 $t2 4 # adding by 4 to reach next hash tble element
    			
    		move $t1, $a1 # Copy the hash table base address
    			
    		li $t4 0 # mking varibale 0 again
    		
    		j loopAgain
    		
    			  		
    	canPlace:
    		sw $a0 0($t1) # storing in hash
    		j correct
    	
    	correct:
    		move $v0 $t4 # moving to set v0 to return the index
    		jr $ra
    	out:
    		li $v0 -1 # nothing could be laced hence -1
    		jr $ra
	
    	
	
search:
	move $t0 $a0 # loading the studnet ID
	
	move $t1 $a1 # loading the hash table address
	
	move $t2 $a2 # setting table size
	
	divu $t0 $t2 # dividing to do linear probing
	
    	mfhi $t5 # storing number after modulo in t2
	
	li $t3 0 # setting for traversal
	
	whileLoop:
		bge $t3 $t2 loopOut # means whole table size if complete go out
    		
    		beq $t3 $t5 found # means we found particular element
    		
    		addi $t3 $t3 1 # moving by 1 our counter
    		
    		addi $t1 $t1 4 #adding by 4 to move the table as well
    		 
    		j whileLoop
    		
    	found:
    		lw $t4 0($t1) # getting the value of that position
    		li $t7 -1
    		beq $t4 $t7 skip
    		beqz $t4 loopOut
    		lw $t4 0($t4) # loading t4
    		
    		srl $t4 $t4 10 # right shift to set proper
    		
    		beq $t4 $t0 proper # same ID at same position which means correct
    		
    		skip: 
    		
    		addi $t3 $t3 1 # moving by 1 our counter
    		
    		addi $t1 $t1 4 #adding by 4 to move the table as well
    		 
    		li $t6 1 # counter number of values now stored
    		
    		loopOneMore:
    			li $t7 -1
    			
    			bge $t6 $t2 loopOut # going our if count becomes equal to table size
    			lw $t4 0($t1) # getting the id of that position
    			beqz $t4 loopOut
    			beq $t4 $t7 moving
    			
    			lw $t4 0($t4) # loading t4
    		
    			srl $t4 $t4 10 # right shift to set proper
    			
    			beq $t4 $t0 proper # same ID at same position which means correct 
    			
    			moving:
    			addi $t1 $t1 4 # adding by 4 to reach next hash tble element
    			addi $t6 $t6 1 # adding by 1 to reach new counter counting elements we checked
    			addi $t3 $t3 1 # adding by 1 to reach next hash tble elementprevious counter for seeing if we reach end of loop
    			beq $t3 $t2 onceMore # calling function again to ste values again
    			j loopOneMore
    		
    		
    		
    	onceMore:
    		bge $t6 $t2 loopOut
    			
    		move $t1, $a1 # Copy the hash table base address
    			
    		li $t3 0 # making varibale 0 again
    		
    		j loopOneMore
    	
    	
    	proper:
    		lw $v0 0($t1) # loading that address
    		move $v1 $t3 # loading that element index
    		jr $ra
    		
    	loopOut:
    		li $v0 0
    		li $v1 -1
    		
    		jr $ra

delete:
	jr $ra
