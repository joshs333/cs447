.data
	x: .word 0xB357C0DE
	
.text
.globl main
main:
	lw $t0, x
	addi $t0, $t0, 1
	sw $t0, x
	
# A.1: 65536 unique values
# A.2: -32768 to 32767
# A.3: 32 bits (4 bytes.. kinda weird for a word)
# A.4: load upper immediate: loads the little-endian formatted addres of x into $1
#      load word: loads the data at the address in $1 into $8
# A.5: 3C011001h (0011 1100 0000 0001 0001 0000 0000 0001b)
#      8C280000h (1000 1100 0010 1000 0000 0000 0000 0000b)
#
