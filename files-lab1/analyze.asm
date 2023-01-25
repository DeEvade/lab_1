  # analyze.asm
  # This file written 2015 by F Lundevall
  # Copyright abandoned - this file is in the public domain.

	.text
main:
	li	$s0,0x30
	addi $s2, $0, 3 	# saves 3 in $s2
loop:
	move	$a0,$s0		# copy from s0 to a0
	
	li	$v0,11		# syscall with v0 = 11 will print out
	div $s0, $s2		# Divides $s0 by 3, saves remainder in hi
	mfhi $s3		# Move From hi register, special OP.
	bne $s3, $0, skip 	# If hi (remainder) == 0, branch to skip.  
	syscall			# one byte from a0 to the Run I/O window
	
skip:
	

	addi	$s0,$s0,1	# what happens if the constant is changed?
	
	li	$t0,0x5b
	bne	$s0,$t0,loop
	nop			# delay slot filler (just in case)

stop:	j	stop		# loop forever here
	nop			# delay slot filler (just in case)

