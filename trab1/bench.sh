#!/bin/bash

TARGET="$1"
HEADER_SET=false
EXPECTED=0

benchmark() {
	local FILE="$1"
	for _ in {1..10}; do

		local OUTPUT=$(./"$TARGET" "$FILE")

		if [ "$HEADER_SET" = false ]; then
			echo "name,$(echo "$OUTPUT" | head -n 1 | awk '{$1=$1; print}' OFS=',')" > output.csv
			HEADER_SET=true
			EXPECTED=$(echo "$OUTPUT" | tail -n 1)
		fi

		echo "$FILE,$(echo "$OUTPUT" | head -n 2 | tail -n 1 | awk '{$1=$1; print}' OFS=',')" >> output.csv
		VALUE=$(echo "$OUTPUT" | tail -n 1)
		if ! awk "BEGIN {exit !($VALUE == $EXPECTED)}"; then
			echo "Expected $EXPECTED but got $VALUE"
			exit 1
		fi
	done
}

echo "Benchmarking"

benchmark "data.csv"
benchmark "sorted_id.csv"
benchmark "sorted_timestamp.csv"
benchmark "sorted_value.csv"
benchmark "sorted_valid.csv"
