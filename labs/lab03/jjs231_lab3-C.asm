# ==============================================================
# Author: Joshua Spisak (joshs333@live.com) (jjs231@pitt.edu)
# File: jjs231_lab2b.asm
# 
# This assembly program prints an array, inputs two indices
# from the user and sums the values at those locations.
#
# Fun stuff:
#   number of indices to input can be changed in
#     .data -> sumCount (at 2 for assignment)
#   Input bounds are checked to be in the length of the array
#
#   #x86asm_is_harder
#
# 2/05/2018
# ==============================================================
.data
	myArray: .word 0, 4, -3, 5, 2, -1, 6, 15, -8, 10
	length: .half 10
	sumCount: .half 2
	helloString: .asciiz "Hello Person! Here is an array: \n"
	newLine: .asciiz "\n"
	comma: .asciiz ", "
	startBracket: .asciiz "[ "
	endBracket: .asciiz " ]\n"
	pickStringStart: .asciiz "Pick an indice ["
	dash: .asciiz " - "
	pickStringEnd: .asciiz "]: "
	rangeError: .asciiz "Please select an integer in the following range ["
	resultString: .asciiz "Sum of values at given indices: "

.text
	j main

##
# printString
# purpose:
#  prints a string to screen
#
# inputs
#  $a0 - address of string to print
# 
# uses
#  $v0
##
printString:
	li $v0, 4
	syscall
	jr $ra

##
# printInteger
# purpose:
#  prints an integer to screen
#
# inputs
#  $a0 - address of string to print
# 
# uses
#  $v0
##	
printInteger:
	li $v0, 1
	syscall
	jr $ra

##
# printWordArray
# purpose:
#  prints an an array filled with words of a specified length to screen
#
# inputs
#  $a1 - address of first value in array
#  $a2 - length of array
#
# uses
#  $a0
#  $v0
##	
printWordArray:
	la $a0, startBracket
	li $v0, 4
	syscall
    pwa_continue:
	lw $a0, ($a1)
	li $v0, 1
	syscall
	addi $a1, $a1, 4
	subi $a2, $a2, 1
	beqz $a2, pwa_finish
	la $a0, comma
	li $v0, 4
	syscall
	j pwa_continue
    pwa_finish:
	la $a0, endBracket
	li $v0, 4
	syscall
	jr $ra

##
# getWordArrayValue
# purpose:
#  gets a value at a certain array at a specified value
#  does not protect array length
#
# inputs
#  $a1 - address of first value in array
#  $a2 - index of value 
#
# uses
#  $a3
#  $v0
##
getWordArrayValue:
	li $a3, 4
	mul $a2, $a2, $a3
	add $a1, $a1, $a2
	lw $v0, ($a1)
	move $a0, $v0
	jr $ra

##
# exit
# purpose:
#  perform code to safely exit
##	
exit:
	li  $v0, 10
	syscall
		
.globl main
main:
	# Welcome
	la $a0, helloString
	jal printString
	
	la $a1, myArray
	lh $a2, length
	jal printWordArray
	
	la $t1, myArray # array
	lh $t2, length # array length
	lh $t3, sumCount # number of indices to sample
	li $t4 0 # sum of indices
	
    pickNext:
	la $a0, pickStringStart
	jal printString

    printSelectRange:
	li $a0, 0
	jal printInteger
	
	la $a0, dash
	jal printString
	
	move $t0, $t2
	subi $t0, $t0, 1 # array length - 1
	move $a0, $t0
	jal printInteger
	
	la $a0, pickStringEnd
	jal printString
	
	li $v0, 5
	syscall
	blt $v0, $t2, check1
	j failed
    check1:
	# $v0 must past check0 and check1 to move to success, else failed
	bgez $v0, success
    failed:
	la $a0, rangeError
	jal printString
	j printSelectRange
    success:
	# get value in array
	move $a1, $t1
	move $a2, $v0
	jal getWordArrayValue
	# add value (now stored at $v0) to sum in $t4
	add $t4, $t4, $v0
        
	# decrement number of indices to sample
 	subi $t3, $t3, 1
	bgtz $t3, pickNext
        
	la $a0, resultString
	jal printString
        
	move $a0, $t4
	jal printInteger
        
	j exit
	
