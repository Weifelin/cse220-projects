##############################################################
# Homework #3
# name: Weifeng Lin
# sbuid: 110161112
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

smiley:
    #Define your code here
    	addi $sp, $sp, -12
    	sw $ra, 0($sp)
    	sw $s0, 4($sp)
    	sw $s1, 8($sp)
    	
    	li $s0, 4294901760	# start location address of MMIO
    	
    	## set background to black, foreground white.
    	move $t0, $s0
    	li $t1, 0 # counter
    	li $t2, 0 # hold the current byte
    	
    	reset:
    	bgt $t1, 99, reset_done
    	lw $t2, null
    	sb $t2, 0($t0)
    	# store black back and white front to current byte.
    	li $t2, 15
    	sb $t2, 1($t0)
    	addi $t0, $t0, 2
    	addi $t1, $t1, 1
    	j reset
    	
    	reset_done:
    	#setting the eyes.(2,3), (3,3), (2,6), (3,6). The cells are 23rd, 33rd, 26th, 36th corresponding in the table.
    	# and the starting bytes of these cells are 46, 66, 52, 72 respectively.   	
    	#for (2,3)
    	li $a0, 2
    	li $a1, 3
    	# eye, yellow background and gray foreground is B7, which is 183.
    	# eye, use bomb, which is b
    	li $a2, 183
    	lb $a3, bomb
    	jal set_cell_content  	
    	#for (3,3)
    	li $a0, 3
    	li $a1, 3
    	li $a2, 183
    	lb $a3, bomb
    	jal set_cell_content    	
    	#for (2,6)
    	li $a0, 2
    	li $a1, 6
    	li $a2, 183
    	lb $a3, bomb
    	jal set_cell_content  	
    	#for (3,6)
    	li $a0, 3
    	li $a1, 6
    	li $a2, 183
    	lb $a3, bomb
    	jal set_cell_content
    	
    	# setting smile. (6,2),(7,3),(8,4), (8,5), (7,6), (6,7)
    	# red bacground with white foreground is 1F, which is 31. 
    	#for(6,2)
    	li $a0, 6
    	li $a1, 2
    	li $a2, 31
    	lb $a3, explode
    	jal set_cell_content
    	#for(7,3)
    	li $a0, 7
    	li $a1, 3
    	li $a2, 31
    	lb $a3, explode
    	jal set_cell_content
    	#for(8,4)
    	li $a0, 8
    	li $a1, 4
    	li $a2, 31
    	lb $a3, explode
    	jal set_cell_content
    	#for(8,5)
    	li $a0, 8
    	li $a1, 5
    	li $a2, 31
    	lb $a3, explode
    	jal set_cell_content
    	#for(7,6)
    	li $a0, 7
    	li $a1, 6
    	li $a2, 31
    	lb $a3, explode
    	jal set_cell_content
    	#for(6,7)
    	li $a0, 6
    	li $a1, 7
    	li $a2, 31
    	lb $a3, explode
    	jal set_cell_content
    	
    	 	
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	addi $sp, $sp, 12
	jr $ra
	
#################
# helper methods
#################
# convert the cordinators to the #th cell in the table（ordinal #）

to_ordinal:	#say, (2,3) will be converted to 23. The 2 will be in a0, 3 will be a1 when call this function. returned in v0
	
	move $t0, $a0
	move $t1, $a1
	li $t3, 0
	li $t4, 10
	mul $t3, $t0, $t4
	add $t3, $t3, $t1
	move $v0, $t3
	jr $ra

# set the back and foreground. say(2,3). 
# Than a0 is 2(row), a1 is 3(col). and 
# a2 contains the colorinfo. a3 contains the ascii character
# this function will call t0_ordinal
# the a0, a1 are the same with to_ordinal, so no need to set that in this function. Callee will set that.	
set_cell_content:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal to_ordinal
    	move $t1, $v0
    	li $v0, 0
    	li $t2, 2 # used to get the starting byte of (2,3)
    	mul $t1, $t1, $t2	# get the starting byte of (2,3), relatively
    	li $t0, 4294901760	# start location address of MMIO
    	add $t0, $t0, $t1	# to now is the address of starting byte of (2,3)
    	sb $a2, 1($t0)
    	sb $a3, 0($t0)
    	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
##############################
# PART 2 FUNCTIONS
##############################

open_file:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -200 
    ###########################################
    
    
    li $a1, 0 # read only
    li $a2, 0
    # a0 contains filename
    li $v0, 13
    syscall
    
    
    jr $ra

close_file:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -200
    ###########################################
    
    li $v0, 16
    syscall
 
    jr $ra

load_map:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -200
    ###########################################
    addi $sp, $sp, -36
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp) # used for count the # of int in the file.
    sw $s3, 16($sp) # used for counting if two ints are read when reading.
    sw $s4, 20($sp) # used to storing row#
    sw $s5, 24($sp) # used for storing col#
    sw $s6, 28($sp) # used for storing bomb#
    sw $s7, 32($sp)
    
    
    		
    move $s0, $a0 # file descriptor
    move $s1, $a1 # cells array
    
    
    
    # set flag (bit4) to 0.  using and with 1110 1111 -> 239
    li $s2, 0 # counter
    move $s3, $s1  # cell array
   
    setoff: # for flag and reveal. a0 = on/off. a1 = cell address
    bgt $s2, 99, setoff_done
    li $a0, 0
    move $a1, $s3
    jal setFlag
    li $a0, 0
    move $a1, $s3
    jal setReveal
    addi $s2, $s2, 1
    addi $s3, $s3, 1
    j setoff
    setoff_done:
   

   
   
    
    
    
    li   $s2, 0   # used for counting the # of int in the file.
    li 	 $s3, 0   # used for counting if two ints are read when reading.
    
    li   $s4, 0   # row#
    li   $s5, 0   # col #
    li   $s6, 0	  # bomb#
    # reset the array #a0 is the address of cells_array
    move $a0, $s1 
    jal resetCellsArray
   
   
    # read the file. syscall 14. 
    # a0= file Descriptor
    # a1 = address of buffer
    # a2 = maximum # of character read each time.
    # v0 will contain #of character read. 0 means the end of file. used to terminated the loop.
    
    li $v0, 14
    move $s7, $v0
    reading:
    beqz $s7, readingDone
    move $a0, $s0
    la $a1, reading_buffer
    li $a2, 1
    li $v0, 14
    syscall # after this, reading_buffer will contain the char read. return v0=0 if end of the file.
    move $s7, $v0
    #lb $t1, ($a1) #test
    
    # deal with the char here!
    # I will use method: 
    # isSpace, isValid, hasBomb(determine if repeated), 
    # and setReveal, setBomb, setFlag, calculate_bombs_around 
    # to set the each elements of cells arrary
    # previous defined methods like to_ordinal might be needed.
    	readnext:
    		jal isSpace # return 1 if that is space. 0 not.
    		move $t0, $v0
    		beqz $t0, readnext_done # if current byte is not space( t0 /=0), keep reading.
    		
    		move $a0, $s0
    		la $a1, reading_buffer
    		li $a2, 1
    		li $v0, 14
    		syscall
    		move $s7, $v0
    		beqz $s7, readingDone
    		j readnext
    readnext_done:
    
    jal isValid	# return 0 if not valid. 1 otherwise.
    move $t0, $v0
    #bnez $t0, valid
    beqz $t0, is_not_valid
    # if not valid, do this
    # li $v0, -1
    # readingDone
    #valid:
    addi $s2, $s2, 1  # total number of int in file.
    addi $s3, $s3, 1  # if two ints are read.
    
    bgt $s3, 1, do_cordinate
    ## when s3 = 1. 
    lb $s4, reading_buffer
    addi $s4, $s4, -48 # convert to real int.
    j keep_reading
    
    
    	do_cordinate:
    	######## when two ints are read.
    	lb $s5, reading_buffer
    	addi $s5, $s5, -48
    	li $s3, 0
    	# now s4 and s5 should contain (row, col)
    	
    	# check if the byte is repeated(hasBomb already).
    	move $a0, $s4
    	move $a1, $s5
    	jal to_ordinal
    	move $a0, $v0
    	move $a1, $s1 # address of cells_array
    	jal hasBomb	# return 1 if it has. 0 elsewise.
    	move $t0, $v0
    	beq $t0, 1, keep_reading
    	
    	move $a0, $s4
    	move $a1, $s5
    	move $a2, $s1 # address of cells_array
    	jal setBomb
    	addi $s6, $s6, 1
    ########
    keep_reading:
    j reading
    
    
    readingDone:  
    # check the # of int contained in this file to see if it is valid(even #). # stored in s2
    # using "and" with 1(00000001) to keep the lsb. bit0.
    move $t0, $s2
    andi $t0, $t0, 1  
    bnez $t0, is_not_valid   
    bgt $s6, 99, is_not_valid   
    blt $s6, 1, is_not_valid
    
    # calculate bombs around each cell and write to cell byte
    # a0 = cell_array address.
    move $a0, $s1
    jal calculate_bombs
    
    
    
    li $v0, 0
    j load_end
    
      
    is_not_valid:    
    li $v0, -1
    j load_end     
            
    
    load_end:  
    move $a0, $s0 # file descriptor
    move $a1, $s1 # cells array
              
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp) # used to storing row#
    lw $s5, 24($sp) # used for storing col#
    lw $s6, 28($sp)
    lw $s7, 32($sp)
    addi $sp, $sp, 36
    jr $ra
################
# helper methods
################

#a0 is the address of cells_array
resetCellsArray:
    # clear each byte of cells array.
    li $t0, 0 #counter
    move $t1, $a0 # address of cells array
    
    
    clear_array:
    bgt $t0, 99, clear_done
    sb $0, 0($t1)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j clear_array
    
    clear_done:
    jr $ra
	
# return 1 if that is space. 0 not.
isSpace:
	lb $t0, reading_buffer
	lw $t1, tab
	lw $t2, return
	lw $t3, new_line
	lw $t4, space
	
	beq $t0, $t1, is
	beq $t0, $t2, is
	beq $t0, $t3, is
	beq $t0, $t4, is
	li $v0, 0
	jr $ra
	
	is:
	li $v0, 1
	jr $ra
	

# return 1 if it is valid. 0 otherwise.
isValid:
	lb $t0, reading_buffer
	addi $t0, $t0, -48 # reading string
	bgt $t0, 9, notvalid
	blt $t0, $0, notvalid
	li $v0, 1
	jr $ra
	
	notvalid:
	li $v0, 0
	jr $ra

# a0, the ordinal # of the table(# in cells); a1 = cells_array address
# will not use to_ordinal, already ordinalled.
# return 1 if it has. 0 elsewise.
hasBomb:
#	addi $sp, $sp, -4
#	sw $ra, 0($sp)
	
#	jal to_ordinal
	move $t0, $a0 #  #th cell
	
	move $t1, $a1 # address of cells_array
	add $t1, $t1, $t0 # bomb location is in t1 now
	# bomb will be stored in bit5 in this byte. use "and" with (00100000->32) to keep the bit5. all other bits will be 0.
	# if the byte contain bomb. than bit 5 is 1. the result after and will be 00100000->32. 
	# if the byte has no bomb. than bit 5 is 0. the result will be zero.
	lb $t2, 0($t1)
	andi $t2, $t2, 32
	
	bnez $t2, has
	# this is don't have.
	li $v0, 0
	j has_end
	
	# this is has.
	has:
	li $v0, 1
	
	has_end:
#	lw $ra, 0($sp)
#	addi $sp, $sp, 4
	jr $ra	


#a0 determines on/off. 1 is on . 0 is off.
#a1 = cell address
setReveal:
	# if a0 = 1, on.
	# bit 4 = 1.
	# ON: or with 0100 0000-> 64
	# OFF: and with 1011 1111 -> 191
	lb $t0, 0($a1)
	beqz $a0, reveal_off
	#on
	ori $t1, $t0, 64
	sb $t1, 0($a1)
	j reveal_end
	
	reveal_off:
	#off
	andi $t1, $t0, 191
	sb $t1, ($a1)
	
	reveal_end:
	jr $ra

#(a0, a1) = (row, col). a2 = cells_array address
# will use to_ordinal
setBomb:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal to_ordinal
	move $t0, $v0 #  #th cell
	
	move $t1, $a2 # address of cells_array
	add $t1, $t1, $t0 # bomb location is in t1 now
	# bomb will be stored in bit5 in this byte. use "or" with 00100000, which is 32.
	lb $t2, ($t1)
	ori $t2, $t2, 32
	sb $t2, ($t1)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	
	

#a0 determines on/off. 1 is on . 0 is off.
#a1 = cell address
setFlag:
	# if a0 = 1, on.
	# bit 4 = 1.
	# ON: or with 0001 0000->16
	# OFF: and with 1110 1111 -> 239
	lb $t0, 0($a1)
	beqz $a0, flag_off
	#on
	ori $t1, $t0, 16
	sb $t1, 0($a1)
	j flag_end
	
	flag_off:
	#off
	andi $t1, $t0, 239
	sb $t1, ($a1)
	
	flag_end:
	jr $ra

#a0 = ordinal# like 34. 3 will be in v0 and 4 will be in v1
to_row_col:
	move $t0, $a0
	li $t1, 10
	div $t0, $t2 
	mflo $v0
	mfhi $v1
	jr $ra

#(a0, a1) = (row, col), a2 = cell array.   v0 = #of bombs
cal_bombs_for_cell:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	
	move $s0, $a0
	move $s1, $a1
	move $s3, $a2
	li $s2, 0 #counter
	
	#top-left
	addi $a0, $s0,-1
	addi $a1, $s1, -1
	bltz $a0, middle
	bltz $a1, middle
	bgt $a0, 9, middle
	bgt $a1, 9, middle
	jal to_ordinal
	move $a0, $v0
	move $a1, $s3
	jal hasBomb
	add $s0, $s0, $v0
	
	#middle
	middle:
	addi $a0, $s0,-1
	addi $a1, $s1, 0
	bltz $a0, top_right
	bltz $a1, top_right
	bgt $a0, 9, top_right
	bgt $a1, 9, top_right
	jal to_ordinal
	move $a0, $v0
	move $a1, $s3
	jal hasBomb
	add $s0, $s0, $v0
	
	#top_right
	top_right:
	addi $a0, $s0,-1
	addi $a1, $s1, 1
	bltz $a0, left
	bltz $a1, left
	bgt $a0, 9, left
	bgt $a1, 9, left
	jal to_ordinal
	move $a0, $v0
	move $a1, $s3
	jal hasBomb
	add $s0, $s0, $v0
	
	#left
	left:
	addi $a0, $s0,0
	addi $a1, $s1, -1
	bltz $a0, right
	bltz $a1, right
	bgt $a0, 9, right
	bgt $a1, 9, right
	jal to_ordinal
	move $a0, $v0
	move $a1, $s3
	jal hasBomb
	add $s0, $s0, $v0
	
	#right
	right:
	addi $a0, $s0,0
	addi $a1, $s1, 1
	bltz $a0, buttom_left
	bltz $a1, buttom_left
	bgt $a0, 9, buttom_left
	bgt $a1, 9, buttom_left
	jal to_ordinal
	move $a0, $v0
	move $a1, $s3
	jal hasBomb
	add $s0, $s0, $v0
	
	#buttom_left
	buttom_left:
	addi $a0, $s0,1
	addi $a1, $s1, -1
	bltz $a0, buttom
	bltz $a1, buttom
	bgt $a0, 9, buttom
	bgt $a1, 9, buttom
	jal to_ordinal
	move $a0, $v0
	move $a1, $s3
	jal hasBomb
	add $s0, $s0, $v0
	
	#buttom
	buttom:
	addi $a0, $s0,1
	addi $a1, $s1, 0
	bltz $a0, buttom_right
	bltz $a1, buttom_right
	bgt $a0, 9, buttom_right
	bgt $a1, 9, buttom_right
	jal to_ordinal
	move $a0, $v0
	move $a1, $s3
	jal hasBomb
	add $s0, $s0, $v0
	
	#buttom_right
	buttom_right:
	addi $a0, $s0,1
	addi $a1, $s1, 1
	bltz $a0, finshed
	bltz $a1, finshed
	bgt $a0, 9, finshed
	bgt $a1, 9, finshed
	jal to_ordinal
	move $a0, $v0
	move $a1, $s3
	jal hasBomb
	add $s0, $s0, $v0
	
	finshed:
	
	move $v0, $s0
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra

# a0 = cell_array address.
# when adding the result to the byte. use "or"
calculate_bombs:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	
	move $s3, $a0
	
	li $s0, 0  # counter for row
	li $s1, 0 # counter for col
	li $s2, 0 # store # of bombs
	
	cal_row:
	bgt $s0, 9, cal_done
	li $s1, 0
		cal_col:
		bgt $s1, 9, cal_col_done
		   move $a0, $s0
		   move $a1, $s1
		   move $a2, $s3
		   jal cal_bombs_for_cell
		   move $s2, $v0 # # of bombs in this cell
		   # writing to cell array
		   move $a0, $s0
		   move $a1, $s1
		   jal to_ordinal
		   #add $s2, $s2, $v0 #cell number of current coordinate
		   #add $t0, $s3,$s2  # address of current cell
		   add $t0,$s3, $v0
		   lb $t1, ($t0)
		   or $t1, $t1, $s2 # add # of bombs to the byte
		   sb $t1, ($t0)
		   
		   addi $s1, $s1,1
		   j cal_col
		cal_col_done:
		addi $s0, $s0, 1
		j cal_row
	
	cal_done:
	
	
	
	
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	jr $ra




##############################
# PART 3 FUNCTIONS
##############################

init_display:
    #Define your code here
    li $t0, 4294901760	# start location address of MMIO
    sb $0, cursor_row
    sb $0, cursor_col
    
    
    li $t1, 0 # counter
    li $t2, 0 # hold the current byte
    initset:
    	bgt $t1, 99, initset_done
    	lw $t2, null
    	sb $t2, 0($t0)
    	# store grey back and white front to current byte.
    	li $t2, 127
    	sb $t2, 1($t0)
    	addi $t0, $t0, 2
    	addi $t1, $t1, 1
    	j initset
    	
    	initset_done:
    	li $t0, 4294901760
    	li $t1, 191 #yellow/white
    	sb $t1, 1($t0)
    
    
    
    jr $ra


	
#(a0, a1)
# a2 = char to display.
# a3 = forecolor
# a4 = background
set_cell:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    # li $v0, -200
    ###########################################
    	lw $t0, ($sp) #a4 = background color
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	move $s4, $t0
	
	bgt $s3, 15, setFail
	blt $s3, 0, setFail
	bgt $s4, 15, setFail
	blt $s4, 0, setFail
	bgt $a0, 9, setFail
	blt $a0, 0, setFail
	bgt $a1, 9, setFail
	blt $a1, 0, setFail
	j validValue
	
	setFail:
    	li $v0, -1
    	j setDone
	
	validValue:

	
	jal to_ordinal
    	move $t1, $v0
    	li $v0, 0
    	li $t2, 2 # used to get the starting byte of (2,3)
    	mul $t1, $t1, $t2	# get the starting byte of (2,3), relatively
    	li $t0, 4294901760	# start location address of MMIO
    	add $t0, $t0, $t1	# to now is the address of starting byte of (2,3)
    	
    	#sb $a2, 1($t0)
    	#sb $a3, 0($t0)
    	sb $s2, 0($t0)
    	
    	# get color value
    	lb $t1, ($s4)
    	sll $t1, $t1, 4
    	or $t1, $t1, $s3
    	
    	sb $t1, 1($t0)
    	
    	
    	setDone:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	sw $s4, 20($sp)
	addi $sp, $sp, 24
	jr $ra
   

# won = 1, lost = -1. onging = 0
reveal_map:
    #Define your code here
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    beqz $a0, reveal_done
    beq $a0, 1, won
    beq $a0, -1, lost
    
    lost:
    
    j reveal_done
    
    won:
    jal smiley
    
    reveal_done:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra


##############################
# PART 4 FUNCTIONS
##############################

perform_action:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ##########################################
    jr $ra

game_status:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ##########################################
    jr $ra

##############################
# PART 5 FUNCTIONS
##############################

search_cells:
    #Define your code here
    jr $ra


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
cursor_row: .word -1
cursor_col: .word -1
.align 2
null: .ascii "\0"
.align 2
bomb: .ascii "b"
.align 2
explode: .ascii "e"
.align 2
flag: .ascii "f"
.align 2
reading_buffer: .space 1
.align 2
tab:.ascii "\t"
.align 2
return: .ascii  "\r"
.align 2
new_line: .ascii "\n"
.align 2
space: .ascii " "
#place any additional data declarations here

