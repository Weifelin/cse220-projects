# Homework #1 
# Name: Weifeng Lin
# SBUID: 110161112 

.data
.align 2
numargs: .word 0
arg1: .word 0
arg2: .word 0
arg3: .word 0
Err_string: .asciiz "ARGUMENT ERROR" 

.align 2
A_string: .asciiz"A"
.align 2
a_string: .asciiz"a"
.align 2
R_string: .asciiz"R"
.align 2
r_string: .asciiz"r"
.align 2
Part2_string: .asciiz"ARG2: "
.align 2
Part3_string: .asciiz"ARG3: "
.align 2
Space_string: .asciiz" "
.align 2
Hamming: .asciiz"Hamming Distance: "
.align 2
New_Line: .asciiz"\n"
.align 2
Nine: .asciiz"9"
.align 2
Zero: .asciiz"0"
.align 2
LastValue: .asciiz "Last value drawn: "
.align 2
TotalValue: .asciiz "Total values: "
.align 2
Even: .asciiz "# of Even: "
.align 2
Odd: .asciiz "# of Odd: "
.align 2
Powers: .asciiz "Power of 2: "
.align 2
MultTwo: .asciiz "Multiple of 2: "
.align 2
MultFour: .asciiz "Multiple of 4: "
.align 2
MultEight: .asciiz "Multiple of 8: "
.align 2
null: .ascii "\0"

	

# Helper macro for grabbing command line arguments
.macro load_args
sw $a0, numargs
lw $t0, 0($a1)
sw $t0, arg1
lw $t0, 4($a1)
sw $t0, arg2
lw $t0, 8($a1)
sw $t0, arg3
.end_macro

.text
.globl main

main:
	load_args()
	
# Dertermine the number of argument
lw $t0, numargs
lw $t1, arg1
beq $0, $t1, add_numargs
lw $t1, arg2
beq $0, $t1, add_numargs
lw $t1, arg3
beq $0, $t1, add_numargs
sw $t0, numargs

add_numargs:
	addi $t0, $t0, 1

	
#Check if the first argument is only one character
#la  $t0, arg1
#addi $t0, $t0, 2 #t0 now contain the address
#lb $t1, ($t0)
#move $t0, $t1
lw $t0, arg1
lb $t1, 1($t0)
bne $t1, $0, Err_exit


#Check if the first argument match A/a or R/r, if it matches either one, jump to respective part.
lw $t0, arg1 #load the pointer to arg1.
lb $t0, 0($t0)
lw $t1, A_string
beq $t0, $t1, Output_2  #can use "A" directly (Primitive values)
lw $t1, a_string
beq $t0, $t1, Output_2
lw $t1, R_string
beq $t0, $t1, Output_3
lw $t1, r_string
beq $t0, $t1, Output_3
j Err_exit

#exit
	li $v0, 10
	syscall

	
	
	


	
Err_exit:
	# Pring Err String
	li $v0, 4
	la $a0, Err_string
	syscall
	# Exit
	li $v0, 10
	syscall

Output_2:
	#Check numargs
	lw $t1, numargs
	bne $t1, 3, Err_exit
	
	#Print "ARG2: "
	li $v0, 4
	la $a0, Part2_string
	syscall
	
	#Organize the argument2 to the order of from left to right
	lw  $s0, arg2
	lb $t0, 0($s0)    #a
	lb $t1, 1($s0)    #b
#	sll $s0 $s0 24
	lb $t2, 2($s0)    #c
#	sll $s1, $s1 16
#	sll $s2, $s2 8
	lb $t3, 3($s0)    #d
	sll $t1, $t1, 8
	sll $t2, $t2, 16
	sll $t3, $t3, 24

	move $s1, $0
	add $s1, $t0, $t1
	add $s1, $s1, $t2
	add $s1, $s1, $t3 #s1 contains 4 characters of arg2
	
	li $v0, 35
	move $a0, $s1
	syscall

	
	#Print Space
	li $v0, 4
	la  $a0, Space_string
	syscall
	
	#Print in 0xHex
	li $v0, 34
	move $a0, $s1
	syscall
	
	#Print Space
	li $v0, 4
	la  $a0, Space_string
	syscall
	
	#Print in Two's Complement
	li $v0, 1
	move $a0, $s1
	syscall
	
	#Print Space
	li $v0, 4
	la  $a0, Space_string
	syscall
	
	#Print in One's Complement/ Only avaliable for CSE220 MARS
	li $v0, 100
	move $a0, $s1
	syscall
	
	#Print Space
	li $v0, 4
	la  $a0, Space_string
	syscall
	
	#Print in Signed_Magnitude/ Only avaliable for CSE220 MARS
	li $v0, 101
	move $a0, $s1
	syscall
	
	#Print New Line
	li $v0, 4
	la  $a0, New_Line
	syscall
	
	
#Output_3:
	#Check numargs
	#lw $t1, numargs
	#bne $t1, 3, Err_exit
	#Print "ARG3: " and arg1
	li $v0, 4
	la $a0, Part3_string
	syscall
	
	#Organize the argument3 to the order of from left to right
	lw  $s0, arg3
	lb $t0, 0($s0)
	lb $t1, 1($s0)
#	sll $s0 $s0 24
	lb $t2, 2($s0)
#	sll $s1, $s1 16
#	sll $s2, $s2 8
	lb $t3, 3($s0)
#	sll $s3, $s3 32
	sll $t1, $t1, 8
	sll $t2, $t2, 16
	sll $t3, $t3, 24
	move $s2, $0
	add $s2, $t0, $t1
	add $s2, $s2, $t2
	add $s2, $s2, $t3  #s2 contain the 4 characters of arg3
	
	li $v0, 35
	move $a0, $s2
	syscall

	
	#Print Space
	li $v0, 4
	la  $a0, Space_string
	syscall
	
	#Print in 0xHex
	li $v0, 34
	move $a0, $s2
	syscall
	
	#Print Space
	li $v0, 4
	la  $a0, Space_string
	syscall
	
	#Print in Two's Complement
	li $v0, 1
	move $a0, $s2
	syscall
	
	#Print Space
	li $v0, 4
	la  $a0, Space_string
	syscall
	
	#Print in One's Complement/ Only avaliable for CSE220 MARS
	li $v0, 100
	move $a0, $s2
	syscall
	
	#Print Space
	li $v0, 4
	la  $a0, Space_string
	syscall
	
	#Print in Signed_Magnitude/ Only avaliable for CSE220 MARS
	li $v0, 101
	move $a0, $s2
	syscall
	
	#Print New Line
	li $v0, 4
	la  $a0, New_Line
	syscall
	
	#s1 = arg2, s2 = arg3, s3 = counter, t0 = position, t2 = 32
	# Find the difference between arg2 and arg3 and store the difference as 1 in new register
	xor $t1, $s1, $s2   # t1 is the differences of s1 and s2
	move $t0, $0
	li $t2 32
	move $s3, $0
	move $t3, $0
	while: 
		beq $t0, $t2, don
		#lb  $t3, 0($t1)
		andi $t3, $t1, 1	#keep the righmost bit in t3
		add $s3, $s3, $t3
		srl $t1, $t1, 1
		addi $t0, $t0, 1
		j while
	
	don:
	li $v0, 4
	la $a0, Hamming
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	
	#Print New Line
#	li $v0, 4
#	la  $a0, New_Line
#	syscall
	
	#Exit
	li $v0, 10
	syscall

	

Output_3:
	# Check if there are only 2 arguments
	lw $t1, numargs
	bne $t1, 2, Err_exit
	
	
	lw $s1, arg2	#it load address of arg2, if use la, that could load address of the address in memory that stores strings but not the address of args
#	lb $s1, arg2
	li $t1, 0 # counter index
	lw $t2, null # t2 store null
	move $t3, $0 #last bit of agr2
	li $t4, 10 
	lw $t5, Zero
	lw $t6, Nine
	
	length:
#		andi $t3, $s1, 255
		lb $t3, 0($s1)
		lb $t3, ($s1)
		beq $t3, $t2, lengthDone
#		andi $t3, $s1, 255
		blt $t3, $t5, lengthDone
		bgt $t3, $t6, lengthDone
		sub $t0, $t3, $t5    #t0 will store the real number
		mul $s0, $s0, $t4	#s0=s0*10
		add $s0, $s0, $t0
		addi $s1, $s1, 1
#		srl $s1, $s1, 8
		j length
		
		
		
	lengthDone:
	
#------------------------------------------------------------	
	
#	li $t0, 0
#	li $t1, 0
#	li $t2, 0
#	li $t3, 0
#	Restore arg2 as an Binary
###	lw  $s1, arg2
###	lb $t0, 0($s1)    #a t0 contain ascii of rightmost byte
#	bltz $t0, roll
#	addi $t0, $t0, -48
	
###	lb $t1, 1($s1)    #b
#	bltz $t1, roll 
#	addi $t1, $t1, -48
#	sll $s0 $s0 24
###	lb $t2, 2($s1)    #c
#	bltz $t1, roll 
#	addi $t2, $t2, -48
#	sll $s1, $s1 16
#	sll $s2, $s2 8
###	lb $t3, 3($s1)    #d
#	bltz $t1, roll 
#	addi $t3, $t3, -48
	
###	sll $t1, $t1, 8
###	sll $t2, $t2, 16
###	sll $t3, $t3, 24
	
#	roll:
###	add $s1, $t0, $t1
###	add $s1, $s1, $t2
###	add $s1, $s1, $t3 #s1 contains 4 characters of arg2
	
#	li $v0, 35
#	move $a0, $s1
#	syscall

	#var sum = 0
	#Convert every character until the end of the string is reached or an invaild string is reached.
	# for each character in the input:
	#	if character >= '0' and character <= '9'
	#		sum = (sum * 10) + (char - '0')
	#	else
	#		break
	
	# s0 = sum, t1 = position, s1 = arg2, t2 = 32, t3 = char, t4 = 10, t5 = '0', t6 = '9'

	
###	li $t1, 0
###	li $t2, 32
###	li $t4, 10
###	lw $t5, Zero
###	lw $t6, Nine
###	move $s0, $0
###	move $t3, $0
	
	
	
###	when:
###		beq $t1, $t2, quitw
#		lb $t3, ($s1)
###		andi $t3, $s1, 255   #255 in binary is 1111 1111
#		beqz $t3, roll
#		addi $t3, $t3, -48
		
#		roll:
#		beqz $t3, roll
#		addi $t3, $t3, 0
		
		
#		roll:
###		blt $t3, $t5, quitw
###		addi $t3, $t3, 0   #test
###		bgt $t3, $t6, quitw
###		addi $t1, $t1, 1
###		mul $s0, $s0, $t4  #s0 = s0*10
###		sub $t3, $t3, $t5
###		add $s0, $s0, $t3
		

###		j when
		
###	quitw:
#		li $v0, 1
#		move $a0, $s0
#		syscall
		

	# binary form of arg2 is stored in s1, and the number part of it as two's complement is stored in s0.
	
	#Set the seed for random number generator
	
#---------------------------------------------------------------------------------------
	
	#s0 = Last value draw, s1 = total values(The number of values that are drawn)
	#s2 = the number of even number, s3 = # of odd number, s4 = power of 2, s5 = multiple of 4
	#s6 = multiple of 8
	#t0 = 0's or 1's in the binary form of generated number., $t1 = position for counting. $t2 = 32 for counting, t3 = char
	#t4 = temp to store s0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s5, 0
	
	li $t0, 0
	li $t1, 0
	li $t2, 32
	li $t5, 0 # for nor
	li $t6, 0
	li $t7, 1
	
	li $v0, 40
	li $a0, 0
	move $a1, $s0
	syscall

	
	while_loop:
#		li $a0, 0 # FFFFFFF
		li $v0, 42
		li $a1, 1024
		syscall
		addi $a0, $a0, 1
		
		move $s0, $a0
		
#		move $s0, $a0
#		move $t4, $s0
		move $t4, $s0
		# The number of rightmost 0's represent if the number is multiples of 2/4/8. 
		count_zero: 
			beq $t1, $t2, back
			addi $t3, $t3, 0
			andi $t3, $t4, 1
			bnez $t3, back
			srl $t4, $t4, 0
			srl $t4, $t4, 1
			addi $t0, $t0, 1 #t0 is the number of zeros that in the rightmost bits 
			addi $t1, $t1, 1
			
#			beq $t1, $t2, back
#			andi $t3, $t4, 0
#			andi $t3, $t4, 1
#			bnez $t3, back
#			srl $t4, $t4, 0
#			srl $t4, $t4, 1
#			nor $t6, $t3, $t5
#			add $t0, $t0, $t6  #t0 is the number of zeros that in the rightmost bits 
#			addi $t1, $t1, 1
			
			j count_zero
			
		back:
		blt $t0, 3, next
		addi $s6, $s6, 0
		# if t0 >= 3, do following
		addi $s6, $s6, 1
		addi $s5, $s5, 1
		addi $s2, $s2, 1
		j nextiii
#		j conti
		next:
		blt $t0, 2, nexti
#		bne $t0, 2, nexti
		# if  t0 >= 2 and t0 < 3
		addi $s5, $s5, 0
		addi $s5, $s5, 1
		addi $s2, $s2, 1
		j nextiii
#		j conti
		
		nexti:	
		blt $t0, 1, nextii
#		blt $t0, 1, nextiii
#		bne $t0, 1, nextii
		addi $s2, $s2, 0
		# if t0 < 2 and t0 >= 1
		addi $s2, $s2, 1
		j nextiii
		
		nextii:
		bnez $t0, nextiii
#		blt $t0, 0, nextiii
		addi $s3, $s3, 0
		# if t0 = 0
		addi $s3, $s3, 1
		
		nextiii:
		
#		move $t4, $a0
#		andi $t3, $t4, 1
#		bne $t3, $t7, conti #$t7 is 1
#		addi $s3, $s3, 1
		
		
		
#		conti:
		# reset the position to 0, and t0 to 0
		li $t1, 0
		li $t0, 0
		
		# the power of 2 in binary has only one 1.
		move $t4, $s0
		
		count_one:
			beq $t1, $t2, backi
			andi $t3, $t4, 0
			andi $t3, $t4, 1
			add $t0, $t0, $t3
#			bne $t3, 1, nextone
#			addi $t0, $t0, 0
#			addi $t0, $t0, 1
#			nextone:
#			srl $t4, $t4, 0
			srl $t4, $t4, 1
			addi $t1, $t1, 1
			j count_one
		
		backi:
		bne $t0, 1, continue
		addi $s4, $s4, 0
		addi $s4, $s4, 1
		continue:

		addi $s1, $s1, 0
		addi $s1, $s1, 1
		
#		beq $s0, 1, done
#		beq $s0, 2, done
#		beq $s0, 4, done
#		beq $s0, 8, done
#		beq $s0, 16, done
#		beq $s0, 32, done
		
		
		
		beq $a0, 1, done
		beq $a0, 2, done
		beq $a0, 4, done
		beq $a0, 8, done
		beq $a0, 16, done
		beq $a0, 32, done
		

		li $a0, 0
		li $t1, 0
		li $t0, 0
		
		j while_loop
		
		
		
	done:
		#Print last value

		li $v0, 4
		la $a0, LastValue
		syscall 
		li $v0, 1
		move $a0, $s0
		syscall
		
		#Print New Line
		li $v0, 4
		la  $a0, New_Line
		syscall
		
		# Print total numbers that have been generated
		li $v0, 4
		la $a0, TotalValue
		syscall 
		li $v0, 1
		move $a0, $s1
		syscall
		
		#Print New Line
		li $v0, 4
		la  $a0, New_Line
		syscall
		
		# Print the number of evens
		li $v0, 4
		la $a0, Even
		syscall 
		li $v0, 1
		move $a0, $s2
		syscall
		
		#Print New Line
		li $v0, 4
		la  $a0, New_Line
		syscall
		
		# Print the number of odds
		li $v0, 4
		la $a0, Odd
		syscall 
		li $v0, 1
		move $a0, $s3
		syscall
		
		#Print New Line
		li $v0, 4
		la  $a0, New_Line
		syscall
		
		# Print the number of 2's power
		li $v0, 4
		la $a0, Powers
		syscall 
		li $v0, 1
		move $a0, $s4
		syscall
		
		#Print New Line
		li $v0, 4
		la  $a0, New_Line
		syscall
		
		# Print the number of 2's multiples
		li $v0, 4
		la $a0, MultTwo
		syscall 
		li $v0, 1
		move $a0, $s2
		syscall
		
		#Print New Line
		li $v0, 4
		la  $a0, New_Line
		syscall
		
		# Print the number of 4's multiples
		li $v0, 4
		la $a0, MultFour
		syscall 
		li $v0, 1
		move $a0, $s5
		syscall
		
		#Print New Line
		li $v0, 4
		la  $a0, New_Line
		syscall
		
		# Print the number of 8's multiples
		li $v0, 4
		la $a0, MultEight
		syscall 
		li $v0, 1
		move $a0, $s6
		syscall
		
		
	
		
				
	#Exit
	li $v0, 10
	syscall

	
	
