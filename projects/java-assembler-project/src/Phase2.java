
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.io.*;  /* Exception */

public class Phase2 {
    // labels mapped to a line relativeto 0
    private static Map<Integer, Integer> labels = new HashMap<Integer, Integer>();
    private static List<Instruction> resolved;

    /* Returns a list of copies of the Instructions with the
     * immediate field of the instruction filled in
     * with the address calculated from the branch_label.
     *
     * The instruction should not be changed if it is not a branch instruction.
     *
     * unresolved: list of instructions without resolved addresses
     * first_pc: address where the first instruction will eventually be placed in memory
     */
    public static List<Instruction> resolve_addresses(List<Instruction> unresolved, int first_pc){
        resolved = new ArrayList<Instruction>();
        
        map_instructions(unresolved);
        resolve_instructions(unresolved);
        return resolved;
    }

    // maps the labels in the instructions to line numbers relative to the
    // first line (not the first PC because all the addressess are relative)
    // (because all the addresses are relative I don't actually need/care about
    // the PC)
    private static void map_instructions(List<Instruction> unresolved){
        int i = 0;
        for(Instruction line : unresolved) {
            if(line.label_id != 0) {
                Integer label_line = labels.get(line.label_id);
                if(label_line != null) {
                    //throw new Exception("Label appears twice in code.");
                }
                // there is a label
                // so let's map it!

                // instead of mapping it to a specific address we will map it
                // relative to the first line (0 indexed) and since we have
                // a the same reference point we can calculate the offset
                // without the first_pc... #PIC

                // since we aren't using a data section all of our references
                // are relative and this is robust...
                labels.put(line.label_id, i);
            }
            ++i;
        }
    }

    private static void resolve_instructions(List<Instruction> unresolved) {
        int i = 0;
        for(Instruction line : unresolved) {
            // only touch branch instructions
            // (5: beq, 6: bne)
            // (100: blt, 101 bge - pseudo instructions get converted to 5 or 6
            // in phase 1 so we can ignore 100 and 101 here)
            if(line.instruction_id == 5 || line.instruction_id == 6) {
                Integer offset = labels.get(line.branch_label);
                if(offset == null) {
                    // throw new Exception("Label not found in code.");
                }

                int relative_offset = (offset - i);
                line.immediate = relative_offset - 1; // -1 fixes the PC + 1

                resolved.add(line);
            } else {
                resolved.add(line);
            }

            ++i;
        }
    }

}
