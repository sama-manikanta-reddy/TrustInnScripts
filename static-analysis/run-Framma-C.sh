#!/bin/bash

# Ensure the file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <FILE_NAME>"
    exit 1
fi

export FILE_NAME=$1
export INSTALL_PATH=""

# Get the absolute path of the file
FILE_PATH=$(realpath "$FILE_NAME") || { echo "Error: Unable to resolve file path for $FILE_NAME"; exit 1; }

# Extract the base name of the file (without the extension)
FILE_NAME=$(basename "$FILE_NAME" .c)

# Create the directory to store output files
SAVE_DIR=${INSTALL_PATH}/C-Tools/StaticAnalysis/Results/${FILE_NAME}/frammac
mkdir -p ${SAVE_DIR} || { echo "Error: Failed to create directory ${SAVE_DIR}"; exit 1; }

# Run Frama-C analysis
frama-c -eva -eva-no-remove-redundant-alarms \
    -eva-all-rounding-modes-constants \
    -eva-join-results -eva-report-red-statuses \
    "${SAVE_DIR}/${FILE_NAME}-red" "$FILE_PATH" &> "${SAVE_DIR}/${FILE_NAME}-report.txt" || { echo "Error: Frama-C analysis failed"; exit 1; }

# Process the output of Frama-C
sed '/division_by_zero/!d' "${SAVE_DIR}/${FILE_NAME}-red" | 
    cut -f1,2,4-9 --complement |
    sort -u > "${SAVE_DIR}/${FILE_NAME}-lines.txt" || { echo "Error: Sed/cut/sort processing failed"; exit 1; }

# Modify the lines and save to a new file
sed "s/^/$FILE_NAME-/; s/$/.c/" "${SAVE_DIR}/${FILE_NAME}-lines.txt" > "${SAVE_DIR}/${FILE_NAME}-hard.txt" || { echo "Error: Sed transformation failed"; exit 1; }

# Copy the original file to the directory
cp "$FILE_PATH" "${SAVE_DIR}" || { echo "Error: Failed to copy $FILE_PATH to ${SAVE_DIR}/"; exit 1; }

echo "Process completed successfully."
echo "Results saved in ${SAVE_DIR}"
