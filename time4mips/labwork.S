  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #
  # Please keep the two macros PUSH and POP unchanged
  #

.global delay
.global time2string

.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
  #
  # Please add your own code below this line
  #

hexasc:
	 # Ska & 0xf med a0 för att endast få 4 lsb
	add $t0, $a3, $0
	andi $t0, 0x0f
	addi $t1, $t0, 0x30
	bge $t0, 10, chars
	add $v0, $t1, $0
	jr $ra
	nop
	chars:	
	addi $t2, $t1, 7
	add $v0, $t2, $0
	jr $ra
	nop
	
delay: # $a2 input till func, t1 = i. 
	PUSH $ra
	# addi $a2, $0, 0
	addi $t0, $a0, 0
while:
	beq $t0, $0, exit
	addi $t0, $t0, -1
	li $t1, 0
	j forLoop
	nop
forLoop: 
	bge $t1, 4475, while
	addi $t1, $t1, 1
	j forLoop
	
 exit:
  	POP $ra
  	jr $ra
  	nop
  
time2string:
	
	PUSH $ra



	andi $t1, $a1, 0xf000 # First digit 0000..... 1111 0000 0000 0000
	srl $a3, $t1, 12 
	jal hexasc
	nop
	move $t4, $v0
	#sll $t4, $v0, 16      # Ends up at 0000.... 1111 0000 0000 0000 0000
	
	andi $t2, $a1, 0xf00 # First digit 0000..... 0000 1111 0000 0000
	srl $a3, $t2, 8
	jal hexasc
	nop
	move $t5, $v0
	#sll $t5, $v0, 12      # Ends up at 0000.... 0000 1111 0000 0000 0000 
	
	andi $t3, $a1, 0xf0 # First digit 0000..... 0000 0000 1111 0000
	srl $a3, $t3, 4
	jal hexasc
	nop
	move $t6, $v0
	#sll $t6, $v0, 4      # Ends up at 0000.... 0000 0000 0000 1111 0000
	
	andi $a3, $a1, 0xf # First digit 0000..... 0000 0000 0000 1111
	jal hexasc
	nop
	move $t7, $v0    # Ends up at 0000.... 0000 0000 0000 0000 1111
	
	addi $t8, $0, 0x3a    # :

	sb $0, 5($a0) # Clearing $a0 Eller nullbyten är det väl kanske?
	sb $t4, 0($a0) # 10:00
	sb $t5, 1($a0) # 01:00
	sb $t8, 2($a0) # :
	sb $t6, 3($a0) # 00:10
	sb $t7, 4($a0) # 00:01

	POP $ra
	
	jr $ra
	nop
