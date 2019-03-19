# Put a test program (of no more than 50 instructions) in here

.globl main

.text

main:
        # (12 + 20) | (12 + 17)
        addi    $t0, $zero, 48
bob:
        addi    $t1, $t1, 12
        beq     $t1, $t0, ahead
        beq     $zero, $zero, bob
ahead:
        addi    $t3, $t0, 17

        # this (not MIPS) instruction will be automatically included later (no worries)
        #halt
