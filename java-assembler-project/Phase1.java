
import java.util.LinkedList;
import java.util.ArrayList;
import java.util.List;

public class Phase1 {
    // the interpreted instructions to be returned
    private static List<Instruction> interpreted;

    /* Translates the MAL instruction to 1-3 TAL instructions
     * and returns the TAL instructions in a list
     *
     * mals: input program as a list of Instruction objects
     *
     * returns a list of TAL instructions (should be same size or longer than input list)
     */
    public static List<Instruction> mal_to_tal(List<Instruction> mals) {
        interpreted = new ArrayList<Instruction>();

        // interpret all the lines
        for(Instruction current_line : mals) {
            interpret(current_line);
        }

        // return interpreted
        return interpreted;
    }

    // interprets a single instruction
    // routes the instruction to another function to be interpreted
    // or to the interpreted List
    private static void interpret(Instruction current_line) {
        // blt
        if(current_line.instruction_id == 100) {
            interpret_blt(current_line);
        // bge
        } else if(current_line.instruction_id == 101) {
            interpret_bge(current_line);
        // ori
        } else if(current_line.instruction_id == 10) {
            interpret_ori(current_line);
        // addiu
        } else if(current_line.instruction_id == 1) {
            interpret_addiu(current_line);
        // non psuedo-code instruction, add to instructions array
        } else {
            interpreted.add(current_line);
        }
    }

    // interprets the blt instruction
    // if line.rs < line.rt => jump
    private static void interpret_blt(Instruction line) {
        // if line.rs < line.rt set $1 to 1; else $1 to 0
        Instruction stl = new Instruction(8, 1, line.rs, line.rt, 0, 0, 0, line.label_id, 0);
        // if $1 != 0  (line.rs < line.rt); jump to line.branch_label
        Instruction bne = new Instruction(6, 0, 1, 0, 0, 0, 0, 0, line.branch_label);
        interpreted.add(stl);
        interpreted.add(bne);
    }

    // interprets the bge instruction
    // if line.rs >= line.rt => jump
    private static void interpret_bge(Instruction line) {
        // if line.rs < line.rt => set $1 to 1 else $1 to 0
        Instruction stl = new Instruction(8, 1, line.rs, line.rt, 0, 0, 0, line.label_id, 0);
        // if $1 == 0 (line.rt >= line.rs); jump to line.branch_label
        Instruction beq = new Instruction(5, 0, 1, 0, 0, 0, 0, 0, line.branch_label);

        // add instructions
        interpreted.add(stl);
        interpreted.add(beq);
    }

    // interprets the ori instruction if necessary
    private static void interpret_ori(Instruction line) {
        // the limit above which MIPS interprets this
        // as a pseudo-instruction....
        // (when the 17th bit is high- eg: 0x10000)
        // weird that this standard is different than the addiu
        if(line.immediate > 0xFFFF) {
            // lui $1, upper 2 bytes of usigned integer
            Instruction lui = new Instruction(9, 0, 0, 1, line.immediate >> 16, 0, 0, line.label_id, 0);
            // ori $1, lower 2 bytes of unsigned integer
            Instruction ori = new Instruction(10, 0, 1, 1, line.immediate & 0x0000FFFF, 0, 0, 0, 0);
            // add unsigned, $rs + $1 -> $rt
            Instruction or = new Instruction(3, line.rt, line.rs, 1, 0, 0, 0, 0, 0);

            // add Instructions
            interpreted.add(lui);
            interpreted.add(ori);
            interpreted.add(or);
        } else {
            // if immediate is within the 16 bits inclusive add it safely
            interpreted.add(line);
        }
    }

    // interprets the addiu instruction if needed
    private static void interpret_addiu(Instruction line) {
        // the limit above which MIPS interprets this
        // as a pseudo-instruction....
        // (when the 16th bit is high- eg: 0x8000)
        //
        // I'm guessing it does it on the 16th bit as an artifact of
        // signed immediates logic (versus the branch ori instruction)
        if(line.immediate > 0x7FFF) {
            // lui $1, upper 2 bytes of usigned integer
            Instruction lui = new Instruction(9, 0, 0, 1, line.immediate >> 16, 0, 0, line.label_id, 0);
            // ori $1, lower 2 bytes of unsigned integer
            Instruction ori = new Instruction(10, 0, 1, 1, line.immediate & 0x0000FFFF, 0, 0, 0, 0);
            // add unsigned, $rs + $1 -> $rt
            Instruction addu = new Instruction(2, line.rt, line.rs, 1, 0, 0, 0, 0, 0);

            // add instructions
            interpreted.add(lui);
            interpreted.add(ori);
            interpreted.add(addu);
        } else {
            // immediate fits within 16 bits, add instruction
            interpreted.add(line);
        }
    }
}
