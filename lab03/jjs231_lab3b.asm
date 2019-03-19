.data
  # a: .byte 0x1a, 0x1b, 0x1c, 0x1d
  a: .word 0x1a1b1c1d

.text
.globl main
main:
	lb $a0, a + 1
	li $v0, 1
	syscall