  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,16		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #
hexasc:
	 # Ska & 0xf med a0 för att endast få 4 lsb
	#addi $t3, $ra, 0
	add $t0, $a0, $0
	
	#add $v0, $a0, $0
	andi $t0, 0x0f
	addi $t1, $t0, 0x30
	bge $t0, 10, chars
	add $v0, $t1, $0
	jr $ra
chars:	
	addi $t2, $t1, 7
	add $v0, $t2, $0
	#add $a0, $0, $t0
	#addi $ra, $t3, 0
	jr $ra
	