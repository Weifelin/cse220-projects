##############################################################
# Homework #2
# name: Weifeng Lin
# sbuid: 110161112
##############################################################
.text

##############################
# PART 1 FUNCTIONS 
##############################

atoui:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	#li $v0, 0
	############################################
	#jr $ra
	addi $sp, $sp, -8 	#make space on stack to store two registers
	sw $s0, 4($sp)		#store s0 and s1 to stack
	sw $s1, 0($sp)
	
	la $s0, ($a0)		# load the input from a0
	#move $s0, $a0
	
	move $v0, $0		# initialize v0 to 0.
	move $s1, $0		# s1 will store the converted number. Initialzied to 0.
	lw $t0, null
	move $t1, $0		# t1 will store the rightmost byte (Which is the first character of input)of input. Initialize t1 to 0 now.
	li $t2, 10		# t2 stores 10, which will be used to convert the string to number.
	lw $t3, Zero		# t3 and t4  stores the string value of 0 and 9 respectively as in ascii table. 
	lw $t4, Nine
	
	convert:
		lb $t1, 0($s0)
		beq $t1, $t0, convertDone
		blt $t1, $t3, convertDone	# finish if the first letter of input isnt a number.
		bgt $t1, $t4, convertDone
		sub $t5, $t1, $t3		# convert the letter to actual number in binary form to t5
		mul $s1, $s1, $t2		# s1 = s1 * 10
		add $s1, $s1, $t5		
		addi $s0, $s0, 1
		j convert
	convertDone:
		addi $v0, $s1, 0		# v0 store returned value. Store result to v0 here.
		
	
	lw $s0, 4($sp)		#load the orginal s0 and s1 back from stack.
	lw $s1, 0($sp) 
	addi $sp, $sp, 8
	jr $ra
	
uitoa:
    #Define your code here
    li $v0, 0
    li $v1, 0
    
    addi $sp, $sp, -8
    sw $s0,0($sp)
    sw $s1, 4($sp)
    
    
    blez $a0, return
    
    #la $s0, ($a0)	#store the value to s0
    move $s0, $a0
    move $s1, $a1	# store the address of output
    li $t0, 0		#initalize counter t0 to 0.
    li $t1, 0		# t1 will store the rightmost digit of the integer.
    li $t2, 10		# t2 store 10 to divide the value. 
    li $t4, 0		# t4 will store the amount of digits the value has.
    
    
    countDigits:
    	blt $s0, 1, countDone
    	div $s0, $t2			# s0/t2, keep reminder to hi and quotitent to lo
    	mflo $s0
    	addi $t4, $t4, 1
    	j countDigits
    	
    	countDone:
    		bgt $t4, $a2, return
    		move $s0, $a0
    		add $s1, $s1, $t4
    		
    toString:
    	blt $s0, 1, converted
    	#beq $t0, $a2, converted		# a2 stores the size of output
    	div $s0, $t2			# s0/t2, keep reminder to hi and quotitent to lo
    	mflo $s0
    	#sll $t3, $t0, 2			#  t3 = i * 4. t0 is i.
    	#add $s1, $s1, $s1		# t3 will hold the address of s1(output char[i])
    	mfhi $t1
    	addi $t1, $t1, 48		# convert the number to ascii table value of corresponding char
    	
    	addi $s1, $s1, -1
    	sb $t1, ($s1)			# store t1 to char[i]
    	#addi $t0, $t0, 1
    	
    	j toString
    	
    converted:
    	add $s1, $s1, $t4
    	move $v0, $s1
    	li $v1, 1
     
    return:
    	lw $s0, 0($sp)		#load the orginal s0 and s1 back from stack.
	lw $s1, 4($sp) 
	addi $sp, $sp, 8
	
    	jr $ra

##############################
# PART 2 FUNCTIONS 
##############################    
            
decodeRun:
    #Define your code here
    li $v0, 0
    li $v1, 0		#return only one value so v1 is not necessary
    
    addi $sp, $sp, -8
    sw $s0,($sp) 
    sw $s1,4($sp)
    move $v0, $a2 
    
    lb $s0, ($a0)	# store the char from a0
    #move $s0, $a0
    move $s1, $a2	# store a2.
    blez $a1, exit
    
    blt $s0, 49, exit
    ble $s0, 90, cont
    ble $s0, 96, exit
    ble $s0, 122, cont
    j exit
    cont:
    li $t0, 0 		#counter
    
    decode:
    	beq $t0, $a1, decodeDone
    	sb $s0, ($s1)
    	addi $s1, $s1, 1
    	addi $t0, $t0, 1
    	j decode
    	
    decodeDone:
    li $v1, 1    
    move $v0, $s1
    
    exit:
    lw $s0, ($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    
    jr $ra

decodedLength:
    #Define your code here
    li $v0, 0
    li $v1, 0		#return only one value so v1 is not necessary, but still need to reset to 0 for other function.
    
    addi $sp, $sp, -12
    sw $s0,0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    
    lb $s2, ($a1)
    
    blt $s2, 48, running	# check if the a1(runflag) is alphanumeric
    ble $s2, 57, over		# if a1 <= 57(9 in ascii) and a1>= 48(0 in ascii), over
    ble $s2, 64, running	# if a1 >= 58 (':') and <= 64('@'), running
    ble $s2, 90, over		# if a1 >= 65 ('A') and <= 90('Z'), over
    ble $s2, 96, running	# if a1 >= 91('[') and <= 96('''), running
    ble $s2, 122, over		# if a1 >= 97('a') and <= 122('z'), over
    
    #j over
    
    running:
    	lw $t0, null		# load null to t0
    	li $s0, 0		# s0 is counter, initialize to 0.
    	move $s1, $a0		# load the address of the label that hold the input string to s1.
    	li $t1, 0		# t1 will hold the first letter of the input, initialize to 0.
    	
    	li $t3, 10		# t3 = 10. will be used to convert the number string after flag to real number
    	
    	lb $t1, ($s1)
    	beq $t1, $t0, over	# if the input(a0) is empty string, than return directly
    	
    	counting:
    		lb $t1, ($s1)
    		li $t2, 0		# t2 wil hold the number after the flag.
    		beq $t1, $s2, doflag
    		addi $s0, $s0, 1	# count the number of letters if it is not a flag
    		addi $s1, $s1, 1	# s1 now point to next byte.
    		beq $t1, $t0, countingDone
    		j counting
 
    		doflag:
    			bne $t1, $s2, skip
    			addi $s1, $s1, 1
    			skip:
    			addi $s1, $s1, 1	# there will be a letter right follow the flag. And then number strings.
    			lb $t1, ($s1)		# t1 now should contain the first digits of numbers.
    			blt $t1, 48, flagDone
    			ble $t1, 57, stay
    			j flagDone 
    		
    			stay:
    			addi $t1, $t1, -48
    			mul $t2, $t2, $t3	# t2 = t2*10
    			add $t2, $t2, $t1	# t2 = t2 + t1
    			j doflag
    		    	
    		flagDone:
    		add $s0, $s0, $t2
    		j counting
    		
    		countingDone:
    		move $v0, $s0
    		   
    
    over:
    lw $s0, 0($sp)		#load the orginal s0 and s1 back from stack.
    lw $s1, 4($sp) 
    lw $s2, 8($sp)
    addi $sp, $sp, 12
    jr $ra
         
runLengthDecode:
    #Define your code here
    li $v0, 0
    
    addi $sp, $sp, -36
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
        
    li $s3, 0 			# argument buffer
    li $s4, 0			# argument buffer
    li $s5, 0			# argument buffer   
    
    li $s6, 0			# buffer
    li $s7, 0			# buffer
    lw $t3, null 		# t3 = null
    
    # checking input length, if input length exceeds the outputsize, then, exit.
    move $s3, $a1		# store a1 to t0 for using decodelength
    move $a1, $a3		# a1 now should contain the runflag
    jal decodedLength		# decodedLength will return the length of the input to v0
    move $a1, $s3		# move the output back to a1.
    move $t4, $v0
    li $v0, 0
    beqz $t4, exitRun
    bgt $t4, $a2, exitRun	# if v0 > outputsize, exitRun
    
   
   
   # checking the output size.
   li $t4, 0			#t4 will count the length of output.
   move $s1, $a1
   output:
   	lb $t0,($s1)
   	beq $t0, $t3, outputDone
   	addi $t4, $t4, 1
   	addi $s1, $s1, 1
   	j output
   outputDone:
   
   blt $t4, $a2, exitRun  # if the size is greater than output length, exit
   
   
    #docoding
    
    move $s0, $a0		# s0 = input
    move $s1, $a1		# s1 = output
    lb   $s2, ($a3)		# s2 = runflag
    
    li $t4, 0			# t4 will hold the first letter of s0
    decoding:
    	 lw $t3, null 		# t3 = null
    	 lb $t4, ($s0)
    	 beq $t4, $t3, decodingDone
    	 beq $t4, $s2, dflag
    	 sb $t4, ($a1)
    #	 sb $t4, ($s1)
    
    # addi $s1, $s1, 1
    	 addi $a1, $a1, 1
    	 addi $s0, $s0, 1
    	 j decoding
    	 
    	 dflag:
    	 	bne $t4, $s2, skipJ	# if t4 not equal to runflag, then do skipJ
    	 	addi $s0, $s0, 1	
    	 	skipJ:
    	 		lb $t4, ($s0)	# t4 now contain the letter after runflag
    	 		move $s6, $t4
    	 		
    	 		addi $s0, $s0, 1
    	 		# will call  int atoui(char[] input). making backup for a0
    	 		move $s3, $a0
    	 		move $a0, $s0
    	 		jal atoui	# after this, v0 will store the int,which is runLength for decodeRun
    	 		move $s7, $v0 	# t5 will copy v0
    	 		move $a0, $s3	# give original a0 back.
    	 		
    	 		move $t0, $v0
    	 		li $t1, 10
    	 		li $t2, 0	#t2 will how the digits of s7
    	 		# dermine how many digits the return value is. Then add the number of digits to s0 so the rest of codes could read after that.
    	 		loop:
    	 		blt $t0, 1, loopOver
    	 		div $t0, $t1
    	 		mflo $t0
    	 		addi $t2, $t2, 1
    	 		j loop
    	 		loopOver:
    	 		
    	 		
    	 		#add $s0, $s0, $t2
    	 		
    	 		
    	 		
    	 		
    	 		# will call (char[], int) decodeRun(char letter, int runLength, char[] output)
    	 		# backup for a0, a1, a2
    	 		move $s3, $a0
    	 		move $s4, $a1
    	 		move $s5, $a2
    	 		
    	 		addi $s0, $s0, -1
    	 		#lb $t4, ($s0)		# t4 will store the letter after runflag
    	 		#addi $s0, $s0, 1
    	 	#addi $s1, $s1, -2	# move s0 2 letters back so the decodeRun can override start from runflag
    	 		#move $a0, $s6
    	 		
    	 		la $a0, ($s0)	#test
    	 		addi $s0, $s0, 1
    	 		add $s0, $s0, $t2
    	 		move $a1, $v0
    	 	#	move $a2, $s1\
    	 		move $a2, $s4		# s4 stores a1 now.
    	 		jal decodeRun
    	 		beqz $v1, failDecodeRun
    	 	#	move $s1, $v0
    	 		move $a1, $v0
    	 	#	add $s1, $s1, $s7
    	 	#	add $a1, $a1, $s7
    	 		failDecodeRun:
    	 		
    	 		move $a0, $s3	# give orginal arguments back.
    	 	#	move $a1, $s4
    	 		move $a2, $s5
    	 	#addi $s0, $s0, 2
    	 		j decoding
    	 
    decodingDone:
    	li $v0, 1
    	lw $t3, null
    	sb $t3, ($a1)
    	addi $a1, $a1, 1
    exitRun:
    lw $ra, ($sp)
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


##############################
# PART 3 FUNCTIONS 
##############################
                
encodeRun:
    #Define your code here
    li $v0, 0
    li $v1, 0
    
    addi $sp, $sp, -32
    sw $s0, ($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)	# s4 for store the size of output
    sw $s5, 24($sp)	# s5 backup of a0
    sw $s6, 28($sp)	# s6 backup of a2
    
    move $s0, $a2	# store output address to s0
    move $s6, $a2	# backup a2
    lb	 $s1, ($a0)	# store the char to s1
    move $s5, $a0	# backup a0
    lb   $s2, ($a3)	# store runflag to s2
    
    move $s3, $a1	# runLength
    
    
    
    #---------------------------------------------------
    
    # check if the letter (a0) is letter. exit if not
    blt $s1, 65, exitEncode
    ble $s1, 90, keepEncodingI
    ble $s1, 96, exitEncode
    ble $s1, 122, keepEncodingI
    j exitEncode
    
    keepEncodingI:
    #check if the runflag (a3) is an alphanumeric character. Exit if it is.
    blt $s2, 48, keepEncodingII
    ble $s2, 57, exitEncode
    ble $s2, 64, keepEncodingII
    ble $s2, 90, exitEncode
    ble $s2, 96, keepEncodingII
    ble $s2, 122, exitEncode
    
    keepEncodingII:
    #check if runlength(a1) is less or equal to 0. Exit if so.
    blez $a1, exitEncode
    
    
    # check outputSize(s0), if it is less than runLength, Exit.
    li $t0, 0		# counter
    li $t1, 1		# hold the first character
    lw $t2, null	
    
    output_loop:
    	lb $t1, ($s0)
    	beq $t1, $t2, out_loop_done
    	addi $t0, $t0, 1
    	addi $s0, $s0, 1
    	j output_loop
    out_loop_done:
    	move $s4, $t0
    	move $s0, $s6
    
    
    
    bgt $a1, 3, compress
    # if 1<= a1 <= 3, store letter(a0) a1 times to output.
    li $t0, 0		# t0 as counter
    writing:
    	beq $t0, $a1, writingDone
    	sb $s1, ($s0)
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j writing
    	
    writingDone:
    move $v0, $s0
    li   $v1, 1
    j exitEncode
    	
    # e.g  aaaaa -> !a5
    compress:
    	sb $s2, ($s0)		# store the runflag to output
    	addi $s0, $s0, 1
    	sb $s1, ($s0)		# store the letter to output
    	addi $s0, $s0, 1	
    	# convert integer runLength(a1) to string
    	
    	move $a0, $a1	#runLength
    	move $a1, $s0	#output
    	move $a2, $s4	#outputSize
    	
    	jal uitoa
    	move $s0, $v0
    	
    	move $a1, $a0
    	move $a0, $s5
    	move $a2, $s6
    	
    	
    	
  #-------------------------------------  	
  #  	move $t0, $a1
  #  	li   $t1, 10
  #  	li   $t2, 0	# store reminder
  #  	li   $t3, 0	# count digits
  # 
  #	
  #  	
  #  	con_digits:
  #  		blt $t0, 1, con_digits_done
  #  		div $t0, $t1
  #  		mflo $t0
  #  		addi $t3, $t3, 1
  #  		j con_digits
  #  		
  #  	con_digits_done:
  #  	move $t0, $a1
  #  	add  $s0, $s0, $t3
  #  	
  # 					# take space for integer.
  #  	con_to_string:
  #  		blt $t0, 1, to_done
  #  		div $t0, $t1			# s0/t2, keep reminder to hi and quotitent to lo
  #  		mflo $t0
  #  		mfhi $t2
  #  		addi $t2, $t2, 48		# convert the number to ascii table value of corresponding char
  #  		sb   $t2, ($s0)			# store converetd character to right position
  #  		addi $s0, $s0, -1
  #  	j con_to_string
  #  
  #  to_done:
    #------------------------------------
    move $v0, $s0
    li   $v1, 1
    
    #---------------------------------------------------
    exitEncode:
    lw $s0, ($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)	# s4 for store the size of output
    lw $s5, 24($sp)	# s5 backup of a0
    lw $s6, 28($sp)	# s6 backup of a2
    addi $sp, $sp, 32
    jr $ra


encodedLength:
    #Define your code here
    li $v0, 0
    
    addi $sp, $sp, -4
    sw $s0, ($sp)
    
    lw $t0, null
    li $t1, 0		#t1 counts the length.
    li $t2, 0		# store the current letter.
    li $t3, 0		# store next letter
    li $t4, 1		# count repeating times
    
    li $t5, 10		# used when count the number of digits for t4
    li $t6, 0		# store the number of digits of t4
    
    
    move $s0, $a0
    lb $t2, ($s0)
    beq $t2, $t0, lengthDone
    
    # count repeating times first, And then implements to t1.(Convert if over 3 times are repeated.)
    encoding_length:
    	lb $t2, ($s0)
    	beq $t2, $t0, encodingDone
    	lb $t3, 1($s0)
    	addi $s0, $s0, 1
    	bne $t2, $t3, convert_repeat
    	addi $t4, $t4, 1
    	j encoding_length
    	
    	convert_repeat:
    		bgt $t4, 3, digits
    		add $t1, $t1, $t4
    		li $t4, 1		# reset t4
    		j encoding_length
    		digits:
    			blt $t4, 1, digitsDone
    			div $t4, $t5
    			mflo $t4
    			addi $t6, $t6, 1
    			j digits
    		digitsDone:
    			addi $t1, $t1, 2	# runflag and a letter
    			add $t1, $t1, $t6
    			li $t4, 1		# reset t4
    			li $t6, 0		# reset t5
    			j encoding_length

    encodingDone:
    	addi $t1, $t1, 1			# count the null.
    	move $v0, $t1
    
    lengthDone:
    lw $s0, ($sp)
    addi $sp, $sp, 4   
    
    jr $ra        

runLengthEncode:
    #Define your code here
    li $v0, 0
     
    addi $sp, $sp, -36
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    #--------------------------------------------------------
    
    # backup parameters, and s0, s1, s2, s3 will be used as argument buffers respectively.
    move $s0, $a0	# input
    move $s5, $a0	# backup of a0
    move $s1, $a1	# output
    move $s6, $a1	# backup of a1
    move $s2, $a2	# outputSize
    move $s4, $a3	# make a backup of a3.
    lb   $s3, ($a3)	# runflag
    
    # checking the output length (s1), if that is less than the outputSize, exit
    
    li $t0, 0			# t0 will hold the first letter of output address
    li $t1, 0			#t1 will count the length of output.
    lw $t2, null		
    output_length:
   	lb $t0,($s1)
   	beq $t0, $t2, output_length_done
   	addi $t1, $t1, 1
   	addi $s1, $s1, 1
   	j output_length
    output_length_done:
    move $s1, $a1			#  reset s1 to output
    blt $t1, $s2, exitRunLengthEncode  # if the size is greater than output length, exit
    
    
    #check if the runflag (s3) is an alphanumeric character. Exit if it is.
    blt $s3, 48, keepRunLengthEncoding
    ble $s3, 57, exitRunLengthEncode
    ble $s3, 64, keepRunLengthEncoding
    ble $s3, 90, exitRunLengthEncode
    ble $s3, 96, keepRunLengthEncoding
    ble $s3, 122, exitRunLengthEncode
    
    keepRunLengthEncoding:
    # check if the encoded length exceeds the outputSize. Exit if so.
    # since a0 is input, and the argument for function int encodedLength(char[] input) use the same a0(input), just call function.
    jal encodedLength
    move $t0, $v0
    li   $v0, 0
    bgt $t0, $s2, exitRunLengthEncode
    
    li $t0, 0		# hold current letter
    li $t1, 0		# hold next letter
    li $t2, 1		# count the number of repeatition
    #lw $t4, null
    
    runLengthEncoding:
    	lw $t4, null
    	lb $t0, ($s0)
    	beq $t0, $t4, runLengthEncodingDone
    	addi $s0, $s0, 1
    	lb $t1, ($s0)
    	bne $t0, $t1, callEncodeRun
    	
    	addi $t2, $t2, 1
    	j runLengthEncoding
    	
    	callEncodeRun:
    	# t0 = letter, t2 = #repeat(runLength for encodeRun), s4(a3) = addressOfRunflag, s0 = input address
    	#addi $s0, $s0, -1 	# set the address back to the address of current t0
    	la $a0, -1($s0)
    	#addi $s0, $s0, 1	# set it to the letter after  
    	move $a1, $t2
    	
    	move $a2, $s1
    	# a3 in this function is runflag and the runflag in encodeRun is also a3. No need to change.
    	jal encodeRun 
    	beqz $v1, runLengthEncodingDone
    	li   $t2, 1	# reset t2
    	move $s1, $v0
    	# give the argument back.
    	move $a0, $s5
    	move $a1, $s6
    	move $a2, $s2
    	
    	j runLengthEncoding
    
    runLengthEncodingDone:
    	li  $v0, 1
    	lw, $t0, null
    	sb, $t0, ($s1)
    
    
    
    #--------------------------------------------------------
    exitRunLengthEncode:
    lw $ra, ($sp)
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
    


.data 
.align 2
null: .ascii "\0"
.align 2
Nine: .asciiz"9"
.align 2
Zero: .asciiz"0"
