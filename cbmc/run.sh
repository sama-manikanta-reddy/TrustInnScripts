#!/bin/bash

# Ensure script receives two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: ./cbmc_script.sh <benchmark.c> <bound>"
    exit 1
fi

# Get the absolute path of the input file
INPUT_FILE=$(realpath "$1")
BOUND=$2

# Extract the benchmark name without .c extension
BENCHMARK=$(basename "$INPUT_FILE" .c)

# Define the base results directory with bound value
RESULTS_DIR="$(dirname "$0")/Results/${BENCHMARK}-${BOUND}"

# Ensure the results directory exists
mkdir -p "$RESULTS_DIR"

# Copy the benchmark file to the results directory
cp "$INPUT_FILE" "$RESULTS_DIR/${BENCHMARK}.c"

# Define paths for result and report files
RESULT_FILE="$RESULTS_DIR/${BENCHMARK}-result.txt"
REPORT_FILE="$RESULTS_DIR/${BENCHMARK}-report.txt"

# Run CBMC with the correct file path and store results in the results directory
timeout 3600 cbmc "$RESULTS_DIR/${BENCHMARK}.c" --cover mcdc --unwind "$BOUND" --timestamp wall > "$RESULT_FILE"

# Count the number of satisfied and failed test cases
feasibleseq=$(grep -c "SATISFIED" "$RESULT_FILE")
infeasibleseq=$(grep -c "FAILED" "$RESULT_FILE")

# Output the final results
echo "* Final Result Report from CBMC *" | tee "$REPORT_FILE"
echo "Total number of Reachable paths or valid test cases =: $feasibleseq" | tee -a "$REPORT_FILE"
echo "Total number of Unreachable paths or invalid test cases =: $infeasibleseq" | tee -a "$REPORT_FILE"

# Extract timestamps correctly from the RESULT_FILE
startline=$(grep -m1 -oP '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d+' "$RESULT_FILE" | sed 's/T/ /')
endline=$(grep -oP '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d+' "$RESULT_FILE" | tail -n 1 | sed 's/T/ /')

# Check if timestamps were found
if [[ -z "$startline" || -z "$endline" ]]; then
    echo "Warning: Timestamps not found in CBMC output. Skipping timestamp-based timing calculation."
    startline="N/A"
    endline="N/A"
    diff="N/A"
else
    # Convert timestamps
    start=$(date --date="$startline" +%s.%3N)
    end=$(date --date="$endline" +%s.%3N)
    diff=$(awk -v start="$start" -v end="$end" 'BEGIN { printf "%.3f\n", end - start }')
fi

# Save timing details
echo "START : $startline to END : $endline" | tee -a "$REPORT_FILE"
echo "Total time required (sec) := $diff" | tee -a "$REPORT_FILE"

