#!/bin/bash

TARGET="$1"
HEADER_SET=false
EXPECTED=0

benchmark() {
    local FILE="$1"
    local SUFFIX="$2"
    echo "Benchmarking $FILE"
    for i in {1..10}; do
        echo "Iteration $i"
        START_TIME=$(date +%s.%N)
        local OUTPUT=$(./"$TARGET" "$FILE")
        END_TIME=$(date +%s.%N)
        ELAPSED=$(echo "$END_TIME - $START_TIME" | bc)

        if [ "$HEADER_SET" = false ]; then
            echo "name,elapsed,$(echo "$OUTPUT" | head -n 1 | awk '{$1=$1; print}' OFS=',')" >output_"$TARGET"_"$SUFFIX".csv
            HEADER_SET=true
            EXPECTED=$(echo "$OUTPUT" | tail -n 1)
        fi

        echo "$FILE,$ELAPSED,$(echo "$OUTPUT" | head -n 2 | tail -n 1 | awk '{$1=$1; print}' OFS=',')" >>output_"$TARGET"_"$SUFFIX".csv
        VALUE=$(echo "$OUTPUT" | tail -n 1)
        if ! awk "BEGIN {exit !($VALUE == $EXPECTED)}"; then
            echo "Expected $EXPECTED but got $VALUE"
            exit 1
        fi
    done
}

echo "Benchmarking"

echo "PAPI_TOT_CYC
PAPI_TOT_INS
PAPI_BR_MSP
PAPI_BR_PRC" >counters.in

benchmark "data.csv" 1
benchmark "sorted_id.csv" 1
benchmark "sorted_timestamp.csv" 1
benchmark "sorted_value.csv" 1
benchmark "sorted_valid.csv" 1

echo "PAPI_L1_DCM
PAPI_L2_DCM
PAPI_TLB_IM
PAPI_TLB_DM" >counters.in

HEADER_SET=false
benchmark "data.csv" 2
benchmark "sorted_id.csv" 2
benchmark "sorted_timestamp.csv" 2
benchmark "sorted_value.csv" 2
benchmark "sorted_valid.csv" 2
