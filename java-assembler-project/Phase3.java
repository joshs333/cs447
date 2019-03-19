
import java.util.LinkedList;
import java.util.ArrayList;
import java.util.List;
import java.io.*; /* Exception */

public class Phase3 {
    // instructions to return
    private static List<Integer> numbers;

    /* Translate each Instruction object into
     * a 32-bit number.
     *
     * tals: list of Instructions to translate
     *
     * returns a list of instructions in their 32-bit binary representation
     *
     */
    public static List<Integer> translate_instructions(List<Instruction> tals) {
        numbers = new ArrayList<Integer>();
        
        for(Instruction line : tals) {
            translate(line);
        }
        return numbers;
    }

    // translate individual instructions
    private static void translate(Instruction line) {
        // switch by instruction ID
        // we translate the instruction ID to function/OPCode here, since we
        // are switching through instruction ID anyway...
        switch(line.instruction_id) {
            // addiu - I
            case 1:
                translate_i(line, 0x09);
                break;

            // addu - R
            case 2:
                translate_r(line, 0x21);
                break;

            // or - R
            case 3:
                translate_r(line, 0x25);
                break;

            // beq - I
            case 5:
                translate_i(line, 0x04);
                break;

            // bne - I
            case 6:
                translate_i(line, 0x05);
                break;

            // slt - R
            case 8:
                translate_r(line, 0x2A);
                break;

            // lui - I
            case 9:
                translate_i(line, 0x0F);
                break;

            // ori - I
            case 10:
                translate_i(line, 0x0D);
                break;

            // error case
            default:
                // throw new Exception("Unknown instruction ID.");
                break;
        }
    }

    // translate an I instruction, with a given opcode
    private static void translate_i(Instruction line, int opcode) {
        int instruction = 0;
        instruction = ((opcode << 26) & 0xFC000000);
        instruction |= ((line.rs << 21) & 0x03E00000);
        instruction |= ((line.rt << 16) & 0x001F0000);
        instruction |= (line.immediate & 0x0000FFFF);
        numbers.add(instruction);
    }

    // translate an r instruction, with a given function
    private static void translate_r(Instruction line, int function) {
        int instruction = 0;
        instruction |= ((line.rs << 21) & 0x03E00000);
        instruction |= ((line.rt << 16) & 0x001F0000);
        instruction |= ((line.rd << 11) & 0x0000F800);
        instruction |= ((line.shift_amount << 6) & 0x000007C0);
        instruction |= (function & 0x0000003F);
        numbers.add(instruction);
    }


}
