.text
	j    top_of_loop
	
sleep_500_ms:	
	addi $v0, $zero, 32
	addi $a0, $zero, 500
	syscall # sleep 500ms
	jr $ra

top_of_loop:	
	addi $t9, $zero, 0
	jal sleep_500_ms
	
	addi $t9, $t9, 179		
	jal sleep_500_ms
	
	addi $t9, $t9, -293
	jal sleep_500_ms
	
	addi $t9, $t9, 561
	jal sleep_500_ms
	
	j	top_of_loop
	