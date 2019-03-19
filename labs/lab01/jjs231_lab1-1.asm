# Joshua Spisak (jjs231)
# hi!
.globl main   # <--- There is no "a" in globl!!!!!
main:
	li $a0, 0x4321
	li $v0, 1
	syscall