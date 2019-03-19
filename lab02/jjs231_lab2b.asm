# ==============================================================
# Author: Joshua Spisak (joshs333@live.com) (jjs231@pitt.edu)
# File: jjs231_lab2b.asm
# 
# This assembly program inputs two numbers (a, b) and subtracts
# b from a (-> c) and then prints c.
#
# 1/28/2018
# ==============================================================
.data
  str1: .asciiz "What is the first input?\n"
  str2: .asciiz "What is the second input?\n"
  minus: .asciiz " - "
  equals: .asciiz " = "

  # First Input
  a:   .word 0
  b:   .word 0
  c:   .word 0
  all1: .word 0xFFFFFFFF

.text
	# jump over functions to main
	j main
 
# defining syscalls as callable functions
# helps track code through interpretable tags
# instead of values sent to $v0
quit:
	li $v0, 10
	syscall
	
printstr:
	li $v0, 4
  	syscall
  	jr $ra
  	
getint:
	li $v0, 5
	syscall
	jr $ra

newline:
	li $v0, 11
	li $a0, '\n'
	syscall
	jr $ra
	
printint:
	li $v0, 1 
	syscall
	jr $ra
	
# main program flow
.globl main
main:
	# get int a
	la $a0, str1
	jal printstr

	jal getint
	sw $v0, a
	
	# get int b
	la $a0, str2
	jal printstr

	jal getint
	sw $v0, b

	# do math
	move $t0, $zero # zero $t0/$t1 because why not
	move $t1, $zero
	lw $t0, a # i would have preferred using $t0 / $t1 instead of a/b/c but lab requirements :P
	lw $t1, b
	neg $t1, $t1
	# alternatively since we know it's 2's complement signed
	# lw $t2, all1 // using xor against all ones (FF FF FF FFh)
	# xor $t1, $t1, $t2 // does a bit flip
	# addi $t1, $t1, 1 // add one
	add $t0, $t0, $t1
	sw $t0,c
	
	# print results
	lw $a0, a
	jal printint
	
	la $a0, minus
	jal printstr
	
	lw $a0, b
	jal printint
	
	la $a0, equals
	jal printstr
	
	lw $a0, c
	jal printint

	j quit