#!/bin/bash
#
# run ./gen-input.sh <ASM input file> <DEC output file>
#

if [ -z "$1" ]
  then
    echo "run ./gen-input.sh <ASM input file> <DEC output file>"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "run ./gen-input.sh <ASM input file> <DEC output file>"
    exit 2
fi

touch code.txt

# dump instructions from asm file
java -jar Mars_2194_a.jar a dump .text HexText code.txt $1

# count how many instructions
num_lines=`wc -l code.txt | awk '{print $1}'`

# count halt too
num_lines=$[$num_lines +1]

echo $num_lines > $2

# convert from hex to dec
cat code.txt | while read line ; do printf "%d\n" "0x$line" ; done >> $2

# halt instruction
echo "1073741848" >> $2

rm code.txt

