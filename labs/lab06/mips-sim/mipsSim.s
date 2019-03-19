
#====================================================================
#      Static data allocation and initialization - DO NOT MODIFY!
#====================================================================

.data

# Allocate space for the simulated registers.
registers: .space 128   # 32 registers x 4 bytes/register

# Allocate space for the program to simulate.
# For simplicity, we assume it won't be more than 50 instructions.
program:   .space 200   # 50 instructions x 4 bytes/instruction

#====================================================================
#       Program text
#====================================================================

.text
.globl main

main:
	addiu $t0, $t0, 1000000000
	blt $t0, $t1, rdPgm
        # read number of instructions
        ori     $v0, $0, 5      # set up for readint syscall
        syscall                 # result will be in v0
        or      $s0, $0, $v0    # save count of number of instructions

        # loop reading instructions into simulated memory
        la $t0, program         # t0 now points at program memory

        # while (s0 > 0) read an instruction
rdPgm:  beq     $s0, $0, pgmReadDone
        ori     $v0, $0, 5      # prepare for readint call
        syscall
        sw      $v0, 0($t0)     # save instruction to program memory
        addi    $t0, $t0, 4     # increment pointer to next word of program memory
        addi    $s0, $s0, -1    # decrement count of number of instructions
        j       rdPgm

pgmReadDone:
        # initialize 0 to 0
        sw      $0, registers

        #  s0 will be the simulated PC.
        la $s0, program

        # now go into fetch/increment/decode/execute loop
        #   s0  - PC (as a pointer into program memory)
        #   t0  - IR (fetched instruction)
        #   t1  - 0x10 (literal value)
        ori     $t1, $0, 0x10   # halt opcode

fetchInst:
        lw      $t0, 0($s0)     # fetch next instruction
        addi    $s0, $s0, 4     # increment PC


        #
        #---------------- YOUR CODE START HERE ... --------------------------
        #
        bnez $t9, interp
        addi $t9, $t9, 1

        # before my idiot self realized that there were registers allocated in the data section
        # I thought I was being cool allocating it myself in the heap xD
        # we will allocate heap memory for the registers that the simulated program uses
        #li $a0, 82
        #li $v0, 9
        #syscall
        #move $s1, $v0
        # s1 = base address of virtual registers
        la $s1, registers
        j interp

# get_register_value
# get's the register at the register address given in a function
#
# Ex: a0 = 8
# 8 refers to t0
# this functions puts the value of the virtual t0 register in v0
# this also requires the base address of the virtual register segment to be in s1
get_register_value:
	# base the address to 0 fro t0 (8)
	addi $a0, $a0, 0
	#multiply by 4 because each one is 4 bytes
	mul $a0, $a0, 4
	# add to the base address of the virtual register segment
	add $a0, $a0, $s1
	# load the value there and put it in $v0
	lw $v0, ($a0)
	jr $ra

# set_register_value
#
# sets the virtual register referred to by $a0 to the value in $a1
# this requires the base address of the virtual register segment to be in s1
set_register_value:
	addi $a0, $a0, 0
	mul $a0, $a0, 4
	add $a0, $a0, $s1
	sw $a1, ($a0)

	jr $ra

interp:
        # get the opcode
        # we use t4 for this. If the program
        # branches to a j instruction it is no longer necessary
        # and is overwritten
        # if we branch to i instruction it is used
        or $t4,$zero,$t0
        srl $t4, $t4, 26

       	# i rs -> t2
    	or $t2, $zero, $t0
    	srl $t2, $t2, 21
   	and $t2, $t2, 0x1f
         # rs value -> t2
    	move $a0, $t2
    	jal get_register_value
    	move $t2, $v0
   	# i rt -> t3
   	or $t3, $zero, $t0
   	srl $t3, $t3, 16
   	and $t3, $t3, 0x1f

        # we only have j and i instructions
       	beq $t4, $zero, j_instruction
       	j i_instruction

# handles an j instruction
#
# uses $t2 - 6
# uses $a0, $a1, $v0 to call functions
# uses $a1 to get the values of executed functions
j_instruction:
	 # rt value -> t3
    	move $a0, $t3
    	jal get_register_value
    	move $t3, $v0
	# rd -> t4
   	or $t4, $zero, $t0
   	srl $t4, $t4, 11
   	and $t4, $t4, 0x1f
	# shift -> t5
   	or $t5, $zero, $t0
   	srl $t5, $t5, 6
   	and $t5, $t5, 0x1f
	# funct -> t6
   	andi $t6, $t0, 0x2f

	beq $t6, 0x25, or_instruction
	beq $t6, 0x20, add_instruction
	beq $t6, 0x22, sub_instruction
	beq $t6, 0x26, xor_instruction
	j failed_j_instruction

    # handles an or instruction
    or_instruction:
	or $a1, $t2, $t3
    	move $a0, $t4
    	jal set_register_value

    	j continue

    # handles an add instruction
    add_instruction:
    	add $a1, $t2, $t3
    	move $a0, $t4
    	jal set_register_value

	j continue

    # handles a sub instruction
    sub_instruction:
    	sub $a1, $t2, $t3
    	move $a0, $t4
    	jal set_register_value

	j continue

    # handles an xor instruction
    xor_instruction:
    	xor $a1, $t2, $t3
    	move $a0, $t4
    	jal set_register_value

	j continue

# execute when a j instruction fails because of unknown function code
failed_j_instruction:
	li $a0, 'J'
	li $v0, 11
	syscall
	li $a0, 'F'
	syscall
	li $a0, ':'
	syscall
	li $a0, ' '
	syscall
	move $a0, $t6
	li $v0, 1
	syscall
	li $a0, '\n'
	li $v0, 11
	syscall
	j finish

# handles an i instruction
#
# uses $t2 - 4
# uses $a0, $a1, $v0 to call functions
# uses $a1 to get the values of executed functions
i_instruction:
   	#i imm -> t4
   	or $t5, $zero, $t0
   	sll $t5, $t5, 16 # shift left to clear bits and make the artimetic value be in the upper registers
   	sra $t5, $t5, 16 # shift back down the arithmetic value

   	beq $t4, 0x08, addi_instruction
   	beq $t4, 0x04, beq_instruction
   	beq $t4, $t1, continue
   	j failed_i_instruction

    # performs add instruction
    addi_instruction:
	add $a1, $v0, $t5
	move $a0, $t3
	jal set_register_value

	j continue

    # performs beq instruction
    beq_instruction:
    	move $a0, $t3
    	jal get_register_value
    	bne $t2, $v0, continue
    	mul $t5, $t5, 4
    	add $s0, $s0 $t5

    	j continue

# execute when a j instruction fails because of unknown function code
failed_i_instruction:
	li $a0, 'I'
	li $v0, 11
	syscall
	li $a0, 'F'
	syscall
	li $a0, ':'
	syscall
	li $a0, ' '
	syscall
	move $a0, $t5
	li $v0, 1
	syscall
	li $a0, '\n'
	li $v0, 11
	syscall
	j finish

# carries the simulator to the next instruction
continue:
        # skeleton just looks for halt instruction
        srl     $t7, $t0, 26
        bne     $t7, $t1, fetchInst

finish:
	#
        #---------------- UP TO HERE ----------------------------------------
        #
# exitt
li $v0, 10
syscall
