#!/bin/bash

# Set up error handling
set -e

# Check if the user provided two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path to test python program> <path to input directory>"
    exit 1
fi

# Resolve absolute paths
TEST_SCRIPT=$(realpath "$1")
INPUT_DIR=$(realpath "$2")
PYTHON_BIN="$(which python3)"

# Define base directory
SCRIPT_DIR=$(dirname "$(realpath "$0")")  # Directory where run.sh is located
RESULTS_BASE_DIR="$SCRIPT_DIR/Results"

# Get the Python script name without extension
TEST_SCRIPT_NAME=$(basename "$TEST_SCRIPT")
TEST_SCRIPT_BASENAME="${TEST_SCRIPT_NAME%.py}"

# Define Python program-specific result folder
PROGRAM_RESULTS_DIR="$RESULTS_BASE_DIR/$TEST_SCRIPT_BASENAME"
OUTPUT_DIR="$PROGRAM_RESULTS_DIR/output_dir"
LOG_FILE="$PROGRAM_RESULTS_DIR/afl_fuzz.log"

# Create program-specific results directory if it doesn't exist
mkdir -p "$PROGRAM_RESULTS_DIR"

# Move Python program and input directory into the program-specific folder
NEW_TEST_SCRIPT="$PROGRAM_RESULTS_DIR/$TEST_SCRIPT_NAME"
NEW_INPUT_DIR="$PROGRAM_RESULTS_DIR/$(basename "$INPUT_DIR")"

if [ "$TEST_SCRIPT" != "$NEW_TEST_SCRIPT" ]; then
    cp "$TEST_SCRIPT" "$NEW_TEST_SCRIPT"
fi

if [ "$INPUT_DIR" != "$NEW_INPUT_DIR" ]; then
    cp -r "$INPUT_DIR" "$NEW_INPUT_DIR"
fi

# Define result file
RESULT_FILE="$PROGRAM_RESULTS_DIR/results.txt"

# Step 1: Create and activate virtual environment
VENV_DIR="$SCRIPT_DIR/.venv"
if [ ! -d "$VENV_DIR" ]; then
    echo "[+] Creating virtual environment in $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
fi

echo "[+] Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Step 2: Check if python-afl is installed, install only if not present
if ! pip list | grep -q python-afl; then
    echo "[+] Installing python-afl..."
    pip install python-afl
else
    echo "[+] python-afl is already installed."
fi

# Step 3: Set core dump handling for AFL++
echo "[+] Configuring core dump handling..."
ulimit -c unlimited

$SCRIPT_DIR/set_core_pattern


# Step 4: Ensure the input directory exists
if [ ! -d "$NEW_INPUT_DIR" ]; then
    echo "[-] Error: Input directory '$NEW_INPUT_DIR' does not exist."
    exit 1
fi

# Create output directory if not exists
mkdir -p "$OUTPUT_DIR"

# Step 5: Ensure AFL++ runs properly
export AFL_SKIP_BIN_CHECK=1
export AFL_DUMB_FORKSRV=1
export AFL_MAP_SIZE=10000000

# Step 6: Start AFL++ fuzzing and preserve table format
echo "[+] Starting AFL++ fuzzing for 60 seconds on $NEW_TEST_SCRIPT using inputs from $NEW_INPUT_DIR..."
script -q -c "timeout 60s py-afl-fuzz -i \"$NEW_INPUT_DIR\" -o \"$OUTPUT_DIR\" -t 5000 -- \"$VENV_DIR/bin/python\" \"$NEW_TEST_SCRIPT\"" /dev/null | tee "$RESULT_FILE"


echo "[+] AFL++ fuzzing completed. Results saved in $RESULT_FILE"
echo "[+] Log saved to $LOG_FILE"
