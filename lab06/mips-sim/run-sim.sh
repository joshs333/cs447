#!/bin/bash
#
# do ./run-sim.sh <ASM simulation> <ASM input file>
#
if [ -z "$1" ]
  then
    echo "run ./run-eval.sh <ASM simulation> <ASM input file>"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "run ./run-eval.sh <ASM simulation> <ASM input file>"
    exit 2
fi

echo "Generating the input for your simulation..."

# generate DEC input file
./gen-input.sh $2 $2.dec

echo "Now comparing MARS registers with your simulator registers"...

# run the simulator against the original ASM input file
java -jar Mars_2194_a.jar \$0 \$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9 \$10 \$11 \$12 \$13 \$14 \$15 \$16 \$17 \$18 \$19 \$20 \$21 \$22 \$23 \$24 \$25 $2 | tail -26 > mars.reg

# run the simulator using MIPS simulation code against DEC input file
#cat $2.dec | java -jar Mars_2194_a.jar 0x10010000-0x10010064 $1 | tail -7 | awk '{print $2" "$3" "$4" "$5}' | tr -s ' ' '\n' | awk '{print "$"++a[$0]-1"\t"$0}' > sim.reg
# EDIT: changed line for what I'm assuming is macos compatibility- fixes line numbers
cat $2.dec | java -jar Mars_2194_a.jar 0x10010000-0x10010064 $1 | tail -7 | awk '{print $2" "$3" "$4" "$5}' | tr -s ' ' '\n' | awk '{print "$"++a-1"\t"$0}' > sim.reg

diff mars.reg sim.reg

if [ $? == 0 ];
then
   echo "All good! Your simulated register file is correct!"
else
   echo "Fix your simulation! Your simulated register file is different from what was expected from running the input program!"
fi
