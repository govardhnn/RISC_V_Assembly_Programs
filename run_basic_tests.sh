#!/bin/bash
set -e

# Script to build and run all basic assembly examples directly with Spike

PROJECT_ROOT="."
EXAMPLES_DIR_NAME="basic_examples"
# EXAMPLES_DIR_NAME="vector"
EXAMPLES_FULL_PATH="${PROJECT_ROOT}/${EXAMPLES_DIR_NAME}"
MAKEFILE_INC="${PROJECT_ROOT}/makefile.inc"
ASFLAGS_BASIC="-march=rv64gc -g" # Assembler flags for basic examples

# Navigate to the project root directory
cd "${PROJECT_ROOT}" || { echo "Failed to navigate to ${PROJECT_ROOT}"; exit 1; }

echo "===================================================="
echo "Starting Batch Test Run for Basic Examples"
echo "===================================================="
echo ""

# Find all .S files in the EXAMPLES_DIR_NAME directory
find "${EXAMPLES_FULL_PATH}" -maxdepth 1 -type f -name '6_*.S' | while read -r asm_file_path; do
    filename=$(basename "${asm_file_path}")

    echo "----------------------------------------------------"
    echo "Processing: ${filename}"
    echo "----------------------------------------------------"

    # 1. Update makefile.inc
    echo "[INFO] Updating makefile.inc for ${filename}..."
    cat > "${MAKEFILE_INC}" << EOF
# Makefile include for specifying the target
# This file is automatically updated by run_basic_tests.sh

TARGET_DIR := ${EXAMPLES_DIR_NAME}
TARGET_SRC := ${filename}
ASFLAGS_TARGET := ${ASFLAGS_BASIC}
EOF
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to update ${MAKEFILE_INC} for ${filename}."
        echo "----------------------------------------------------"
        echo ""
        continue # Skip to the next file
    fi
    # echo "[DEBUG] Contents of makefile.inc:"
    # cat "${MAKEFILE_INC}"
    # echo ""

    # 2. Clean previous build
    echo "[INFO] Cleaning previous build for ${filename}..."
    if ! make clean; then
        echo "[WARNING] 'make clean' failed for ${filename}. Continuing anyway..."
    fi
    echo ""

    # 3. Build the program
    echo "[INFO] Building ${filename}..."
    if make all; then
        echo "[SUCCESS] Build successful for ${filename}."
        echo ""

        # 4. Run the program directly with Spike
        echo "[INFO] Running ${filename} with Spike (direct execution)..."
        if make spike_run_direct; then
            echo "[SUCCESS] ${filename} ran successfully via Spike."
        else
            echo "[ERROR] Execution failed for ${filename} with Spike."
        fi
    else
        echo "[ERROR] Build failed for ${filename}."
    fi
    echo "----------------------------------------------------"
    echo ""
done

echo "===================================================="
echo "Batch Test Run Completed."
echo "===================================================="
