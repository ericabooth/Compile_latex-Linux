#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use Cwd 'abs_path';

# compile_latex.pl - Robust LaTeX Compilation Script in Perl
# Author: Eric A. Booth
# Usage: ./compile_latex.pl path/to/filename.tex

my $input_file = $ARGV[0];

if (!$input_file) {
    print "Usage: $0 <filename.tex>\n";
    exit 1;
}

# 1. Resolve Paths
my $abs_path = abs_path($input_file);
if (!$abs_path) {
    print "Error: File '$input_file' not found.\n";
    exit 1;
}

my $target_dir = dirname($abs_path);
my $file_ext   = basename($abs_path);
my $filename   = $file_ext;
$filename =~ s/\.tex$//i;
my $pdf_file   = "$filename.pdf";

# 2. Change to the target directory
# Critical to bypass 'openout_any = p' security restriction
chdir($target_dir) or die "Cannot change directory to $target_dir: $!";

print "-------------------------------------------------------\n";
print "Compiling LaTeX Document (Perl): $file_ext\n";
print "Directory: $target_dir\n";
print "-------------------------------------------------------\n";

# 3. Compilation Cycle

# Run 1: Initial pdflatex
print "Run 1: Initial pdflatex...\n";
system("pdflatex -interaction=nonstopmode -shell-escape \"$file_ext\"");

# Run 2: BibTeX
if (-e "$filename.aux") {
    open(my $fh, '<', "$filename.aux") or warn "Could not open $filename.aux for citation check: $!";
    my $has_citations = 0;
    while (<$fh>) {
        if (/\\citation/) {
            $has_citations = 1;
            last;
        }
    }
    close($fh);

    if ($has_citations) {
        print "Run 2: BibTeX...\n";
        system("bibtex \"$filename\"");
    }
}

# Run 3: MakeIndex
if (-e "$filename.idx") {
    print "Run 3: MakeIndex...\n";
    system("makeindex \"$filename\"");
}

# Run 4: Resolving references
print "Run 4: Resolving references...\n";
system("pdflatex -interaction=nonstopmode -shell-escape \"$file_ext\"");

# Run 5: Finalizing pdflatex
print "Run 5: Finalizing pdflatex...\n";
system("pdflatex -interaction=nonstopmode -shell-escape \"$file_ext\"");

print "-------------------------------------------------------\n";

# 4. Final Validation and Opening
if (-e $pdf_file) {
    print "Success! PDF produced: $pdf_file\n";
    
    # Open the PDF using the default system viewer
    if (`command -v xdg-open`) {
        print "Opening PDF...\n";
        system("xdg-open \"$pdf_file\" &");
    } else {
        print "xdg-open not found. Please open $pdf_file manually.\n";
    }
} else {
    print "Error: PDF production failed. Check $filename.log for details.\n";
    exit 1;
}
