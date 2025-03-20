#!/bin/bash

# Ensure two arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <LLVM_PATH> <FILE_NAME>"
    exit 1
fi

export LLVM_PATH=$1
export FILE_NAME=$2
export INSTALL_PATH=""

# Get the absolute path of the input file and LLVM path
FILE_PATH=$(realpath "$FILE_NAME") || { echo "Error: Unable to resolve file path for $FILE_NAME"; exit 1; }
LLVM_PATH=$(realpath "$LLVM_PATH") || { echo "Error: Unable to resolve LLVM path $LLVM_PATH"; exit 1; }	

# Get the base name of the file (without the extension)
FILE_NAME=$(basename "$FILE_NAME" .c)

# Create the target directory
SAVE_DIR=${INSTALL_PATH}/C-Tools/StaticAnalysis/Results/${FILE_NAME}/clang
mkdir -p ${SAVE_DIR} || { echo "Error: Failed to create directory ${FILE_NAME}/clang"; exit 1; }

# Run clang to compile the source file into LLVM bitcode
${LLVM_PATH}/bin/clang -I ${LLVM_PATH}/include -c -O0 -emit-llvm -g ${FILE_PATH} -o ${FILE_NAME}.bc || { echo "Error: Clang compilation failed for ${FILE_NAME}"; exit 1; }

# Disassemble the bitcode into LLVM IR
${LLVM_PATH}/bin/llvm-dis ${FILE_NAME}.bc || { echo "Error: llvm-dis failed on ${FILE_NAME}.bc"; exit 1; }

# Run clang for static analysis
${LLVM_PATH}/bin/clang --analyze ${FILE_PATH} || { echo "Error: Clang static analysis failed for ${FILE_NAME}"; exit 1; }

# Move generated files into the target directory
cp "$FILE_PATH" "${SAVE_DIR}" || { echo "Error: Failed to copy $FILE_PATH"; exit 1; }
mv ${FILE_NAME}.bc ${SAVE_DIR} || { echo "Error: Failed to move ${FILE_NAME}.bc"; exit 1; }
mv ${FILE_NAME}.ll ${SAVE_DIR} || { echo "Error: Failed to move ${FILE_NAME}.ll"; exit 1; }
mv ${FILE_NAME}.plist ${SAVE_DIR} || { echo "Error: Failed to move ${FILE_NAME}.plist"; exit 1; }

echo "Process completed successfully."
