#!/bin/bash

TARGET="$1"

echo "Benchmarking"
./"$TARGET" "data.csv" &&
    ./"$TARGET" "sorted_id.csv" &&
    ./"$TARGET" "sorted_timestamp.csv" &&
    ./"$TARGET" "sorted_value.csv" &&
    ./"$TARGET" "sorted_valid.csv"
