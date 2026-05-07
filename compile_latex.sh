#!/bin/bash

# compile_latex.sh - Robust LaTeX Compilation Script (v2.0)
# Author: Eric A. Booth, TX2036.org, eric.a.booth@gmail.com
# Usage: ./compile_latex.sh path/to/filename.tex

# Exit on error if any command fails in a way that isn't handled
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <filename.tex>"
    exit 1
fi

# 1. Resolve Paths
# Get the absolute path of the input file
ABS_PATH=$(realpath "$1")
# Get the directory and the filename
TARGET_DIR=$(dirname "$ABS_PATH")
FILE_EXT=$(basename "$ABS_PATH")
FILENAME="${FILE_EXT%.*}"
PDF_FILE="${FILENAME}.pdf"

# 2. Change to the target directory
# This is CRITICAL to bypass TeX Live's 'openout_any = p' security restriction
# which prevents bibtex/makeindex from writing to absolute paths.
cd "${TARGET_DIR}"

echo "-------------------------------------------------------"
echo "Compiling LaTeX Document: ${FILE_EXT}"
echo "Directory: ${TARGET_DIR}"
echo "-------------------------------------------------------"

# 3. Compilation Cycle
# Note: Added -shell-escape for packages that may need it

echo "Run 1: Initial pdflatex..."
pdflatex -interaction=nonstopmode -shell-escape "${FILE_EXT}" || echo "Warning: Non-fatal errors during first run."

if [ -f "${FILENAME}.aux" ] && grep -q "\\citation" "${FILENAME}.aux"; then
    echo "Run 2: BibTeX..."
    # bibtex must be run on the base filename without extension
    bibtex "${FILENAME}" || echo "Warning: BibTeX failed or no citations found."
fi

if [ -f "${FILENAME}.idx" ]; then
    echo "Run 3: MakeIndex..."
    makeindex "${FILENAME}" || echo "Warning: MakeIndex failed."
fi

echo "Run 4: Resolving references..."
pdflatex -interaction=nonstopmode -shell-escape "${FILE_EXT}" || echo "Warning: Non-fatal errors during second run."

echo "Run 5: Finalizing pdflatex..."
pdflatex -interaction=nonstopmode -shell-escape "${FILE_EXT}" || echo "Warning: Non-fatal errors during third run."

echo "-------------------------------------------------------"

# 4. Final Validation and Opening
if [ -f "${PDF_FILE}" ]; then
    echo "Success! PDF produced: ${PDF_FILE}"
    
    # Open the PDF using the default system viewer (Linux)
    if command -v xdg-open > /dev/null; then
        echo "Opening PDF..."
        xdg-open "${PDF_FILE}" &
    else
        echo "Could not find xdg-open. Please open ${PDF_FILE} manually."
    fi
else
    echo "Error: PDF production failed. Check ${FILENAME}.log for details."
    exit 1
fi
