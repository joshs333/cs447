.text
	ori $t1, $zero, 0
	ori $t9, $t9, 20
label1:
	addiu $t2, $t2, 10
	or $t2, $zero, $t2
	ori $t3, $t3, 0xf0001
	
	addiu $t1, $t1, 1
	blt $t1, $t9, label1
	bge $t1, $t9, label2

label2:
	lui $t2, 0x10
