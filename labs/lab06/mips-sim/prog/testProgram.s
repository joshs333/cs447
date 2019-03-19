
# Put a test program (of no more than 50 instructions) in here

.globl main

.text

main:

        # (12 + 20) | (12 + 17)
        addi    $t0, $zero, 12
        addi    $t1, $t0, 20
        addi    $t2, $t0, 17
        or      $t3, $t1, $t2

        # this (not MIPS) instruction will be automatically included later (no worries)
        #halt
