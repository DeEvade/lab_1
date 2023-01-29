  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "A bunch of text\0"
	.text
main:
	# print timstr
	
	la	$a0, timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,1000
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
  
hexasc:
	andi $t1, $a3, 15 #Clears all bits except 0-3
	addi $t2, $t1, 0x30 #Adds 0x30 to convert to ASCII (0x30 is char 0)
	bltu $t1, 10, skip #If t1 smaller than 10, we dont need to do any more changes. skips
	addi $t2, $t2, 7 #Here its larger than 10, we need to convert to letters, We do this by adding 7
	skip: 
	move $v0, $t2 #Value of $v0 is set to value of $t2
	jr $ra #return (jump to return address)
	nop
	
delay:
	PUSH $t0
	PUSH $t1
	PUSH $t2
	
	li $t0, 400 #Amount of itterations in for loop, change until it takes 1ms

	addi $t2, $a0, 0 #Amount of ms
	
	loop: #While loop
	
	ble $t2, $0, stop #Stops the while loop if ms is less than or equal to 0, works for negative values of $a0
	subi $t2, $t2, 1 # subtracts 1
	li $t1, 0 #For loop counter, int i;
	forLoop:
	bge $t1, $t0, stopForLoop #Stops for loop if $t1 >= $t0 (i >= 4711)
	addi $t1, $t1, 1 #i = i + 1;
	 #Do nothing
	 
	j forLoop
	nop
	stopForLoop:

	j loop
	nop
	stop:


	POP $t2
	POP $t1
	POP $t0
	
	
	jr $ra
  	nop
	
time2string: 
	PUSH $ra
	PUSH $v0
	andi $t4, $t4, 0 #init t4
	andi $t5, $0, 0
	PUSH $t4 #Save the cleared t4

	andi $t4, $a1, 0xf #set t4 to 4 LSB of a1. (least significant digit for seconds)
	move $a3, $t4 #Set arguent value a3 used in hexasc to value of t4
	jal hexasc
	sll $t4, $v0, 0 #Nothing
	or $t5, $t4, $t5
	sw $t5, 4($a0)
	POP $t4 #Recover a cleared t4
	
	
	
	
	andi $t5, $t5, 0 #Sets t5 to 0
	PUSH $t4 #Save the cleared t4
	srl $t4, $a1, 4
	andi $t4, $t4, 0xf
	move $a3, $t4
	jal hexasc
	sll $t4, $v0, 24
	or $t5, $t5, $t4 #Adds t4 to t5
	addi $t6, $0, 0x003a0000
	or $t5, $t5, $t6 #Adds semicolon
	POP $t4 #Recover a cleared t4
	
	
	PUSH $t4 #Save the cleared t4
	srl $t4 $a1, 8
	andi $t4, $t4, 0xf
	move $a3, $t4
	jal hexasc
	sll $t4, $v0, 8
	or $t5, $t5, $t4 #Adds t4 to t5
	POP $t4 #Recover a cleared t4

	
	PUSH $t4 #Save the cleared t4
	srl $t4 $a1, 12
	andi $t4, $t4, 0xf
	move $a3, $t4
	jal hexasc
	sll $t4, $v0, 0
	or $t5, $t5, $t4 #Adds t4 to t5
	POP $t4 #Recover a cleared t4
	sw $t5, ($a0)
	
	POP $v0
	POP $ra
	jr $ra
	nop
	
	
