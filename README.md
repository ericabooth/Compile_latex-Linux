# LaTeX Automation Script

A robust Linux shell script for automating the multi-step compilation process required for complex LaTeX documents (like the Tufte-style book example provided). A Perl script version is also provided for testing or systems that compile via .pl only.

## 🚀 Overview

Compiling LaTeX documents often requires multiple passes of `pdflatex`, `bibtex`, and `makeindex` to correctly resolve:
-   **Bibliographies** and citations.
-   **Table of Contents**, List of Figures, and List of Tables.
-   **Cross-references** and stable page numbering.
-   **Indices**.

The `compile_latex.sh` script automates these 5 steps in one go, using "non-stop mode" to ensure the process doesn't hang on minor warnings or formatting errors.

## 🛠️ Requirements

-   **Linux environment** (Ubuntu/Debian recommended).
-   **TeX Live** or a similar LaTeX distribution installed.
-   `pdflatex`, `bibtex`, and `makeindex` available in your PATH.

## 📖 How to Use

1.  **Grant Execution Permissions** (if not already set):
    ```bash
    chmod +x compile_latex.sh
    ```

2.  **Run the script** with your `.tex` file as the argument. You can use the Bash or Perl version:
    ```bash
    # Bash version
    ./compile_latex.sh hello.tex

    # Perl version
    ./compile_latex.pl hello.tex
    ```

3.  **Result:** The script will:
    -   `cd` into the file's directory (bypassing LaTeX security restrictions on absolute paths).
    -   Attempt to compile the document 5 times to resolve all dependencies.
    -   Enable `-shell-escape` for advanced features.
    -   Automatically open the resulting PDF.

## 📁 Included Example

The repository includes `hello.tex`, a comprehensive Tufte-Style book template that utilizes several advanced LaTeX features including:
-   `tufte-book` document class.
-   Citations and bibliography entries.
-   Complex indices and cross-references.
-   Margin figures and full-width environments.

--
## 🛠️ Additional Perl Script: compile_latex.pl 
  This script provides the same robust 5-pass compilation logic as the shell script but is written
  entirely in Perl.

   * Key Feature: Uses Perl's Cwd and File::Basename modules for platform-independent path
     handling.
   * Intelligence: Parses the .aux file to check for citations and detects the .idx file before
     running the auxiliary tools.
   * Security Bypass: Just like the Bash version, it switches directories automatically to ensure
     TeX Live can write its output files correctly.

 _ Ex: _ How to use the Perl script/utility:

   1 /home/ericbooth/Documents/compile_latex.pl /home/ericbooth/Documents/hello.tex


## 👤 Author

**Eric A. Booth**
- 📧 [eric.a.booth@gmail.com](mailto:eric.a.booth@gmail.com)
- 🌐 [www.eric-booth.com](http://www.eric-booth.com)
- 💼 [GitHub Profile](https://github.com/ericabooth)
