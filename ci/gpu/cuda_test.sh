#!/bin/bash

SCRIPT_DIRECTORY=`dirname $0`
BIN_DIRECTORY="${SCRIPT_DIRECTORY}/../../build/bin"
DATA="${HOME}/ont-racon-data/nvidia"
RESULT_FILE="test-output.txt"
GOLDEN_FILE="$SCRIPT_DIRECTORY/golden-output.txt"

if [ $# -eq 0 ]; then
    BATCHES=7
else
    BATCHES=$1
fi

if [ ! -d $BIN_DIRECTORY ]; then
    echo "Could not find bin directory for racon binary"
    exit 1
fi

if [ -f $RESULT_FILE ]; then
    rm $RESULT_FILE
fi

if [ ! -f $GOLDEN_FILE ]; then
    echo "Could not find golden value file at $GOLDEN_FILE"
    exit 1
fi

CMD="$BIN_DIRECTORY/racon --cudaaligner-batches 0 -c${BATCHES} -m 8 -x -6 -g -8  -w 500 -t 24 -q -1 $DATA/iterated_racon/reads.fa.gz $DATA/iterated_racon/reads2contigs_1_1.paf.gz $DATA/canu.contigs.fasta"
echo "Running command:"
echo $CMD
$CMD > ${RESULT_FILE}
diff ${RESULT_FILE} ${GOLDEN_FILE} >& /dev/null
RES=$?

if [ $RES -eq "0" ]; then
    echo "Test passed."
    rm $RESULT_FILE
else
    echo "Test failed."
    echo "Result in ${RESULT_FILE}, golden vales in ${GOLDEN_FILE}"
fi

exit $RES
