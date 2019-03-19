main:
	lui	$a0,0x8000	# should be 31
	jal	first1pos
	jal	printv0
	lui	$a0,0x0001	# should be 16
	jal	first1pos
	jal	printv0
	li	$a0,1		# should be 0
	jal	first1pos
	jal	printv0
	add	$a0,$0,$0
	jal	first1pos
	jal	printv0
	li	$v0,10
	syscall


first1pos:	# placeholder to call different versions: first1posshift of first1posmask
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	jal first1posshift
        
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra


first1posshift:
	li $v0, -1
    try_again:
	beqz $a0, finished
	srl $a0, $a0, 1
	addi $v0, $v0, 1
	j try_again
    finished:
        jr $ra


first1posmask:
	li $v0, 31
	lui $t1, 0x8000
    try_again2:
	move $a1, $a0
	xor $a1, $a0, $t1
	beqz $a1, finished2
	srl $t1, $t1, 1
	addi $v0, $v0, -1
	j try_again2
    finished2:
	jr $ra

printv0:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	add	$a0,$v0,$0
	li	$v0,1
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra
