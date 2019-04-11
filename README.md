#USER Notes

This package was developed by Dominic A. Evangelista (https://scholar.google.com/citations?user=uFymnT8AAAAJ&hl=en; roachbrain.com) under NSF award no. 1608559. For now, cite Phyloinformatica from this paper: https://www.biorxiv.org/content/10.1101/601237v1.article-info

The package is containted within the Wolfram Language Package file (file extension "wl"). To use this file you must open with Wolfram Mathematica. As of January 2019 the package has only been tested with Mathematica V.10 and V.9. Be aware that other versions of Mathematica may produce errors in some Phyloinformatica functions.

As of January 2019 the change log, user guide, and all code are contained within the package itself. A copy of the introduction to Phyloinformatica is below.

# Phyloinformatica introduction

FUNCTIONALITY: Phyloinformatica was developed to provide basic phylogenetics/bioinformatics workflow functionality that can be easily extended to "genomic" scales (e.g. hundreds of thousands of files or very large files). Most of the things you can do in Phyloinformatica are basic things you may have done in Mesquite, or another alignment manipulation software, when dealing with a small (~1-10 genes, 3-250 individuals/taxa) dataset. In this sense, the functionality of Phyloinformatica greatly overlaps with that of Biopython, which actually has greater functionality. The advantage of using Phyloinformatica over Biopython are mostly Mathematica specific (i.e. if you prefer the Mathematica interface or programming language). However, there is some other functionality provided by Phyloinformatica and not in Biopython (e.g. some tree-file operations, alignment statistics, nucleotide translation, RADICAL workflow). Most importantly,  Phyloinformatica is designed to be user-friendly and requires only a basic understanding of coding and the Mathematica language to use.

STRUCTURE: The notebook is divided into the front-end/function-library section (which is a user-friendly list of functions, explanations and some usage examples) and a "Backend" section (which is where the function defintions are).

GENERAL OVERVIEW: The functions provided here are mostly general purpose FASTA/PHYLIP/alignment file manipulation, most of which are commonly applied in phylogenetic workflows/pipelines. There are some biologically related functions (e.g. nucleotide translation, codon position inference etc). There are also some functions related to the processing of outputs from other software. 

