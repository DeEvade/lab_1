  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0, 16	# change this to test different values

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
	andi $t1, $a0, 15 #Clears all bits except 0-3
	addi $t2, $t1, 0x30 #Adds 0x30 to convert to ASCII (0x30 is char 0)
	
	bltu $t1, 10, skip #If t1 smaller than 10, we dont need to do any more changes. skips
	addi $t2, $t2, 7 #Here its larger than 10, we need to convert to letters, We do this by adding 7
skip: 
	move $v0, $t2 #Value of $v0 is set to value of $t2
	jr $ra #return (jump to return address)
	
