##############################################################
# Homework #4
# name: Weifeng Lin
# sbuid: 110161112
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

preorder:
    #Define your code here
    	addi $sp, $sp, -16
    	sw $ra, 0($sp)
    	sw $a0, 4($sp)	# current node address
    	sw $a1, 8($sp)	# base address of array of nodes
    	sw $a2, 12($sp)  # File descriptor
    	
    	lb $t0, 0($a0)
    	lb $t1, 1($a0)
    	
    	sll $t1, $t1, 8
    	or $t0, $t0, $t1
    	
    	
    	move $a0, $t0
    	lw $t1, 12($sp)
    	move $a1, $t1
    	
    	jal itof
    	
    	
	la $t1, newline
    	lw $t2, 12($sp)
    	
    	move $a0, $t2
    	move $a1, $t1
    	li $a2, 1
    	jal write
    	
    	li $t0, 0 # left node Index
    	li $t1, 0 # right node index
    	
    	lw $t0, 4($sp) #current node
    	lbu $t0, 3($t0) # left node index
    	
    	bne $t0, 255, tra_left
    	j do_right
      
    	
    	tra_left:
    		lw $t0, 4($sp) #current node
    		lbu $t0, 3($t0) # left node index
    		sll $t1, $t0, 2 # leftNodeIndex*4
    		lw $t0, 8($sp)
    		add $a0, $t0, $t1
    		move $a1, $t0
    		lw $a2, 12($sp)
    		jal preorder
    		
    	
    	do_right:
    	lw $t1, 4($sp) #current node
    	lbu $t1, 2($t1) # left node index 
    	
    	bne $t1, 255, tra_right
    	j preo_end
    	
    	tra_right:
    		lw $t1, 4($sp) #current node
    		lbu $t1, 2($t1) # right node index 
    		sll $t0, $t1, 2 # rightNodeIndex*4
    		lw $t1, 8($sp)
    		add $a0, $t0, $t1
    		move $a1, $t1
    		lw $a2, 12($sp)
    		jal preorder  	
    	
    	
    	preo_end:
    	lw $ra, 0($sp)
    	lw $a0, 4($sp)
    	lw $a1, 8($sp)
    	lw $a2, 12($sp)
    	addi $sp, $sp, 16
	jr $ra


itof:
	# a0 = node value , a1 = file descriptor
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	
	
	
	#sw $a0, node_value
	
	move $s0, $a1
	
	bgez $a0, positive
	li $a1, 0
	j do_con
	
	positive:
	li $a1, 1
	
	do_con:
	jal int_to_string # convert the node value to string and stored to node_value. return the length of node value.
	
	la $a1, node_value # address of nodeValue
	
	move $a0, $s0 # file descriptor
	  
	
	#move $a2, $v0
	li $a2, 20
	
	li $v0, 15
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

	
int_to_string:
	#a0 = int. v0 = length of string
	#a1 = 0 if the value is negative
	
	
	la $t0, node_value
	
	# clear node_value
	li $t1, 0
	move $t5, $a0
	
	clear:
		beq $t1, 20, clear_done
		sb $0, ($t0)
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		j clear
	clear_done:
	
	#la $t0, node_value
	addi $t0, $t0, -1
	bnez $a1, keep_conv
	# li $t1, 45
	# sb $t1, 0($t0)
	# addi $t0, $t0, -1
	# convert s0 to positive
	neg $t5, $t5
	#addi $t5, $t5, 1
	
	
	keep_conv:
	li $t1, 0
	li $t2, 10
	move $t3, $t5
	li $v0, 0
	
	convert:
		beqz $t3, conv_done
		div $t3, $t2
		addi $v0, $v0, 1
		mfhi $t4
		addi $t4, $t4, 48
		sb $t4, 0($t0)
		addi $t0, $t0, -1
		mflo $t3
		j convert
	conv_done:
	bnez $a1, to_string_done
	li $t1, 45
	sb $t1, ($t0)	
	#la $t0, node_value
		
	to_string_done:
	jr $ra
		
		

write:
	# a0 = file descriptor
	# a1 = address of char to write
	# a2 = max # of char to write
	
	li $v0, 15
	
	syscall

	jr $ra
	

##############################
# PART 2 FUNCTIONS
##############################

linear_search:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -10
    ###########################################
    # a0 = byte[] flags; a1 = int maxSize
    
    move $s0, $a0, #address of base flag array
    
    li $s1, 0  #index counter
    li $s2, 0  # count the amount of 0 bit
    li $s3, 8  # indicates new byte needed. 
    
     
    trav:
    
    beq $s1, $a1, trav_done
    beq $s1, $s3, next_byte
    lb  $t0, 0($s0)

    	# current byte  
    current_byte:
    beq $s1, $a1, trav_done
    andi $t1, $t0, 1 # extract the rightmost bit.
    bnez $t1, keep_trav
    	# t1 = 0
    	addi $s2, $s2, 1
    	j trav_done
    keep_trav:
    addi $s1, $s1, 1
    srl $t0, $t0, 1

    bne $s1, $s3, current_byte
    j trav	
    
    next_byte:
    addi $s0, $s0, 1
    addi $s3, $s3, 8	# s3 = s3+8
    j trav
      
    trav_done:
    
    
    bgtz $s2, flag_found
    	# not found
    	li $v0, -1
    	j ls_finish
    flag_found:
    move $v0, $s1
    
    ls_finish:
    jr $ra

set_flag:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -20
    ###########################################
    # a0 = byte[] flags
    # a1 = int index
    # a2 = int setValue
    # a3 = int maxSize.
    # if int index is not in the range of [0, maxSize-1], return 0 meaning fail.
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    
    bgez $a1, legal_index_I
    	# if a1 < 0
    	li $v0, 0
    	j flag_set
    legal_index_I:
    addi $t0, $a3, -1
    ble $a1, $t0, legal_index
     	# if a1 > maxSize-1
     	li $v0, 0
    	j flag_set
    legal_index:
    
    # a1 now is legal index.
    
    move $s0, $a0
    li $s1, 0		#counter
    li $s2, 8		# when to get next byte. will be 8, 16, 24, 32 ...later
    
    looking:
    bge $a1, $s2, target_nextByte
    # now a1 < s2. meaning reaching the byte that index is in.
    # the index in current byte = 8 - (s2- a1).
    sub $t0, $s2, $a1
    li $t1, 8
    sub $t1, $t1, $t0	# t1 = index in current byte.
    
    # get the setValue rightmost bit
    andi $t0, $a2, 1
    
    lb $t2, 0($s0) # current byte. 
    
    # set t0 to the position t1(index), in byte stored in t2.
    
    # shift t0 index's(t1) amount to left
    #addi $t1, $t1, -1
    sllv $t3, $t0, $t1
    or $t4, $t2, $t3
    sb $t4, 0($s0)
    j looking_done
    
    
    target_nextByte:
    addi $s0, $s0, 1
    addi $s2, $s2, 8
    j looking
    
    looking_done:
    li $v0, 1
    
    
    
    
    
    flag_set:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    addi $sp, $sp, 12
    jr $ra

find_position:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -30
    # li $v1, -40
    ###########################################
    # a0 = Node[] nodes
    # a1 = int currIndex
    # a2 = int newValue
    # v0 = the index of parent nodes of the new node
    # v1 = 0 if the new node will be left child. 1 means right child
    
    # convert int newValue to 16bit imm
    addi $sp, $sp, -28
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $s0, 16($sp)
    sw $s1, 20($sp)
    sw $s2, 24($sp)
    
    move $s1, $a0
    
    bltz $a2, value_neg
    li $t0, 65535
    and $s0, $a2, $t0 # 65535 in decimal = 1111 1111 1111 1111 in binary. s0 = newValue
    j imm_cope_done
    value_neg: # when a2 is negative
    ori $s0, $a2, 4294901760 # 4294901760 in decimal = 1111 1111 1111 1111 0000 0000 0000 0000 in binary
    
    imm_cope_done:
    
    
    
    
    # get nodes[currIndex].value
    sll $t0, $a1, 2
    add $s1, $s1, $t0
    
    # lw $t5, ($s1) #test
            
    lb $t1, 0($s1)
    lb $t2, 1($s1)
    
    sll $t2, $t2, 8
    or $t0, $t1, $t2 # t0 = node value
    
    bge $s0, $t0, do_right_node
    # do left node following.(s0(new Value) < t0(currentNodeValue))
    	lbu $t3, 3($s1) # leftIndex
    	bne $t3, 255, recur_call_l
    		# t3 = 255
    		move $v0, $s2
    		li $v1, 0
    		j findp_return
    	recur_call_l:
    		lw $a0, 4($sp)
    		#sll $a1, $t3, 2
    		move $a1, $t3
    		move $s2, $t3
    		move $a2, $s0
    		jal find_position
    		j findp_return
  
    do_right_node:
    	lbu $t4, 2($s1)
    	bne $t4, 255, recur_call_r
    		# t3 = 255
    		move $v0, $s2
    		li $v1, 1
    		j findp_return
    	recur_call_r:
    		lw $a0, 4($sp)
    		#sll $a1, $t4, 2
    		move $a1, $t4
    		move $s2, $t4
    		move $a2, $s0
    		jal find_position
    		j findp_return
    
    
    findp_return:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $s0, 16($sp)
    lw $s1, 20($sp)  
    lw $s2, 24($sp)
    addi $sp, $sp, 28
    jr $ra

add_node:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -50
    ###########################################
    	# a0 = Node[] nodes
    	# a1 = int rootIndex
    	# a2 = int newValue
    	# a3 = int newIndex
    	# 4($sp) = byte[] flags
    	# 0($sp) = int maxSize
    	lw $s0, 4($sp) #  byte[] flags
    	lw $s1, 0($sp) #  int maxSize
    	
    	addi $sp, $sp, -32
    	sw $ra, 0($sp)
    	sw $s0, 4($sp)
    	sw $s1, 8($sp)
    	sw $s2, 12($sp)
    	sw $s3, 16($sp)
    	sw $s4, 20($sp)
    	sw $s5, 24($sp)
    	sw $s6, 28($sp)
    	
    	andi $t0, $a1, 255 # rootIndex //255 in dec = 1111 1111 in binary
    	andi $t1, $a3, 255 # newIndex
    	
    	blt $t0, $s1, passI
    		li $v0, 0
    		j add_return
    	passI:
    	blt $t1, $s1, passII
    		li $v0, 0
    		j add_return
    	passII:
    	
    	move $s3, $t0
    	move $s4, $t1
    	
    	# to signed half word 
    	bltz $a2, newvalue_neg
   	andi $s2, $a2, 65535 # 65535 in decimal = 1111 1111 1111 1111 in binary. s0 = newValue
   	j value_cope_done
    	newvalue_neg: # when a2 is negative
    	ori $s2, $a2, 4294901760 # 4294901760 in decimal = 1111 1111 1111 1111 0000 0000 0000 0000 in binary
    	value_cope_done:
    	# s2 now stores  newValue
    	
    	# dertermine if a root node actually exists at rootIndex
    	# s0 stores flags array base address. a1 stores rootIndex
    	
    	move $t0, $s0
    	li $t1, 0
    	li $t2, 8  # when to do next byte
    	
    	validRoot:
    		bge $a1, $t2, next_flag_byte
    		# the index in current byte = 8 - (t2- a1)
    		sub $t3, $t2, $a1
    		li $t4, 8
    		sub $t4, $t4, $t3
    		
    		lbu $t5,0($t0)
    		srlv $t6, $t5, $t4
    		
    		andi $t7, $t6, 1 # rightmost bit of the byte that rootIndex is in. It means whether root node is existed already.
    		# if t7 = 0, means the position havent been taken-> invaild, 1 otherwise -> valid
    		j valid_done
    		
    		
    		next_flag_byte:
    		addi $t0, $t0, 1
    		addi $t2, $t2, 8
    		j validRoot  
    		  	
    	valid_done:
    	
    	beqz $t7, invalidRoot # if t7 = 0
    		# if t7 = 1-> valid
    		# call find_position. a0 = nodes, a1 = rootIndex, a2 = newValue
    		move $s5, $a1
    		move $s6, $a2
    		
    		# a0 is the same with this function.
    		move $a1, $s3
    		move $a2, $s2
    		
    		jal find_position
    		
    		move $t0, $v0 # parent's node index
    		move $t1, $v1 # 1 means right and 0 means left.
    		
    		move $a1, $s5
    		move $a2, $s6
    		
    		beqz $t1, update_left
    			# update right
    			sll $t5, $t0, 2
    			add $t2, $a0, $t5 # parent's node address
    			sb $s4, 2($t2)  # update right child of parent node. s4 = newIndex
    			j do_next_step
    			    			
    	
    		update_left:
    			sll $t5, $t0, 2
    			add $t2, $a0, $t5
    			sb $s4, 3($t2)	
    		
    		j do_next_step
    	invalidRoot:
    		move $s4, $s3 # s4 = s3 -> newIndex = rootIndex
    	
    	do_next_step:
    	sll $t3, $s4, 2 
    	add $t2, $a0, $t3
    	li $t3, 255
    	#sw $0, 0($t2)
    	sb $t3, 2($t2)
    	sb $t3, 3($t2)
    	# store newValue, which stored in s2
    	move $t4, $s2 
    	sb $t4, 0($t2)
    	srl $t4, $t4, 8
    	sb $t4, 1($t2)
    	#lw $t5, ($t2) # test
    	
    	move $s3, $a0
    	move $s4, $a1
    	move $s5, $a2
    	move $s6, $a3
    	
    	move $a0, $s0
    	move $a1, $a3
    	li $a2, 1
    	move $a3, $s1
    	
    	jal set_flag
    	
    	#test
    	lb $t0, ($s0)
    	lb $t2, 1($s0)

	move $a0, $s3
	move $a1, $s4
	move $a2, $s5
	move $a3, $s6

    	add_return:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	lw $s6, 28($sp)
    	addi $sp, $sp, 32
	jr $ra


##############################
# PART 3 FUNCTIONS
##############################

get_parent:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -60
    # li $v1, -70
    ###########################################
    
    # a0 = Node[] nodes
    # a1 = int currentIndex
    # a2 = int childValue
    # a3 = int childIndex
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $a3, 16($sp)
    sw $s0, 20($sp)
    sw $s1, 24($sp)
    sw $s2, 28($sp)
    
    # to unsigned byte for child index
    andi $s0, $a3, 255 # child Index
    
    # to signed half word for child value    
    bltz $a2, to_signed_neg
    	# this is when a2/ childvalue is positive
    	andi $s1, $a2, 65535   # 65535 in decimal = 1111 1111 1111 1111 in binary.
    	j to_signed_done
    to_signed_neg:	# 4294901760 in decimal = 1111 1111 1111 1111 0000 0000 0000 0000 in binary
    	ori $s1, $a2, 4294901760
    to_signed_done:
    
    sll $t0, $a1, 2 # t0 = currentIndex(a1)*4
    add $s2, $a0, $t0 	# s2 = current Node address
    
    lb $t1, 0($s2)
    lb $t2, 1($s2)
    sll $t2, $t2, 8
    or $t0, $t1, $t2	# t0 = currentNode value
    
    bge $s1, $t0, look_thr_right
    	# if childValue(s1) < current Node value
    	lbu $t1, 3($s2) # leftIndex
    	bne $t1, 255, if_lefti_eqt_childi
    		# if t1(leftIndex) == 255, return -1
    		li $v0, -1
    		j parent_return    		
    	if_lefti_eqt_childi:
    		bne $t1, $s0, return_get_parent_l
    		# if leftIndex(t1) == childIndex(s0), found it!
    		move $v0, $a1
    		li $v1, 0
    		j parent_return    		
    	return_get_parent_l:
    		# a0 doesn't change.
    		move $a1, $t1 # leftIndex
    		move $a2, $s1 # childValue
    		move $a3, $s0    # childIndex	
    		jal get_parent
    		
    		# restore argument registers back
    		lw $a1, 8($sp)
    		lw $a2, 12($sp)
    		lw $a3, 16($sp)
    		j parent_return		    	    	
    look_thr_right:
    	# if childValue >= currentNode Value
    	lbu $t2, 2($s2) #rightIndex
    	bne $t2, 255, if_righti_eqt_childi
    		# if t2(rightIndex) == 255, return -1
    		li $v0, -1
    		j parent_return	
    	if_righti_eqt_childi:    
    		bne $t2, $s0, return_get_parent_r   
    		# if rightIndex(t2) == childIndex(s0), found it!
    		move $v0, $a1
    		li $v1, 1
    		j parent_return	
    	return_get_parent_r: 
    		# a0 doesnt change
    		move $a1, $t2 # rightIndex
    		move $a2, $s1 # childValue
    		move $a3, $s0    # childIndex	
    		jal get_parent
    		
    		# restore argument registers back
    		lw $a1, 8($sp)
    		lw $a2, 12($sp)
    		lw $a3, 16($sp)
    		j parent_return
    
    
    parent_return:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $a3, 16($sp)
    lw $s0, 20($sp)
    lw $s1, 24($sp)
    lw $s2, 28($sp)
    addi $sp, $sp, 32
    jr $ra

find_min:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -80
    # li $v1, -90
    ###########################################
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $s0, 12($sp)
    
    sll $t0, $a1, 2 # t0 = a1*4
    add $s0, $a0, $t0	# s0 = current node address/ nodes[currIndex]
    
    lbu $t0, 3($s0)	# leftIndex
    bne $t0, 255, return_find_min
    	# if t0(leftIndex) == 255, return currIndex, isLeaf(nodes[currIndex]) 
    	move $v0, $a1
    	lbu $t1, 2($s0) #rightIndex
    	
    	bne $t1, 255, not_leaf
    		# if t1(rightIndex) == 255, is leaf, v1 = 1
    		li $v1, 1
    		j find_min_return
    	
    	not_leaf:
    		# if t1(rightIndex) != 255, not leaf v1 = 0
    		li $v1, 0
    		j find_min_return
    
    return_find_min:
    	# a0 doesn't change
    	move $a1, $t0
    	jal find_min
    	j find_min_return
    
    find_min_return:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $s0, 12($sp)
    addi $sp, $sp, 16
    jr $ra

delete_node:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -100
    ###########################################
    # a0 = Node[] nodes
    # a1 = int rootIndex
    # a2 = int deleteIndex
    # a3 = byte[] flags
    # 0($sp) = int maxSize -> s0
    lw $s0, 0($sp) # int maxSize
    
    addi $sp, $sp, -36
    sw $ra, 0($sp)
    sw $s0, 4($sp) # int maxSize
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    
    # to unsigned byte for rootIndex and deleteIndex
    andi $s1, $a1, 255 # rootIndex
    andi $s2, $a2, 255 # deleteIndex
    
    blt $s1, $s0, del_conti_I
    	# if rootIndex(s1) >= maxSize(s0)
    	li $v0, 0
    	j del_return 
    del_conti_I:
    blt $s2, $s0, del_conti
    	# if deleteIndex(s2) >= maxSize(s0)
    	li $v0, 0
    	j del_return
    del_conti:    
    
    move $t3, $a3 # flag array address
    li $t2, 8 # when to read next Byte
    
    #nodeExists(rootIndex) -> a1 -> s1
    node_exits_for_rooti:
    	bge $s1, $t2, rooti_in_nextByte
    	# the index in current byte = 8 - (t2 - s1)
    	sub $t4, $t2, $s1
    	li $t5, 8
    	sub $t5, $t5, $t4
    	
    	lbu $t6, 0($t3)
    	srlv $t7, $t6, $t5
    	
    	andi $t0, $t7, 1 # if t0 = 1, means it's valid.
    	j node_e_rooti_done
    	  
    	rooti_in_nextByte:
    	addi $t3, $t3, 1
    	addi $t2, $t2, 8
    	j node_exits_for_rooti
    
    node_e_rooti_done:
    	
    move $t3, $a3 # flag array address
    li $t2, 8 # when to read next Byte
    
    #nodeExits(deleteIndex) -> a2 -> s2
    node_exits_for_deletei:
    	bge $s2, $t2, deletei_in_nextByte
    	# the index in current byte = 8 - (t2 - s2)
    	sub $t4, $t2, $s2
    	li $t5, 8
    	sub $t5, $t5, $t4
    	
    	lbu $t6, 0($t3)
    	srlv $t7, $t6, $t5
    	
    	andi $t1, $t7, 1 # if t1 = 1, means it's valid.
    	j node_e_deletei_done
    	  
    	deletei_in_nextByte:
    	addi $t3, $t3, 1
    	addi $t2, $t2, 8
    	j node_exits_for_deletei
    
    node_e_deletei_done:
    
    # t1 = boolean validDel; t0 = boolean validRoot/ 1 means valid. 0 means invalid
    
    bnez $t0, rootn_valid
    	# if t0 (validRoot) = 0(false), return 0
    	li $v0, 0
    	j del_return
    rootn_valid:
    
    bnez $t1, del_valid
    	# if t1(validDel) = 0(false), return 0
    	li $v0, 0
    	j del_return
    
    del_valid:
    
    sll $t0, $s2, 2 # t0 = s2(deleteIndex)*4 
    add $s3, $a0, $t0 # s3 = address of node to delete
    
    # check if nodes[deleteIndex] is leaf (leftIndex and rightIndex == 255). 
    # t0 = boolean isLeaf
    lbu $t3, 3($s3) # leftIndex
    lbu $t2, 2($s3) # rightIndex
    
    bne $t3, 255, isleaf_false
    	# t3 = 255, see t2
    	bne $t2, 255, isleaf_false
    	# t3 and t2 are both 255 when reach next line
    	li $t0, 1
    	j isLeafDone
    	
    isleaf_false:
    	li $t0, 0
    	j isLeafDone
    
    isLeafDone:
    
    #t0 stores isLeaf
    bne $t0, 1, hasOnlyOneChild
    	# t0 = 1, isLeaf is true
    	
    	# backup argument registers
    	move $s4, $a0
    	move $s5, $a1
    	move $s6, $a2
    	move $s7, $a3
    	
    	move $a0, $a3
    	move $a1, $s2
    	li $a2, 0
    	move $a3, $s0
    	
    	jal set_flag # remove flag from flags, return 1 if success
    	
    	move $a0, $s4
    	move $a1, $s5
    	move $a2, $s6
    	move $a3, $s7
    	
    	bne $s1, $s2, not_deleted
    		# if (s1 (rootIndex)== s2 (deleteIndex))
    		li $v0, 1 
    		j del_return # root flag already deleted
    	
    	
    	not_deleted:
    	
    	# get the parent of the node to delete
    	# backup argument registers
    	move $s4, $a0
    	move $s5, $a1
    	move $s6, $a2
    	move $s7, $a3
    	
    	# a0 doesn't change
    	lb $t1, 0($s3)
    	lb $t2, 1($s3)
    	sll $t2, $t2, 8
    	or $t0, $t1, $t2 # t0 = nodes[deletedIndex].value
    	
    	move $a1, $s1
    	move $a2, $t0
    	move $a3, $s2
    	
    	jal get_parent # v0= parentIndex, v1 = leftOrRight. 0 means left, 1 for right
    	
    	move $t0, $v0 # parentIndex
    	move $t1, $v1 # leftOrRight
    	
    	move $a0, $s4
    	move $a1, $s5
    	move $a2, $s6
    	move $a3, $s7
    	
    	sll $t2, $t0, 2
    	add $t3, $a0, $t2 # t3 = nodes[parentIndex]
    	
    	bnez $t1, del_rightChild
    		# if t1 = 0, meaning it's left child
    		li $t4, 255
    		sb $t4, 3($t3)
    		j deleteI_done
    	del_rightChild:    	
    		# if t1 = 1, meaning it's right child
    		li $t4, 255
    		sb $t4, 2($t3)
    		j deleteI_done
    		
    	deleteI_done:
    	li $v0, 1
    	j del_return
    	
    	
    	
    	
  
    hasOnlyOneChild: # see if the nodes[deleteIndex] has only one child. store in t1
    lbu $t3, 3($s3) # leftIndex
    lbu $t2, 2($s3) # rightIndex
    
    beq $t3, 255, oneChild_true
    beq $t2, 255, oneChild_true
    	# onechild flase
    	li $t1, 0
    	j hasOneChildDone
    oneChild_true:
    	li $t1, 1 	
    hasOneChildDone:  
    bne $t1, 1, hasTwoChild
    	# hasOnlyOneChild = 1 (true), do following
    	# getchildIndex
    	lbu $t3, 3($s3) # leftIndex
    	beq $t3, 255, hasRightChild
    		# t3 != 255, hasLeftChild
    		lbu $s5, 3($s3)
    		j getChildIndex_done
    	hasRightChild:   
    		# t3 (leftIndex)= 255, doesn't have left child. Since this is when the node has only one child. it has rightchild 
    		lbu $s5, 2($s3)	
    		j getChildIndex_done
    	
    	getChildIndex_done:
    	# s5 = childIndex
    	
    	bne $s1, $s2, del_do_next 
    		# if deleteIndex (s2)== rootIndex(s1)
    		sll $t0, $s5, 2 
    		add $s4, $a0, $t0 # childNode address
    		
    		# overwrite deleteNode's entire contents with childNode's entire contents
    		#move $s3, $s4
    		lw $t0, 0($s4)
    		sw $t0, 0($s3)
    		
    		# remove the flag from the child node's old position since the child node is now the root
    		# backup the argument registers
    		move $s6, $a0
    		move $s7, $a1
    		addi $sp, $sp, -8
    		sw $a2, 0($sp)
    		sw $a3, 4($sp)
    		
    		move $a0, $a3
    		move $a1, $s5
    		li $a2, 0
    		move $a3, $s0
    		jal set_flag
    		
    		# retore the argument registers
    		move $a0, $s6
    		move $a1, $s7
    		lw $a2, 0($sp)
    		lw $a3, 4($sp)
    		addi $sp, $sp, 8
    		
    		li $v0, 1
    		j del_return
    	
    	del_do_next:
    	# get the parent of the node to delete
    	
    	# backup the argument registers
    	move $s6, $a0
    	move $s7, $a1
    	addi $sp, $sp, -8
    	sw $a2, 0($sp)
    	sw $a3, 4($sp)
    	
    	lb $t1, 0($s3)
    	lb $t2, 1($s3)
    	sll $t2, $t2, 8
    	or $t0, $t1, $t2 # t0 = node value
    	
    	#a0 doesn't change
    	move $a1, $s1
    	move $a2, $t0
    	move $a3, $s2
    	
    	jal get_parent
    	# v0 = parentIndex; v1 = leftOrRight
    	move $t0, $v0 # parentIndex
    	move $t1, $v1 # leftOrRight
    	
    	
    	# retore the argument registers
    	move $a0, $s6
    	move $a1, $s7
    	lw $a2, 0($sp)
    	lw $a3, 4($sp)
    	addi $sp, $sp, 8
    	
    	sll $t2, $t0, 2
    	add $t3, $a0, $t2 # t3 = nodes[parentIndex]
    	
    	bnez $t1, cope_right
    		# t1(leftOrRight) = 0, it's left
    		sb $s5, 3($t3) 
    		j cope_leftOrRight_done
    	cope_right:
    		# t1(leftOrRight) = 1, it's right
    		sb $s5, 2($t3)
    		j cope_leftOrRight_done
    	
    	cope_leftOrRight_done:
    	
    	# backup the argument registers
    	move $s6, $a0
    	move $s7, $a1
    	addi $sp, $sp, -8
    	sw $a2, 0($sp)
    	sw $a3, 4($sp)
    	
    	move $a0, $a3
    	move $a1, $a2
    	li $a2, 0
    	move $a3, $s0
    	jal set_flag
    	
    	
    	# retore the argument registers
    	move $a0, $s6
    	move $a1, $s7
    	lw $a2, 0($sp)
    	lw $a3, 4($sp)
    	addi $sp, $sp, 8
    	
    	li $v0, 1
    	j del_return
    
    
    hasTwoChild: # hasOnlyOneChild is flase(=0). 
    	
    	lbu $t0, 2($s3) # t0 = nodes[deleteIndex].right
    	
    	#backup argument register
    	move $s7, $a1
    	
    	move $a1, $t0
    	jal find_min
    	
    	move $s4, $v0 #minIndex
    	move $s5, $v1 #minIsLeaf:  1 is, 0 not
    	
    	#restore argument register
    	move $a1, $s7
    	
    	# get parent of the minimum node of the right substree
    	# backup the argument registers
    	
    	move $s7, $a0
    	addi $sp, $sp, -12
    	sw $a1, 0($sp)
    	sw $a2, 4($sp)
    	sw $a3, 8($sp)
    	
    	sll $t0, $s4, 2
    	add $s6, $a0, $t0  # s6 = nodes[minIndex]
    	
    	lb $t1, 0($s6)
    	lb $t2, 1($s6)
    	sll $t2, $t2, 8
    	or $t0, $t1, $t2 # t0 = nodes[minIndex].value
    	
    	# a0 doesn't change
    	move $a1, $s2
    	move $a2, $t0
    	move $a3, $s4
    	jal get_parent
    	move $t5, $v0 # parentIndex
    	move $t6, $v1 # leftOrRight
    	
    	
    	# retore the argument registers
    	
    	move $a0, $s7
    	lw $a1, 0($sp)
    	lw $a2, 4($sp)
    	lw $a3, 8($sp)
    	addi $sp, $sp, 12
    	
    	sll $t0, $t5, 2
    	add $t7, $a0, $t0 # t7 = nodes[parentIndex]
    	
    	beqz $s5, not_a_leaf
    		# s5 = 1 -> minIsLeaf is true
    		bnez $t6, min_right
    			# t6 = 0 -> leftOrRight = left
    			li $t0, 255
    			sb $t0, 3($t7) # nodes[parentIndex].left = null
    			j minIsLeaf_done
    		
    		min_right:
    			# t6 = 1 -> leftOrRight = right
    			li $t0, 255
    			sb $t0, 2($t7)
    			j minIsLeaf_done

        not_a_leaf:   
        	# s5 = 0, minIsLeaf is false
        	bnez $t6, not_leaf_minRight 
        		# t6 = 0 -> leftOrRight = left
        		# change parent's left reference to min's right child
        		lbu $t0, 2($s6) # t0 = nodes[minIndex].right
        		sb $t0, 3($t7) # nodes[parentIndex].left = nodes[minIndex].right
        		j minIsLeaf_done

        	not_leaf_minRight:
        		# t6 = 1 -> leftOrRight = right
        		# change parent's right reference to min's right child
        		lbu $t0, 2($s6) # t0 = nodes[minIndex].right
        		sb $t0, 2($t7) # nodes[parentIndex].right = nodes[minIndex].right
        		j minIsLeaf_done
    
    minIsLeaf_done:
    
    # replace deleteNode's value with minimun from right subtree
    lb $t1, 0($s6)
    lb $t2, 1($s6)
    
    sb $t1, 0($s3)
    sb $t2, 1($s3)
    
    # remove the flag from the min node's position
    # backup the argument registers    	
    move $s7, $a0
    addi $sp, $sp, -12
    sw $a1, 0($sp)
    sw $a2, 4($sp)
    sw $a3, 8($sp)
    
    move $a0, $a3
    move $a1, $s5
    li $a2, 0
    move $a3, $s0
    jal set_flag
    
    # restore the argument registers
    move $a0, $s7
    lw $a1, 0($sp)
    lw $a2, 4($sp)
    lw $a3, 8($sp)
    addi $sp, $sp, 12
    
    li $v0, 1
    
    
    
    
    del_return:
    lw $ra, 0($sp)
    lw $s0, 4($sp) # int maxSize
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    lw $s7, 32($sp)
    addi $sp, $sp, 36
    jr $ra

##############################
# EXTRA CREDIT FUNCTION
##############################

add_random_nodes:
    #Define your code here
    # a0 = Node[] nodes
    # a1 = int maxSize
    # a2 = int rootIndex
    # a3 = byte[] flags
    # 4($sp) = int seed
    # 0($sp) = int fs
    
    
    lw $s0, 0($sp) # int fd
    lw $s1, 4($sp) # int seed
    
    addi $sp, $sp, -36
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    
    bgez $a2, random_keep_I
    j random_return
    random_keep_I:
    blt $a2, $a1, random_keep
    j random_return
    random_keep: 
    
    move $s2, $a0
    move $s3, $a1
    
    # linear search
    addi $sp, $sp, -8
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    
    move $a0, $a3
    move $a1, $s3
    jal linear_search
    move $s7, $v0
     
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    addi $sp, $sp, 8
    # after linear search
    
    li $a0, 0
    move $a1, $s1
    li $v0, 40
    syscall
    
    beq $s7, -1, while_end
    
    while_loop: # while newIndex(s7) != -1
    	li $v0, 42
    	li $a0, 0
	li $a1, 32768
	syscall
    	move $t0, $a0
    	li $a0, 0
    	li $v0, 42
    	li $a1, 32768
    	syscall
    	move $t1, $a0
    	sub $s7, $t0, $t1
    	
    	bgez $s7, newValue_fine
		# s7 is negative here
		addi $s7, $s7, -1
    	newValue_fine: 
    	
    	# backup
    	addi $sp, $sp, -12
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	
    	move $a0, $s2 
    	move $a1, $a2
    	move $a2, $s4
    	jal find_position
    	
    	move $s5, $v0
    	move $s6, $v1
    	  	
    	   	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	addi $sp, $sp, 12 
    	
    	# write the following exact to file
    	###################################################
    	###################################################
    	# write(fd, "New value: ", 11);
    	# backup
    	addi $sp, $sp, -12
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	
    	move $a0, $s0
    	la $a1, new_value_string
    	li $a2, 9
    	jal write
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	addi $sp, $sp, 12
    	
    	###################################################
    	###################################################
    	# itof(fd, newValue)
    	#backup
    	addi $sp, $sp, -8
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	
    	move $a0, $s0
    	move $a1, $s4
    	jal itof
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	###################################################
    	###################################################
    	# write(fd, "\n", 1);
    	# backup
    	addi $sp, $sp, -12
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	
    	move $a0, $s0
    	la $a1, newline
    	li $a2, 1
    	jal write
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	addi $sp, $sp, 12

    	###################################################
    	###################################################
    	# write(fd, "Parent index: ", 14);
    	# backup
    	addi $sp, $sp, -12
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	
    	move $a0, $s0
    	la $a1, parent_index_string
    	li $a2, 14
    	jal write
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	addi $sp, $sp, 12    
    	
    	###################################################
    	###################################################
    	# itof(fd, parentIndex);
    	#backup
    	addi $sp, $sp, -8
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	
    	move $a0, $s0
    	move $a1, $s5
    	jal itof
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	###################################################
    	###################################################
    	# write(fd, "\n", 1);
    	# backup
    	addi $sp, $sp, -12
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	
    	move $a0, $s0
    	la $a1, newline
    	li $a2, 1
    	jal write
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	addi $sp, $sp, 12

    	###################################################
    	###################################################
    	# write(fd, "Left (0) or right (1): ", 23);
    	# backup
    	addi $sp, $sp, -12
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	
    	move $a0, $s0
    	la $a1, l_or_r
    	li $a2, 23
    	jal write
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	addi $sp, $sp, 12

    	###################################################
    	###################################################
    	# itof(fd, parentIndex);
    	#backup
    	addi $sp, $sp, -8
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	
    	move $a0, $s0
    	move $a1, $s6
    	jal itof
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	###################################################
    	###################################################
    	# write(fd, "\n\n", 2);
    	# backup
    	addi $sp, $sp, -12
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	
    	move $a0, $s0
    	la $a1, two_lines
    	li $a2, 2
    	jal write
    	
    	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	addi $sp, $sp, 12

    	###################################################
    	###################################################
    	
    	# Add node to next available position with value
    	# backup
    	addi $sp, $sp, -20
    	sw $s3, 0($sp) # argument for function to be called
    	sw $a3, 4($sp) # argument for function to be called
    	sw $a0, 8($sp)
    	sw $a1, 12($sp)
    	sw $a2, 16($sp)
    	
    	move $a0, $s2
    	move $a1, $a2
    	move $a2, $s4
    	move $a3, $s7
    	jal add_node	
    		
    	# restore
    	lw $a3, 4($sp) # argument for function to be called
    	lw $a0, 8($sp)
    	lw $a1, 12($sp)
    	lw $a2, 16($sp)
	addi $sp, $sp, 20  
	
	######## linear search
	#backup
    	addi $sp, $sp, -8
    	sw $a0, 0($sp)
    	sw $a1, 4($sp)
    	
    	move $a0, $a3
    	move $a1, $s3
    	jal linear_search
	move $s7, $v0
	# restore
    	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	
    	bne $s7, -1, while_loop
		
    while_end:
    
    # backup
    addi $sp, $sp, -12
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    
    sll $t1, $a2, 2
    add $t0, $s2, $t1 # address of nodes[rootIndex]
    move $a0, $t0
    move $a1, $s2
    move $a2, $s0
    jal preorder
    
    
    # restore
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    addi $sp, $sp, 12
    
    
    random_return:
    move $a0, $s2
    move $a1, $s3
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    lw $s7, 32($sp)
    addi $sp, $sp, 36
    jr $ra



#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
newline: .asciiz "\n"
.align 2
node_value: .space 20
.align 2
new_value_string: .asciiz "New value: "
.align 2
parent_index_string: .asciiz "Parent index: "
.align 2
l_or_r: .asciiz "Left (0) or right (1): "
.align 2
two_lines: .asciiz "\n\n"
#place any additional data declarations here

