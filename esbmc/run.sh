#!/bin/bash

# Ensure a file argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file.py>"
    exit 1
fi

export FILE_NAME="$1"
export INSTALL_PATH=""

# Get the base name of the file (without the extension)
FILE_NAME=$(basename "$FILE_NAME" .py)

# Ensure the file exists
if [ ! -f "$FILE_NAME" ]; then
    echo "Error: File '$FILE_NAME' not found!"
    exit 1
fi

# Ensure Python 3 is installed
if ! command -v python3 &>/dev/null; then
    echo "Error: Python3 is not installed!"
    exit 1
fi

WORK_DIR="${INSTALL_PATH}/Python-Tools/ESBMC"
cd ${WORK_DIR}

if [ ! -d ".venv" ]; then
	echo "Creating virtual environment..."
	python3 -m venv .venv || { echo "Failed to create virtual environment!"; exit 1; }
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source ./.venv/bin/activate || { echo "Failed to activate virtual environment!"; exit 1; }

# Install ast2json if not already installed
if ! pip show ast2json &>/dev/null; then
    echo "Installing ast2json..."
    pip install -q ast2json
else
    echo "ast2json is already installed."
fi

# Ensure ESBMC exists before running
if [ ! -x "./esbmc/build/src/esbmc/esbmc" ]; then
    echo "Error: ESBMC binary not found or not executable!"
    exit 1
fi

mkdir -p ./Results/
OUTPUT_FILE="./Results/${FILE_BASE_NAME}.txt"

# Run ESBMC
echo "Running ESBMC on ${FILE_NAME}.py..."
./esbmc/build/src/esbmc/esbmc ${FILE_NAME}.py --python python3 | tee "$OUTPUT_FILE"

# Check ESBMC exit status
if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    echo "ESBMC test failed! Output saved in '$OUTPUT_FILE'"
    exit 1
fi

echo "ESBMC test completed successfully. Output saved in '$OUTPUT_FILE'"

# Deactivate the virtual environment
echo "Deactivating virtual environment..."
deactivate || { echo "Failed to deactivate virtual environment!"; exit 1; }
