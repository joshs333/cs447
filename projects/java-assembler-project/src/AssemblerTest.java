
import org.junit.Test;

import java.util.LinkedList;
import java.util.List;

import static org.junit.Assert.*;

public class AssemblerTest {

    /*
        Complete Test List
        addiu normal
        addiu pseudo
        addu - yes test 1
        or - yes test 2
        beq - tested with blt
        bne - tested with bge
        slt - tested with blt/bge
        lui - tested with addiu
        ori - yes test 2
        ori pseudo - yes test 2
        blt - test 2 (tested forward/reverse branch)
        bge - test 3

        all tested
    */
        private static int MARS_TEXT_SEGMENT_START = 0x00400000;

        private static void testHelper(List<Instruction> input, Instruction[] expectedP1, Instruction[] expectedP2, Integer[] expectedP3) {
            // Phase 1
            List<Instruction> tals = Phase1.mal_to_tal(input);
            assertArrayEquals(expectedP1, tals.toArray());

            // Phase 2
            List<Instruction> resolved_tals = Phase2.resolve_addresses(tals, MARS_TEXT_SEGMENT_START);
            assertArrayEquals(expectedP2, resolved_tals.toArray());

            // Phase 3
            List<Integer> translated = Phase3.translate_instructions(resolved_tals);
            assertArrayEquals(expectedP3, translated.toArray());
        }

        @Test
        public void test1() {
            // test 1
            List<Instruction> input = new LinkedList<Instruction>();
            // label1: addu $t0, $zero, $zero
            input.add(new Instruction(2, 8, 0, 0, 0, 0, 0, 1, 0));
            // addu $s0, $s7, $t4
            input.add(new Instruction(2,16,23,12,0,0,0,0,0));
            // blt  $s0,$t0,label1
            input.add(new Instruction(100,0,16,8,0,0,0,0,1));
            // addiu $s1,$s2,0xF00000
            input.add(new Instruction(1, 0, 18, 17, 0xF00000, 0, 0, 0, 0));

            // Phase 1
            Instruction[] phase1_expected = {
                    new Instruction(2,8,0,0,0,0,0,1,0), // label1: addu $t0, $zero, $zero
                    new Instruction(2, 16, 23,12,0,0,0,0,0), // addu $s0, $s7, $t4
                    new Instruction(8, 1,16,8,0,0,0,0,0),  // slt $at,$s0,$t0
                    new Instruction(6, 0,1,0,0,0,0,0,1),     // bne $at,$zero,label1
                    new Instruction(9, 0,0,1,0x00F0,0,0,0,0), // lui $at, 0x00F0
                    new Instruction(10,0,1,1,0x0000,0,0,0,0), // ori $at, $at 0x0000
                    new Instruction(2,17,18,1,0,0,0,0,0) // addu $s1,$s2,$at
            };

            // Phase 2
            Instruction[] phase2_expected = {
                    new Instruction(2,8,0,0,0,0,0,1,0),
                    new Instruction(2,16,23,12,0,0,0,0,0),
                    new Instruction(8,1,16,8,0,0,0,0,0),
                    new Instruction(6,0,1,0,0xfffffffc,0,0,0,1),
                    new Instruction(9,0,0,1,0x00F0,0,0,0,0),
                    new Instruction(10,0,1,1,0x0000,0,0,0,0),
                    new Instruction(2,17,18,1,0,0,0,0,0)
            };

            // Phase 3
            Integer[] phase3_expected = {
                    // HINT: to get these, type the input program into MARS, assemble, and copy the binary values into your test case
                    0x00004021,
                    0x02ec8021,
                    0x0208082a,
                    0x1420fffc,
                    0x3c0100f0,
                    0x34210000,
                    0x02418821
            };


            testHelper(input,
                    phase1_expected,
                    phase2_expected,
                    phase3_expected);
        }

        @Test
        public void test2() {
            /* Fill in your additional test case here! */
            List<Instruction> my_input = new LinkedList<Instruction>();
            //ori $t1, $zero, 0
            my_input.add(new Instruction(10, 0, 0, 9, 0, 0, 0, 0, 0));
            // ori $t9, $t9, 20
            my_input.add(new Instruction(10, 0, 25, 25, 20, 0, 0, 0, 0));
            // label1:
            // addiu $t2, $t2, 10
            my_input.add(new Instruction(1, 0, 10, 10, 10, 0, 0, 1, 0));
            // or $t2, $zero, $t2
            my_input.add(new Instruction(3, 10, 0, 10, 0, 0, 0, 0, 0));
            // ori $t3, $t3, 0xf0000
            my_input.add(new Instruction(10, 0, 11, 11, 0xf0001, 0, 0, 0, 0));
            // addiu $t1, $t1, 1
            my_input.add(new Instruction(1, 0, 9, 9, 1, 0, 0, 0, 0));
            // blt $t1, $t9, label1
            my_input.add(new Instruction(100, 0, 9, 25, 0, 0, 0, 0, 1));
            // bge $t1, $t9, label2
            my_input.add(new Instruction(101, 0, 9, 25, 0, 0, 0, 0, 2));
            // label2:
            // lui $t2, 0x10
            my_input.add(new Instruction(9, 0, 0, 10, 0x10, 0, 0, 2, 0));

            Instruction[] my_phase1_expected = {
                new Instruction(10, 0, 0, 9, 0, 0, 0, 0, 0),
                new Instruction(10, 0, 25, 25, 20, 0, 0, 0, 0),
                new Instruction(1, 0, 10, 10, 10, 0, 0, 1, 0),
                new Instruction(3, 10, 0, 10, 0, 0, 0, 0, 0),
                new Instruction(9, 0, 0, 1, 0x0000000f, 0, 0, 0, 0),
                new Instruction(10, 0, 1, 1, 0x0001, 0, 0, 0, 0),
                new Instruction(3, 11, 11, 1, 0, 0, 0, 0, 0),
                new Instruction(1, 0, 9, 9, 1, 0, 0, 0, 0),
                new Instruction(8, 1, 9, 25, 0, 0, 0, 0, 0),
                new Instruction(6, 0, 1, 0, 0, 0, 0, 0, 1),
                new Instruction(8, 1, 9, 25, 0, 0, 0, 0, 0),
                new Instruction(5, 0, 1, 0, 0, 0, 0, 0, 2),
                new Instruction(9, 0, 0, 10, 0x10, 0, 0, 2, 0)
            };

            Instruction[] my_phase2_expected = {
                new Instruction(10, 0, 0, 9, 0, 0, 0, 0, 0),
                new Instruction(10, 0, 25, 25, 20, 0, 0, 0, 0),
                new Instruction(1, 0, 10, 10, 10, 0, 0, 1, 0),
                new Instruction(3, 10, 0, 10, 0, 0, 0, 0, 0),
                new Instruction(9, 0, 0, 1, 0x0000000f, 0, 0, 0, 0),
                new Instruction(10, 0, 1, 1, 0x0001, 0, 0, 0, 0),
                new Instruction(3, 11, 11, 1, 0, 0, 0, 0, 0),
                new Instruction(1, 0, 9, 9, 1, 0, 0, 0, 0),
                new Instruction(8, 1, 9, 25, 0, 0, 0, 0, 0),
                new Instruction(6, 0, 1, 0, -8, 0, 0, 0, 1),
                new Instruction(8, 1, 9, 25, 0, 0, 0, 0, 0),
                new Instruction(5, 0, 1, 0, 0, 0, 0, 0, 2),
                new Instruction(9, 0, 0, 10, 0x10, 0, 0, 2, 0)
            };

            Integer[] my_phase3_expected = {
                0x34090000,
                0x37390014,
                0x254a000a,
                0x000a5025,
                0x3c01000f,
                0x34210001,
                0x01615825,
                0x25290001,
                0x0139082a,
                0x1420fff8,
                0x0139082a,
                0x10200000,
                0x3c0a0010
            };

            testHelper(my_input,
                    my_phase1_expected,
                    my_phase2_expected,
                    my_phase3_expected);
        }
}
