.data
  x:  .byte 42
  y:  .half 42
  z:  .word 42

.text
.globl main
main:
  lb $t0, x # t0 = x
  sw $t0, x # x = t0 !?

  lh $a0, y # printHalfWord(y)
  li $v0, 1
  syscall

  li $v0, 10     # exit() - stops the program
  syscall