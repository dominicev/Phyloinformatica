(* ::Package:: *)

(* ::Title:: *)
(*Biosystematica*)


(* ::Text:: *)
(*V. 0.92*)


(* ::Text:: *)
(*Dominic A. Evangelista*)


(* ::Text:: *)
(*NOTE: http://www.methodsinecologyandevolution.org/view/0/authorGuidelines.html see applications sections for how to possibly publish this package.*)


(* ::Chapter::Closed:: *)
(*0. Introduction*)


(* ::Text:: *)
(*The package is primarily focused on various functions on FASTA or Phylip files. Either of these file formats can be imported.*)
(**)
(*The notebook is divided into the "Function library" section (which is a user-friendly list of functions, explanations and some usage examples) and a "Backend" section (which is where the function defintions are).*)
(**)
(*The functions provided are mostly general purpose FASTA/alignment file manipulation, most of which are commonly applied in phylogenetic workflows/pipelines. There are some biologically related functions (e.g. nucleotide translation, codon position inference etc). There are also some functions related to the processing of outputs from other software.*)
(**)
(*If you are new to Mathematica and you don't know how to run the functions in this notebook see the section below. You should be able to understand most of the "Backend" if you have an intermediate understanding of Mathematica.*)
(**)
(*Otherwise, skip to the "Basic Biosystematica primer" section for some basic usage notes.*)


(* ::Subsection::Closed:: *)
(*Basic Mathemematica primer*)


(* ::Subsubsection::Closed:: *)
(*Notebooks, cells and running code*)


(* ::Text:: *)
(*This text is being written in a cell.*)


(* ::Input:: *)
(*(*This text is also being written in a cell.*)*)


Print["So is this text."]


(* ::Text:: *)
(*The difference is cell formatting. This cell is formatted as a text, and thus cannot contain executable code. The two above are two different types of input cells and the latter may also have an output cell if you ran the code.*)
(**)
(*You can run code by clicking somewhere in the cell, or highlighting one or multiple cells (on the right) and pressing "Shift-Enter" on the keyboard.*)
(**)
(*If you run the code above that begins with "(*" you will not see any output because the entire line of code is "commented out". In Mathematica you bracket comments with parenthesis next to asterisks as you see above. You can do this quickly by highlighting code and pressing "Alt-?".*)


(* ::Text:: *)
(*You probably noticed by now that Mathematica code is written in Mathematica formatted notebooks. The formatting utilizes nested sections that you can expand or contract depending upon your focus. You can expand or contract by double clicking the relevant bracket in the right margin. Play around with it to see how it works.*)


(* ::Text:: *)
(*To STOP executed code from finishing you can press "Alt-." or you can goto the Evaluation tab on the taskbar and click: Quit Kernel->Local. *)
(**)
(*In order to run notebooks in parallel you need to create a new kernel, which is also done in the Evaluation tab. To run Parallelized code Mathematica will automatically open a new kernel.*)


(* ::Subsubsection::Closed:: *)
(*Syntax*)


(* ::Text:: *)
(*All predefined mathematica functions begin with a capital letter, and functions and objects are all case sensitive. *)
(**)
(*So the code...*)


(* ::Input:: *)
(*Table[i, {i, 1, 10}]*)


(* ::Text:: *)
(*...is different from.*)


(* ::Input:: *)
(*table[i, {i, 1, 10}]*)


(* ::Text:: *)
(*The function "table" has not been defined, which is why it appears in blue and does not give any interesting output when it is run.*)


(* ::Text:: *)
(*Define functions by assigning them with ":=". For example:*)


(* ::Input:: *)
(*exampleFunction[input_String]:=("Your example input is: "<>input)*)


(* ::Text:: *)
(*You can try the above function by replacing "input_String" with a string below.*)


(* ::Input:: *)
(*exampleFunction[input_String]*)


(* ::Text:: *)
(*You can run the code but supress the output by putting a ";" after the code. You can also execute the function on the input using two shorthand inputforms as below*)


(* ::Input:: *)
(*" Nest is missing from the loops section. Look it up!"//exampleFunction*)
(*exampleFunction@" The built in help section is always very useful. And there are text and video tutorials too!" *)


(* ::Text:: *)
(*Objects are defined with an equal sign.*)


(* ::Input:: *)
(*matrix={{11, 12, 13}, {21, 22, 23}};*)


(* ::Text:: *)
(*And parts of lists can be obtained with the "Part" function, which is almost always used in shorthand format of: objecte[[row, column]].*)
(**)
(*For example:*)


(* ::Input:: *)
(*matrix[[1, 2]]*)
(*matrix[[1, 1]]*)
(*matrix[[2]]*)
(*matrix[[All, 1]]*)
(*matrix[[2, 2;;]]*)


(* ::Text:: *)
(*In the above code ";;" is the function Span, which is how you signify ranges of numbers.*)


(* ::Text:: *)
(**)


(* ::Subsubsection::Closed:: *)
(*Loops*)


(* ::Text:: *)
(*The two basic kinds of loops are Table and Map. "Table" is similar to a "for" loop in Java or R and "Map" is similar to "lapply" in R.*)


(* ::Text:: *)
(*Example Table*)


(* ::Input:: *)
(*Table[{i, 5, AbsoluteTime[]}, {i, 10, 15}]//TableForm*)
(*dummyFastaParsedObject=Table[{{"taxon"<>ToString[i],"dummySequence"}, "ATTATGCTGCTGATGC"}, {i, 10, 15}]*)


(* ::Text:: *)
(*Above you can see an example of the syntax for lists and matrices. The second example given happens to use the matrix structure that comprises the fastaParsed objects used by Biosystematica.*)


(* ::Text:: *)
(*Example Map*)


(* ::Input:: *)
(*Map[Length,dummyFastaParsedObject]*)


(* ::Text:: *)
(*Think of Map as a way to impliment a function (e.g. Length) over each part of an object, specifically the parts in the uppermost dimension. *)
(**)
(*Something important to know about Map is the shorthand format. *)


(* ::Input:: *)
(*Length/@dummyFastaParsedObject*)


(* ::Text:: *)
(*Also, they are most easily used with pure function syntax.*)


(* ::Input:: *)
(*Length[#]&/@dummyFastaParsedObject*)
(*StringJoin[">",#[[1]], ":Sequence:",#[[2]], ""]&/@dummyFastaParsedObject*)


(* ::Text:: *)
(*See the documentation for Map for more examples and details.*)


(* ::Subsubsection::Closed:: *)
(*General Mathematica Tips and Tricks*)


(* ::Text:: *)
(*1. Use Wolfram Documentation in the "Help" tab on the taskbar.*)
(*2. Mathematica uses lots of "inuitive input types, so if you are creative you can find interesting ways to run code. For example, for doing image transformations you can run functions on images stored as objects, or you can actually paste the image into the code itself and run it that way. Really cool.*)
(*3. While Mathematica's plotting functions are very versatile, the best way to make plots is to do it using Graphics (Graphics, Show, Directive etc). This is difficult to learn but gives great returns.*)
(*4. While much of Mathematica is built-in there are some user made packages and code. Google them.*)
(*5. Map is faster than Table. ParallelMap and ParallelTable can be faster than the base versions, but not always, and sometimes they give incorrect output, so be careful.*)
(*6. Block saves more memory than Module for some reason. I don't know of a situation where Module is superior to Block, so just use Block.*)
(*7. Dynamic and Manipulate are awesome functions, but can crash notebooks. Use them often but be careful.*)


(* ::Subsection::Closed:: *)
(*Basic Biosystematica primer*)


(* ::Text:: *)
(*The functions in this package are biased towards my own work flows. For instance, since I prefer working with FASTA files, and most of the softwares I use take FASTA files as input, this is the filetype that the package works with most. Many output formats and parsing functions are designed for usage in RAXML, MAFFT, and IQTree but there are exceptions.*)


(* ::Text:: *)
(*The package's functions operate on a list format similar to FASTA format, which are referred to as "fastaParsed" objects. This structure is:*)
(**)
(*{{{fasta headerSubscript[, part 1], ... fasta headerSubscript[, part  n]}, sequence_string}}. *)
(**)
(*When the document refers to "sequence" or "alignment" files, it is referring to either a FASTA or PHYLIP file. Sometimes it may refer to a FASTA file when in fact it really means either format.*)


(* ::Text:: *)
(*----------------------------------------------------------------------*)
(*--Themes and patterns among Biosystematica functions--*)
(*----------------------------------------------------------------------*)


(* ::Text:: *)
(*Functions in Biosystematica are designed to have flexible input whenever possible, but with some limitations. *)
(**)
(*Most functions dealing with sequences or alignments can take files (as fasta or phylip) or fastaParsed objects as input. Functions usually detect the input automatically. In some cases, the same goes for individual files or lists of files: the functions automatically execute appropriately depending upon either case (althout as of v. 0.913 this functionality is failry limited).*)
(**)
(*When lists of files or lists of fastaParsed objects are not allowed as input, the Mathematica base function Map (or it's shorthand equivalent: fun[#]&/@list) needs to be used to extend its functionality. If you require this, learn how to use Mathematica if you don't already (see previous section).*)
(**)
(*When fastaParsed objects are provided as input the default is to return a fastaParsed object, and there are few times when this isn't the case.*)
(**)
(*When file names are provided as input the output is exported to the working directory as an automatically renamed output file. However, the option "Hold" can be added to the function's input to specify that a fastaParsed object should be returned instead of exporting to file. My personal preference is to export to file, and then check manually that the script did what you wanted it to. My preferred alignment viewer for this purpose is AliView.*)


(* ::Text:: *)
(*----------------------------------------------------------------------*)
(*------------------------Memory and speed-----------------------*)
(*----------------------------------------------------------------------*)


(* ::Text:: *)
(*One of the reasons I started Biosystematica was the limited ability of some softwares to deal with "big data" sequence files. Mathematica does a pretty good job of not crashing under the load of 1GB (or more) of memory loaded onto the kernel (at least on my machine). However, that doesn't mean it's fast when it's doing it. Hopefully, I will update more functions to utilize low-level stream-reading functionality, which provides big gains in terms of speed and memory (although it's more difficult to code). *)


(* ::Chapter::Closed:: *)
(*1. Sequences*)


(* ::Subchapter::Closed:: *)
(*File operations (e.g. file import, export, converting formats, moving, mending) *)


(* ::Text:: *)
(*The functions in this section don't change the content of sequences, only their packaging. The first section acts only on file structure and the second section acts on file contents (but not sequence contents).*)


(* ::Section::Closed:: *)
(*Trival (e.g. file import, export, converting formats, moving, mending) *)


(* ::Subsection::Closed:: *)
(*Import and export FASTA or Phylip*)


(* ::Subsubsection::Closed:: *)
(*Import*)


(* ::Text:: *)
(*The functions below will import a FASTA or PHYLIP file. The output is a fastaParsed object of the structure:*)
(*{{{fasta headerSubscript[, part 1], ... fasta headerSubscript[, part  n]}, sequence_string}}. This structure is used internally in most functions. To get a FASTA file from this format you can use the function fastaOut[]*)
(**)
(*The header for the fasta files are by default, assumed to be "|" (vertical line) or ";" (semicolon).*)


(* ::Text:: *)
(*Input is:*)
(*	directory - a string containing the name of the directory where the file is present. This is optional and can be excluded if the file is in the current working directory (i.e. Directory[]).*)
(*	fileName  - a string identical to the file name.*)
(**)


importAlignment[directory_, fileName_];


importAlignment[filename_];


(* ::Text:: *)
(*Using the option "ImportTogether" can make it such that you can import multiple files into the same fastaParsed object.*)
(**)
(*The input you specify is:*)
(**)
(*	input - either a string representing the directory where those files exist or a list of file names.*)


importAlignment[input_, "ImportTogether"]


(* ::Subsubsection::Closed:: *)
(*Export*)


(* ::Text:: *)
(*The function below will take a name and a fastaParsed object and export it to the working directory. *)
(**)
(*The input is:*)
(*	fileName - a string telling the code what to name the output file. There MUST be a filename extension. To simplify most code you can simply put in the same name as the input file, and it will automatically change the file extension so that it doesn't overwrite the original file.*)
(*	fastaParsed - a fastaParsed object.*)
(*	*)
(*Alternatively, the above inputs can be lists of multiple files names and multiple fastaParsed objects and it will automatically output all of them to the working directory.*)


fastaExport[fileName_String,fastaParsed_List];


fastaExport[fileNames_List, fastaParsedLists_List]


(* ::Text:: *)
(*The function below will take a fastaParsed object and export it as a PHYLIP file. The input is:*)
(*	fastaParsed - a fastaParsed list*)
(*	headerPosition - an integer representing the part of the fasta header you want to turn into the phylip headers. Usually this will be the taxon name. Default is 1.*)
(*	padLength - the amount of whitespace you want after your taxon name. This should be some number greater than the longest taxon name. Default is 70. (NOTE, can only be omitted from input if headerPosition is also omitted, otherwise it will give the wrong output).*)
(*	*)
(*	Just as with fastaExport the fileName can be a list of fileNames when fastaParsed is a list of multiple parsed fastas.*)


phylipExport[fileName_, fastaParsed_,headerPos_Integer, padLength_Integer];


phylipExport[fileName_, fastaParsed_];


phylipExport[fileName_, fastaParsed_, padLength_Integer];


(* ::Subsection::Closed:: *)
(*Converting sequence file formats*)


(* ::Text:: *)
(*This function will take a sequence/alignment file and convert it to another format.*)
(*Input is:*)
(*	FILENAME - a string indicating the name of the file or a list of strings.*)
(*headerPos - an integer indicating the position of the header name (only relevant for conversion for Phylip, but needs to always be included).*)
(*	outFormat - the format you want to conver it to. Possible options are:*)
(*"FASTA", "fasta", "Fasta"*)
(*"PHYLIP", "phylip", "Phylip"*)


sequenceFileConverter[FILENAME_,headerPos_Integer,  outFormat_String];


(* ::Subsection::Closed:: *)
(*Mending FASTA files with misread headers or empty data*)


(* ::Text:: *)
(*The function below will read a FASTA file, and rewrite it with a corrected FASTA header format. It only works for FASTA files that have had headers spill over into the beginning of the sequence. Also, it only reconigzes the FIRST instance of a DNA character after the spilled part of the header.*)
(**)
(*NOTE that this has only been tested with illegal characters of String Length 1.*)
(**)
(*Input:*)
(*	fileName - a string with the name of the file to be fixed, or a list with multiple file names*)
(*	illegalCharacter - a string, preferably of a single chartacter" that should NOT be found in the sequence portion of the entry (e.g "s" or "f" for nucleotide data)*)
(*	legalChars - a list of single string characters giving the expected contents of the sequence portion of the file. The default are nucleotide characters: "A","T","C","G","a","t","c","g","N","?","-". *)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


mendFastaFile[fileName_, illegalCharacter_String, legalChars_List];
mendFastaFile[fileName_, illegalCharacter_String, legalChars_List, "Hold"];


mendFastaFile[fileName_, illegalCharacter_String];
mendFastaFile[fileName_, illegalCharacter_String, "Hold"];


(* ::Subsection::Closed:: *)
(*Renaming sequence files*)


(* ::Text:: *)
(*The code below will rename fasta files by prepending a block from the fasta headers. Note that the fasta file MUST contain THE SAME value in all the headers at that block.*)
(**)
(*Input is:*)
(*	directory - a string containing the directory of the file.*)
(*	filenames - a list of all the file names you want to change*)
(*	fastaPartToPrepend - an integer indicating which entry of the sequence header will be prepended to the file name*)
(**)


prependFastaFileName[directory_String, filenames_, fastaPartToPrepend_Integer];


(* ::Text:: *)
(*The code below will entirely rename a file using the FASTA headers by making a copy and not replacing the original.*)
(**)
(*Input:*)
(*	directory - a string containing the directory of the file*)
(*	filenames - a list of all the file names you want to change*)
(*	fastaPartsToCompose - an integer indicating which entry or entries of the sequence header will be added to the file name*)
(*	fileExtension - the file extension to use on the new files.*)


renameFastaWH[directory_String, filenames_, fastaPartsToCompose_List, fileExtension_String];


(* ::Subsection::Closed:: *)
(*Moving a subset of files*)


(* ::Text:: *)
(*This function compares a file list against a list of names and takes the files with names shared by the list and moves them to a new folder.*)
(**)
(*Input:*)
(*	fileDir - the string name of the directory your files are in*)
(*	nameList - the list of the files you want to move*)
(*	folderName - a string that will be the name of the directory you want to move the files to.*)


moveFiles[fileDir_String,nameList_List, folderName_String];


(* ::Subsection::Closed:: *)
(*Getting sequence lengths*)


(* ::Text:: *)
(*The function below will return a list of the number of characters for each sequence. It works for sequence files and alignments. For alignments, it will return one number, or a list of Unioned numbers.*)
(**)
(*Input is:*)
(*	alignment - a sequence or alignment in fastaParsed format or a file name.*)
(*	option - specifying "Alignment" as an option will treat the sequence file as an alignment.*)


getSequenceLengths[alignment_List];
getSequenceLengths[alignment_String];
getSequenceLengths[alignment_List, "Alignment"];
getSequenceLengths[alignment_String, "Alignment"];


(* ::Section::Closed:: *)
(*Non-trivial(e.g.: file merging, splitting; sequence sorting, extraction, renaming, cutting)*)


(* ::Text:: *)
(*In this section are generally useful functions that have an affect on the content of the files. *)


(* ::Subsection::Closed:: *)
(*Sorting sequence files by their header*)


(* ::Text:: *)
(*This simple function will sort a sequence file so that the entries are in a sorting order of whatever header block you specify. *)
(**)
(*Input is:*)
(*	fileName -  either a sequence file name or a list of sequence files.*)
(*	position  - an integer specifying the position in the header to search through the file. Default is 1, if not specified.*)
(*	option: "Hold" - specifying this option will output a fastaParsed object. Otherwise the script exports a new file.*)


sortFASTA[fileName_String, position_];
sortFASTA[fileName_String, position_, "Hold"];


sortFASTA[fileName_String];
sortFASTA[fileName_String, "Hold"];


sortFASTA[fileNames_List, position_];
sortFASTA[fileNames_List, position_, "Hold"];


sortFASTA[fileNames_List];
sortFASTA[fileNames_List, "Hold"];


(* ::Subsection::Closed:: *)
(*Pooling FASTA files and redistributing by a FASTA header *)
(*(usually, taxon FASTAs to gene FASTAs)*)


(* ::Text:: *)
(*If you have a collection of fasta files that each represent one taxon, with multiple sequences in each, sometimes you want to reorganize those by the genes within the taxa. It doesn't even have to be taxa files and genes within. The function below pools any collection of fasta files (in the same folder) bunches them by one of the features in the fasta header, and outputs them by the number of unique features. It could be accession numbers, taxon names, gene names, domain names or anything else. *)
(**)
(*Example explanation: Say you are interested in aligning orthologous sequences for 80 taxa using some software (e.g. MAFFT or MUSCLE). The files you have are transcriptome libraries for 80 taxa. The files each contain 7000 orthologous sequences from a single taxon. The function "taxFilesToGenes" will take all of those 80 files and turn them into 7000 files, each file containing an orthologous set of sequences. Thus, each file is now alignable and can subsequenly be used in a phylogenetic analysis.*)
(**)
(*Parameters:*)
(**)
(*	taxFileDirectory - a string representing where the original files are*)
(*	geneHeaderPosition - an integer representing the position in the FASTA header that you want to sort by.*)
(*	outDirectory - a string representing the directory you want to output the files to.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


taxFilesToGenes[taxFileDirectory_String, geneHeaderPosition_Integer, outDirectory_String];
taxFilesToGenes[taxFileDirectory_String, geneHeaderPosition_Integer, outDirectory_String, "Hold"];


(* ::Subsection::Closed:: *)
(*Merging sequence files *)


(* ::Text:: *)
(*This is vertical merging (increasing the number of sequences in one file), not horizontal merging (increasing the length of the sequences), like you might want to do with an alignment.*)


(* ::Subsubsection::Closed:: *)
(*Merging 2 fasta files*)


(* ::Text:: *)
(*	file1 - The FASTA file to go at the beginning of the new file*)
(*	file2 - The FASTA file to go at the end of the new file*)
(*	exportFNAME - If you specify this it will export to a text file of this name. This is optional. If not specified it will just output as a fastaParsed object defined under the object name "newfasta" and whatever other object name you assign it.*)


fastaMerge[file1_, file2_];


fastaMerge[file1_, file2_, exportFNAME_];


(* ::Subsubsection::Closed:: *)
(*Merging more than 2 fasta files*)


(* ::Text:: *)
(*fastaFileList - a list of the file names in the working directory that can be imported as a fastaParsed object.*)
(*exportFNAME - If you specify this it will export to a text file of this name. This is optional and if not specified it will just output a fastaParsed object.*)
(*DeleteDups (TRUE, FALSE; default = TRUE) - a boolean value telling the script if you want to delete duplicate sequences. There's really no reason to ever specify FALSE, so TRUE is a default option. Specifying this is optional.*)


fastaMergeAll[fastaFileList_];
fastaMergeAll[fastaFileList_, exportFNAME_];
fastaMergeAll[fastaFileList_, exportFNAME_, DeleteDups_];


(* ::Subsection::Closed:: *)
(*Deleting duplicate FASTA/sequence entries*)


(* ::Text:: *)
(*If the FASTA header entries and sequences are exactly duplicate, you don't need to make a new function for this. Use the built in Mathematica Union[] function on a fastaParsed object.*)


Union[];


(* ::Text:: *)
(*If the FASTA entries are duplicate in the sequence only (the headers are different) you can use this function. It will merge all entries that have the exact same sequence information, and one entry in the FASTA header (e.g. the taxon name) are the same.*)
(**)
(*Input:*)
(*	fastaFile - a fasta file name or fastaParsed object with potential duplicate sequences.*)
(*	headerGuide - an integer representing the position in the FASTA header you want to choose as the guide to make sure your comparing among the sequences you want to be comparing. *)
(*	option: "Hold" - if you are supplying a file name but don't want the results to be exported as a new file, specify this option.*)
(*	*)
(*	Note: If a fileName is specified the output will be a newly exported fasta file.*)


unionFasta[fastaParsed_List, headerGuide_Integer];
unionFasta[fastaFile_String, headerGuide_Integer];
unionFasta[fastaFile_String, headerGuide_Integer, "Hold"];


(* ::Text:: *)
(*This function is the same as the above but can be used for mutliple files at once. It also takes the "Hold" option but does not accept fastaParsed objects as input. *)


unionFastaAll[fastaFiles_List, headerGuide_Integer];
unionFastaAll[fastaFiles_List, headerGuide_Integer, "Hold"];


(* ::Text:: *)
(*See Alignment Manipulation section for another script that works on alignments*)


(* ::Subsection::Closed:: *)
(*Extracting a single sequence from a large FASTA file*)


(* ::Text:: *)
(*Input format is a string that contains a FASTA file. This function is for when you know the exact string in the header of the sequence you want and you want to extract it easily.*)
(*This only works when the header you are searching for is unique. If it is not unique it will only find the first instance of it.*)
(**)
(*Input is:*)
(*	file - a sequence file name, or a fastaParsed object.*)
(*	header - the exact header string you want to extract the sequence for.*)


sequenceExtract[file_, header_String];


(* ::Subsection::Closed:: *)
(*Limiting an FASTA file to a specific sublist of sequences/taxa*)


(* ::Text:: *)
(*The function below can limit a set of sequences to a predefined subset of taxa. It can do this in one of two ways. 1. By making a fastaParsed object with only those taxa. 2. By turning all OTHER taxa into blank sequences.*)
(**)
(*	full - the full alignment in FASTA parsed format or a file name.*)
(*	keepSet - the list of taxa you want to keep. Need to be exact matches to the others in the alignment. Note that the names you give here can be present in any position of the FASTA header. *)
(*	method:*)
(*		"method1" -  makes a fastaParsed object with only those taxa.*)
(*		"method2" - turns all OTHER taxa into blank sequences.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


limitSeqList[full_, keepSet_, method_];
limitSeqList[full_, keepSet_, method_, "Hold"];


(* ::Subsection::Closed:: *)
(*Deleting specific entries from sequence file*)


(* ::Text:: *)
(*The limitSeqList function can be used for this as well but I think this function is a little easier and more intuitive.*)


(* ::Text:: *)
(*The function below will delete entries from a FASTA list that have the specified name or names in the specified position of the sequence header.*)
(**)
(*Input is:*)
(*	fasta - either a fastaParsed object or a sequence file.*)
(*position - an integer indicating which position in the sequence header to look for the deleted string*)
(*	text - a string or a list of strings exactly matching the entries you want to delete in the sequence file.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


deleteFastaEntry[fasta_, position_Integer, text_];


(* ::Subsection:: *)
(*Renaming FASTA headers*)


(* ::Subsubsection::Closed:: *)
(*Insert into FASTA header*)


(* ::Text:: *)
(*The code below will add the specified string at the desired fasta block in all sequences. It has the same options as the native Mathematica "Insert" function.*)
(**)
(*Input is: *)
(*fasta - a fastaParsed object or a fileName*)
(*string - the string to be inserted into the header*)
(*position - an integer representing the position you want to move it into*)


insertIntoFastaHeader[fasta_,string_, position_];


(* ::Subsubsection::Closed:: *)
(*Cut a position from a FASTA header*)


(* ::Text:: *)
(*The code below will delete a part of a fasta header in all sequences. It will also save the position you are deleting under the object name "headerCut".*)
(**)
(*Input is: *)
(*	fasta - a fastaParsed object or sequence file name*)
(*	position - an integer representing the position you want to remove*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


removeFromFastaHeader[fasta_,position_];
removeFromFastaHeader[fasta_,position_, "Hold"];


(* ::Text:: *)
(*The code below will delete all parts of a fasta header with one exception. *)


(* ::Text:: *)
(*Input is: *)
(*	fasta - a fastaParsed object or sequence file name*)
(*	position - an integer representing the position you KEEP*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


keepOnlyFastaHeader[fasta_,position_];
keepOnlyFastaHeader[fasta_,position_, "Hold"];


(* ::Subsubsection::Closed:: *)
(*Rearrange FASTA header*)


(* ::Text:: *)
(*The function below will move part of a fasta header from one position to another. To move more than one position, iterate this over your parsed fasta object more than once.*)
(**)
(*Input is: *)
(*	fasta - a fastaParsed object or a sequence file name.*)
(*	fromPosition - an integer representing the position of the entry you want to me.*)
(*	toPosition - an integer representing the new position you want to move it to.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


rearrangeFastaHeader[fasta_, fromPosition_-> toPosition_];


(* ::Subsection::Closed:: *)
(*Removing tokens from header names*)


(* ::Text:: *)
(*Some software (like MAFFT) will add tokens to taxon names under certain circumstances. The below function can fix this.*)


(* ::Text:: *)
(*Input:*)
(*	alignment - will take either a fasta/phylip file or a fastaParsed object.*)
(*	token - is the exact substring you want removed from the taxon header (e.g. "_R_" from MAFFT -adjustdirection option).*)
(*	direction - tells the script whether to take the substring off of the string at the front or the back. Options are "Suffix" or "Prefix".*)
(*	position - tells the script what part of the fasta header it should look in. This should be an integer.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


fixPrefix[alignment_, token_,direction_,position_];
fixPrefix[alignment_, token_,direction_,position_, "Hold"];


(* ::Subchapter::Closed:: *)
(*Sequence editing functions (e.g. blank/missing characters, padding, replacing characters, missing data, reverse complement, translation)*)


(* ::Text:: *)
(*These are functions that modify the content of sequences in some way. These functions can be used with raw sequence files or with alignments, but for most cases the functions in the next section are more appropriate for the latter.*)


(* ::Section::Closed:: *)
(*Trivial sequence editing*)


(* ::Text:: *)
(*This section has functions that edit sequences in such a way that have no effect to analyses (adding empty seqs and missing characters). Of course replacing characters in sequences could have an affect on biological content of a sequence, but I assume most wouldn't use it that way.*)


(* ::Subsection::Closed:: *)
(*Padding sequences*)


(* ::Text:: *)
(*If you want to merge unaligned sequences it is necessary to have the alignments be the same length.*)
(*This function can also be used to put one or more buffer characters at the end of alignments before merging so that it is easier to tell where the gaps between the alignments are.*)
(**)
(*Input is:*)
(*	alignment - a fastaParsed object or sequence file name*)
(*	padCharacter - a string, representing a character you want to put at the end of the sequences to  make them all the same length.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


sequencePadder[alignment_, padCharacter_String];
sequencePadder[alignment_, padCharacter_String, "Hold"];


(* ::Subsection::Closed:: *)
(*Replacing characters in sequences*)


(* ::Text:: *)
(*You might want to use a software that cannot handle certain sequence characters (e.g. "*" or "?"). Using this function you can change them. It is also possible to delete characters from a sequence file by making the toChar parameter a blank string (""). There are two different input formats, for convenience.*)
(**)
(*	fastaParsed - a fastaParsed object or sequence file name*)
(*	fromChar - the character you want to remove.*)
(*	toChar - the character you want to replace it with.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


replaceChar[fastaParsed_, fromChar_, toChar_];
replaceChar[fastaParsed_, fromChar_->toChar_];
replaceChar[fastaParsed_, fromChar_, toChar_, "Hold"];
replaceChar[fastaParsed_, fromChar_->toChar_, "Hold"];


(* ::Section::Closed:: *)
(*Non-trivial sequence editing*)


(* ::Text:: *)
(*These functions do things that have an effect on the biological information contained within a sequence or a file.*)


(* ::Subsection::Closed:: *)
(*Deleting entries with a % of missing data*)


(* ::Text:: *)
(*This function will delete any sequence that is composed of a certain amount of missing data. NOTE that this only takes into account the amount of missing data in a single entry, not the amount of missing data in a position across entries. This could be useful to delete short reads that contain uncalled bases or other largely ambigious sequences.*)
(**)
(*Input:*)
(*	alignment - the list of sequences in a fasta parsed format or a file name*)
(*	percent - the maximum amount of missing data a sequence can have, otherwise it is deleted. Default is 1.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


deleteEmptySequences[alignment_, percent_];
deleteEmptySequences[alignment_];


(* ::Subsection::Closed:: *)
(*Reverse complement a sequence file*)


(* ::Text:: *)
(*This function will reverse complement a set of DNA sequences. Note that the sequence can contain standard degenerate code but some might be turned to "N"'s when necessary.*)
(**)
(*Input is:*)
(*	fasta - a fastaParsed object or a sequence file name.*)


(* ::Input:: *)
(*reverseComplementAll[fasta_List];*)
(*reverseComplementAll[fasta_String];*)
(*reverseComplementAll[fasta_String, "Hold"];*)


(* ::Subsection::Closed:: *)
(*Translating nucleotide data to AminoAcids (AA)*)


(* ::Subsubsection::Closed:: *)
(*Paramaters and matrices*)


(* ::Text:: *)
(*I am including this here so users can see how to edit an include non-standard genetic codes.*)


(* ::Text:: *)
(*This is a standard ordered table of codons.*)


nucCodeTable=Flatten[Transpose/@Table[
{StringJoin[i, j, k]}
,{i, {"T", "C", "A", "G"}}, {j, {"T", "C", "A", "G"}}, {k, {"T", "C", "A", "G"}}], 1];


(* ::Text:: *)
(*This is the standard genetic code table.*)


stdGenCode=
{{{"Phe"},{"Ser"},{"Tyr"},{"Cys"}},{{"Phe"},{"Ser"},{"Tyr"},{"Cys"}},{{"Leu"},{"Ser"},{"Stop"},{"Stop"}},{{"Leu"},{"Ser"},{"Stop"},{"Trp"}},{{"Leu"},{"Pro"},{"His"},{"Arg"}},{{"Leu"},{"Pro"},{"His"},{"Arg"}},{{"Leu"},{"Pro"},{"Gln"},{"Arg"}},{{"Leu"},{"Pro"},{"Gln"},{"Arg"}},{{"Ile"},{"Thr"},{"Asn"},{"Ser"}},{{"Ile"},{"Thr"},{"Asn"},{"Ser"}},{{"Ile"},{"Thr"},{"Lys"},{"Arg"}},{{"Met"},{"Thr"},{"Lys"},{"Arg"}},{{"Val"},{"Ala"},{"Asp"},{"Gly"}},{{"Val"},{"Ala"},{"Asp"},{"Gly"}},{{"Val"},{"Ala"},{"Glu"},{"Gly"}},{{"Val"},{"Ala"},{"Glu"},{"Gly"}}}/.{"Gly"->"G","Ala"->"A" , "Leu"->"L", "Met"->"M", "Phe"->"F", "Trp"->"W", "Lys"->"K", "Gln"->"Q", "Glu"->"E", "Ser"->"S", "Pro"->"P", "Val"->"V", "Ile"->"I", "Cys"->"C", "Tyr"->"Y", "His"->"H", "Arg"->"R", "Asn"->"N", "Asp"->"D", "Thr"->"T", "Stop"->"*"};


stdGenCode//TableForm;


(* ::Text:: *)
(*Utilizing the stdn genetic code and the codon table, this is a standard genetic code list of replacement rules for translation.*)
(*(http://www.genome.jp/kegg/catalog/codes1.html)*)


replaceTableStd=Append[Table[
{nucCodeTable[[i, j, 1]]->stdGenCode[[i, j, 1]]}
,{i, 1, Length[nucCodeTable]}, {j, 1, Length[nucCodeTable[[1]]]}
]//Flatten, {"TTN"->"?","TCN"->"S", "TGN"->"?","CTN"->"L", "CCN" ->"P","CAN"->"?","CGN"->"R", "ATN"->"?", "ACT"->"T", "AAT"->"?","AGT"->"?", "GTN"->"V", "GCN"->"A", "GAN"->"?","GGN"->"G", "NAA"->"?", "NTA"->"?", "NCA"->"?", "NGA"->"?","NAT"->"?", "NTT"->"?", "NCT"->"?", "NGT"->"?","NAC"->"?", "NTC"->"?", "NCC"->"?", "NGC"->"?",
"NAG"->"?", "NTG"->"?", "NCG"->"?", "NGG"->"?","ANA"->"?", "TNA"->"?", "CNA"->"?", "GNA"->"?","ANT"->"?", "TNT"->"?", "CNT"->"?", "GNT"->"?","ANC"->"?", "TNC"->"?", "CNC"->"?", "GNC"->"?",
"ANG"->"?", "TNG"->"?", "CNG"->"?", "GNG"->"?",
"TTY"->"F","TTR"->"L","AUH"->"I","TAY"->"Y","TAR"->"*","TGY"->"C","CAY"->"H","CAR"->"Q","AAY"->"N","AAR"->"K","GAY"->"D","GAR"->"E", "AGY"->"S","AGY"->"K", "TRA"->"*","YUR"-> "L", "MGR"->"R"}]//Flatten;


temp={"CYT","ATT","ACT","CGT","GAG","TCA","GAG","AAG","CTA","CTG","CAT","TGC","TAA","CAT","CCA","AGA","AGA","TGG","TAT","ACA","GTA","AGT","CAA","TGT","TTA","ATC","GTG","ATG","GGA","TCC","AAA","GAT","GAC","GCT","AAT","TCA","ACG","GTT","TGA","ATG","CAA","AGA","AAG","GAG","TGT","TTA","TTG","CTG","GGT","CGC","AAA","TTG","TTT","CAT","GCT","AAA","CAA","GAT","TGA","TCA","TTT","CCA","TTG","GTT","TTC","TTT","CTT","AAA","GGA","TTG","GTA","TAT","AAC","CTT","GAA","AAT","ATG","GGT","GAA","ATA","GTG","TTC","ATA","TCC","ACG","TCA","AAA","TGA","ATG","GTG","AAA","TTC","CAA","GTG","TTC","CAA","TCA","CCA","CGC","TGG","CTG","GCA","TTT","CAA","GTC","TTA","CAG","ACT","TGT","TGC","CAG","AGA","TGC","CAC","TAC","CTT","CAC","CAT","TGC","CAC","AGA","CAT","TAA","GTA","ACA","AGT","CCC","TGC","TAT","TCC","ATC","CTC","GAG","TGG","CAG","AAG","AAG","CTC","AAA","TTC","TTC","TGA","GTG","TGC","GGG","ACG","ATG","CCT","TGG","TGC","CTC","AGC","TGA","TCC","AAT","CTC","TTG","TTC","AGA","CGT","CTG","CTG","ATC","ACA","TTG","AGC","TGA","AGG","ATC","ATT","ATG","CTG","GAA","CAG","AAC","CAC","CTG","TGG","ACC","AGC","AAC","AGA","ATA","TTC","CAG","AAC","TCC","TGA","AAG","CTA","TTC","TTC","AAC","GGA"};


Partition[replaceTableStd, 4]//TableForm


(* ::Subsubsection::Closed:: *)
(*Functions*)


(* ::Text:: *)
(*NOTE The functions the below functions to handle non-standard genetic codes. I can add it as an option to choose the matrix used.*)


(* ::Text:: *)
(*IMPORTANT that the function below does not work about 10% of the time because erroneous reverse complement reading directions can be more optimal choices surprisingly often. This problem arises because the function decides on reading frame by minimizing stop codons on individual strands. It is highly recommended that you align **first** with the --adjustdirection option in MAFFT first and then use the Alignment version of this function.*)


(* ::Text:: *)
(*	--Translate multiple FASTA files--*)


(* ::Text:: *)
(*input - the nucleotide sequence file name you want to translate, or a list of file names*)
(*suffix - the suffix you want to add to the file, INCLUDING the format suffix (e.g ".fasta", ".txt" )*)


translateNucleotideFile[input_];
translateNucleotideFile[input_List, "Hold"];


(* ::Text:: *)
(*	--Translate a FASTA parsed object--*)


(* ::Text:: *)
(*	fastaParsed - a fastaParsed object*)


translateFASTA[fastaParsed_];


(* ::Section::Closed:: *)
(*Miscellaneous sequence file operations*)


(* ::Subsection::Closed:: *)
(*Make a table from file headers*)


(* ::Text:: *)
(*This function will make a ".csv" file of any number of available entries from the entry headers in a Phylip of FASTA file.*)
(**)
(*	exportFileName - a string with the name of the file, including the file suffix. If you omit this input it has the same affect has using the "Hold" option.*)
(*	fastaFile - a phylip or fasta file in the current working directory, or a list of sequence files in the current directory.*)
(*	headerPositions - a list of integers representing the positions in the fasta Parsed object version of the fastaFile you want to turn into a table.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


exportFastaHeadTable[exportFileName_,fastaFile_, headerPositions_];
exportFastaHeadTable[exportFileName_,fastaFile_, headerPositions_,"Hold"];
exportFastaHeadTable[fastaFile_, headerPositions_];


(* ::Subsection::Closed:: *)
(*Nexus file import elements*)


(* ::Text:: *)
(*The script below imports a simplified nexus file without all the leading information. It basically just treats it like a phylip file.*)
(**)
(*Input:*)
(*	nexusString - a string version of the nexus file you want to parse. Note: not the nexus file name. The nexus file must first be imported as a string or text for this function to work.*)


nexusSimpleParser[nexusString_];


(* ::Text:: *)
(*The script below will take the "SETS" Section from a Nexus file and parse it to extract the set boundaries, and set names.*)
(**)
(*Input:*)
(*	nexusString - a string version of the nexus file you want to parse. Note: not the nexus file name. The nexus file must first be imported as a string or text for this function to work.*)


nexusSetsParser[nexusString_];


(* ::Subchapter::Closed:: *)
(*Alignment editing functions*)


(* ::Text:: *)
(*These functions were designed to only be used on alignments. Only use them on unaligned sequences if you understand how the function works (see Backend) and if you know what you're doing. *)


(* ::Section::Closed:: *)
(*Making consensus sequences*)


(* ::Subsection:: *)
(*Making strict consensus sequences*)


(* ::Text:: *)
(*NOTE: THE WAY THIS FUNCTION IS CURRENTLY WRITTEN IT CANNOT WORK FOR AMINO ACID SEQUENCES (because "N" is an amino-acid code). DO NOT USE WITH AA ALIGNMENTS.*)


(* ::Text:: *)
(*This  will take a fasta file and output a strict consensus (100% similarity only) of all the sequences. You can do this easily with EMBOSS, but this version will take terminal gaps and exclude them from the character consideration. This requires that you use the terminalGapsFastaFix and/or terminalGapsToUnknown functions first to change all the terminal gaps to a FASTA UNIQUE character. "?"s are recommended.*)
(**)
(*The input is:*)
(*	 termGappedAlign - an alignment with terminal gaps. The format is a fastaParsed object or file name.*)
(*The parameters:*)
(*	termGapCharacter  - a string indicating the character you are using as your terminal gap.*)
(*	minimumRequired  - a number indicating how many sequences you wish to be the minimum for choosing a nonambiguous (non-N) character. It is made such that the minimum cannot be less than 2. This means that the consensus you get will always be shorter than the longest sequence, assuming the sequences aren't the same length.*)


makeStrictConsensus[termGappedAlign_,termGapCharacter_String,minimumRequired_];
makeStrictConsensus[termGappedAlign_String,termGapCharacter_String,minimumRequired_, "Hold"];


(* ::Text:: *)
(*This is the same as above but without the minimum requirement of 2. Therefore, it will return the longest sequence for which there are no ambiguities.*)


makeLongestStrictConsensus[termGappedAlign_,termGapCharacter_String,minimumRequired_];
makeLongestStrictConsensus[termGappedAlign_,termGapCharacter_String,minimumRequired_, "Hold"];


(* ::Subsection::Closed:: *)
(*Making a consensus of duplicate sequences*)


(* ::Text:: *)
(*Specifically for when you have multiple sequences for the same thing (e.g. taxon) but their sequences are different (e.g. different regions of the same locus). For example, something like this... (see the output of the next cell)*)


TableForm[
{
{{{"Polyzosteria sp.","Locus 1","Region 1 "}}//TableForm,"------------ATGTAGGTAT"},
	{{{"Polyzosteria sp.","Locus 1","Region 2 "}}//TableForm,"TGTGGGTAAT------------"}
}
]


(* ::Text:: *)
(*...consensed to...*)


TableForm[
{
{{{"Polyzosteria sp.","Locus 1"}}//TableForm,"TGTGGGTAAT--ATGTAGGTAT"}
}
]


(* ::Text:: *)
(* This function is best utilized with an alignment that has already had messy ends trimmed.*)
(**)
(*	fastaParsed - a fastaParsed object or alignment file name with potential duplicate sequences*)
(*	headerGuide - an integer representing the position in the FASTA header you want to choose as the guide to make sure your comparing among the sequences you want to be comparing (in the above example, headerGuide = 1 or headerGuide = 2 would be sufficient, but if you had other taxa in the alignment "1" would probably be a better choice).*)
(*	termGapCharacter - a string indicating the character you are using as your terminal gap.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


consenseDuplicates[fastaParsed_, headerGuide_, terminalGapChar_];


(* ::Section::Closed:: *)
(*Gaps, unknowns and ambiguous characters*)


(* ::Subsection::Closed:: *)
(*Changing terminal gaps to unknown in FASTA alignments*)


(* ::Text:: *)
(*The code below takes a single string of nucleotides and replaces the defined gap character (e.g. "-") with a new terminal character (e.g. "?"). This works for nucleotide data ONLY.*)
(**)
(*Input is:*)
(*	fasta - a fastaParsed object or fastaFile*)
(*	fromGapCharacter - the original gap character*)
(*	toGapCharacter -  the replacement gap character*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


terminalGapsFastaFix[fasta_, fromGapCharacter_String, toGapCharacter_String]
terminalGapsFastaFix[fasta_, fromGapCharacter_String-> toGapCharacter_String]
terminalGapsFastaFix[fasta_String, fromGapCharacter_String, toGapCharacter_String, "Hold"]


(* ::Subsection::Closed:: *)
(*Changing all ambiguous characters in nucleotide alignments*)


(* ::Text:: *)
(*This function will replace all the ambiguous characters in your alignment with the specified character.*)
(**)
(*Input is: *)
(*	fastaFile - the file or fastaParsed object you want to operate one*)
(*	newCharacter - the character you want to turn all other ambiguities into*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


changeAmbiguous[fasta_, newCharacter_String];
changeAmbiguous[fasta_String, newCharacter_String, "Hold"];


(* ::Subsection::Closed:: *)
(*Replacing characters in alignments*)


Hyperlink["Click here to go to it", {EvaluationNotebook[], "replaceChar"}]


(* ::Subsection::Closed:: *)
(*Padding sequences in alignments with blanks *)


Hyperlink["Click here to go to it", {EvaluationNotebook[], "sequencePadder"}]


(* ::Subsection::Closed:: *)
(*Putting empty sequences into an alignment*)


(* ::Text:: *)
(*For some applications it is necessary to put empty sequences into an alignment. This is particularly important when you need the taxon composition of an alignments to always be the same or when you need to have comparable or mergable alignments. *)
(**)
(*Input is:*)
(*	inputAlignment - in a parsed FASTA format or a fileName*)
(*	tNameList - a simple list of all the taxon names you want to be added. They CAN be all the names (including the ones already present), but they don't HAVE TO be all the names...they just have to be the names you want to add. In other words, inputAlignment can contain names that tNameList doesn't and it will work just fine.*)
(*	blankCharacter - a string which is the character you want to make your empty sequences out of (e.g. "-", "N", "?")*)
(*	namePos - an integer which represents the position in the FASTA header where your taxon name resides.*)
(**)
(*The function will create an object "outputAlign" which is the output. But also it will output on it's own as well.*)


alignmentTaxonPadder[inputAlignment_, tNameList_, blankCharacter_String, namePos_Integer];
alignmentTaxonPadder[inputAlignment_String, tNameList_, blankCharacter_String, namePos_Integer,"Hold"];


(* ::Text:: *)
(*This version is the same as the above but with the option to add extra blocks to the fasta header of blank sequences.*)
(*	entry - is the entry (row) you want to use the header info from. It needs to be an integer*)
(*	block - is(are) the header block(s) you want to copy into the padded sequences. It can be a single block (e.g. 4) or a consecutive row of blocks (e.g. 2;;4) or the same block multiple times (e.g. {5, 5, 5, 5, 5})*)


alignmentTaxonPadder[inputAlignment_, tNameList_, blankCharacter_String, namePos_Integer, {entry_Integer, block_}];
alignmentTaxonPadder[inputAlignment_, tNameList_, blankCharacter_String, namePos_Integer, {entry_Integer, block_}, "Hold"];


(* ::Subsection::Closed:: *)
(*Removing/Collapsing gap-only characters*)


(* ::Text:: *)
(*This function takes a nucleotide alignment (NOT AMINO ACID) and checks to see which columns have only gap characters or entirely ambiguous characters (N's).*)
(**)
(*Input is: *)
(*	alignment - either an alignment file or a fastaParsed object.*)
(**)
(*Note: characters considered are: "-", "N", "?"*)
(*	These can be easily modified in the backend code (for instance, for use with amino acids).*)


collapseGapOnly[alignment_];
collapseGapOnly[alignment_String,"Hold"];


(* ::Section::Closed:: *)
(*Codons and AminoAcids*)


(* ::Subsection::Closed:: *)
(*Translate an alignment to amino acids*)


(* ::Text:: *)
(*NOTE: I need to update the below functions to handle non-standard genetic codes. I can add it as an option to choose the matrix used.*)


(* ::Text:: *)
(*NOTE: That this does work with alignments, but still messes up some sequences that should be aligned correctly. I am not sure why but I should explore more.*)


(* ::Text:: *)
(*This version requires that you decide on a correct reading direction in the alignment. This can be done via the --adjustdirection option in MAFFT. The only way this differs from the analogous function in the FASTA section is that this does not test reverse complement trand reads...so it's actually faster in that respect.*)


(* ::Text:: *)
(*Translate multiple FASTA files*)


(* ::Text:: *)
(*	input - the nucleotide FASTA file name or fastaParsed object you want to translate*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


translateAlignment[input_];
translateAlignment[input_String, "Hold"];


(* ::Subsection::Closed:: *)
(*Count stop-codons*)


(* ::Text:: *)
(*Input is:*)
(*	input - an alignment file name or fastaParsed Object. *)


countStopCodons[input_];


(* ::Text:: *)
(*Input is :*)
(*  	input - a list of alignment file names.*)
(*  	*)
(*  Output is a list of file names with the number of stop codons in the alignment.*)


countStopCodonsAll[fileNames_]


(* ::Subsection::Closed:: *)
(*Make stop-codons ambiguous*)


(* ::Text:: *)
(*Some software (like IQTree when using codon models) doesn't like when there are stop-codons in your alignment (probably because they want to make sure your sequences are actually protien coding. This function takes all stop-codons and turns them into ambigious codons by replacing them with gaps ("---").*)
(**)
(*The input is:*)
(*	file - either an alignment file or a fastaParsed object containing an alignment that is IN READING FRAME and BEGINS WITH CODON POSITION 1.*)


removeStopCodons[file_String]


(* ::Subsection::Closed:: *)
(*Exporting alignments by codon position*)


(* ::Text:: *)
(*This function takes advantage of the AA translation scripts to determine reading frame. This version, however, requires that sequences have been prealigned and are all in the same reading direction (i.e. not reverse complemented).*)
(**)
(*	alignmentFile - alignment file name or fastaParsed object*)
(*	codonsYouWantList - list of integers giving what codons you want in the exported alignment. Note that even if you only want a single codon, this needs to be a list. So the following examples are acceptable: {2} (for the second codon), {1, 2} (for the first and second), and {1, 2, 3} (for all three codons).*)
(*	exportName - the name of the file to export.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


makeCodonReadAlignment[alignmentFile_,codonsYouWantList_, exportName_];
makeCodonReadAlignment[alignmentFile_String,codonsYouWantList_, exportName_, "Hold"];
makeCodonReadAlignment[alignmentFile_String,codonsYouWantList_,"Hold"];


(* ::Section::Closed:: *)
(*Concatenation and partitioning functions*)


(* ::Subsection::Closed:: *)
(*Concatenating alignments*)


(* ::Text:: *)
(*This function will concatenate multiple alignments if their taxon sets are all the same. It also outputs a RAXML style partition file. NOTE that your input MUST have the same formatting of the fasta files (same data positions in the headers) and you must have the same taxa in all the alignments.. *)
(**)
(*Input and parameters*)
(*	alignments - is a fastaParsed list of fasta alignments.*)
(*	locusNamePosition - is an integer indicating the position in the header where the locus name resides*)
(*	datatype - is a string indicating what type of data is in the file. This will be printed out in the RAXML file.*)
(*		DataType must be one of the following*)
(*			"DNALoci" - this will output a RAXML style block with specifications for each locus, no codon positions*)
(*			"DNACodon" - this will output a RAXML style block with specifications for each locus by codon position, assuming that the alignments are in reading frame (first positions = 1st codon, with no frame shifts throughout).*)
(**)


concatenateAlignments[alignments_List,locusNamePosition_,dataType_String];


(* ::Text:: *)
(*This function is the same as the above but can only take lists of alignment file names. It is less flexible but it performs a taxon name sort prior to utilizing in the function. The lack of equivalent sequence order (i.e. name sorting) is the most common problem with the "concatenateAlignments" function, and this alternative function solves the issue by doing it for you. Otherwise you can do it with the above file manually.*)
(**)
(*Input is the same as "concatenateAlignments" except for the following:*)
(*	alignmentFiles - is a list of file names containing phylip or fasta alignments.*)


concatenateAlignmentsFromFile[alignmentFiles_List,locusNamePosition_,dataType_String]


(* ::Subsection::Closed:: *)
(*Calculating stats and partitions for multiple alignments*)


(* ::Text:: *)
(*This function will generate a RAXML style partition file and a text document giving the total information of multiple alignments. Note that this is automatically done when concatenating the alignments with concatenateAlignments and concatenateAlignmentsFromFile.*)
(**)
(*	listOfParsedAlign - is a fastaParsed list of fasta alignments. So, you must import all your alignments into one list before running this function.*)
(*	locusName - is an integer indicating the position in the header where the locus name resides*)
(*	datatype - is a string indicating what type of data is in the file. This will be printed out in the RAXML file.*)
(*		Possible options are:*)
(*			"DNALoci" - this will output a RAXML style block with specifications for each locus, no codon positions*)
(*			"DNACodon" - this will output a RAXML style block with specifications for each locus by codon position, assuming that the alignments are in reading frame (first positions = 1st codon, with no frame shifts throughout).*)


alignmentRandR2[listOfParsedAlign_, locusName_Integer, dataType_String];


(* ::Subsection::Closed:: *)
(*Reordering characters in an alignment based on a partitions file*)


(* ::Text:: *)
(*This function will take an alignment, and a partition file, and re-sort all the characters in the alignment so that each partition is a single block, and the partitions are sequential.*)
(**)
(*The input is:*)
(*	alignmentFile - a string indicating the exact name of the alignment file in your working directory or a fastaParsed alignment. NOTE: If your alignment is very big it is better to use the file name method of this function. Using it that way will utilize the least amount of memory for the shortest amount of time. This will decrease the probability that Mathematica will crash.*)
(*	partitionFile - a string indicating the exact name of the RAXML style partition file in your working directory.*)


reorderCharInAlign[alignmentFile_, partitionFile_];
reorderCharInAlign[alignmentFile_String, partitionFile_,"Hold"];


(* ::Subsection::Closed:: *)
(*Cutting alignment based on codon positions, when codon positions are known*)


(* ::Text:: *)
(*Under development (2018). See "makeCodonReadAlignment" for a useful alternative.*)


(* ::Section::Closed:: *)
(*Trimming alignments*)


(* ::Subsection::Closed:: *)
(*Trimming alignments (horizontal)*)


(* ::Subsubsection::Closed:: *)
(*Trim positions*)


(* ::Text:: *)
(*TrimAl is a very good software for quickly trimming alignments. However, it can't handle large files. Here is a simplistic alignment trimmer that can handle larger alignments simply because it's based in mathematica.*)
(**)
(*Output of the files below will be two files, one with the most complete positions and another file with all the ones that were cut out.*)
(**)
(*Input*)
(*	alignment - a raw alignment file name in FASTA format*)
(*Parameters*)
(*	reductionPercent - the % of data you want to reduce by. For example, a value of .80 will delete the 80% least complete positions starting with with most incomplete ones.*)


trimAlign[alignment_String, reductionPercent_];


(* ::Text:: *)
(*The second function is similar to the above but uses a different (possibly more useful) method. The parameter it uses to trim the alignment is the proportion of sequences with missing data.*)
(*Input*)
(*	alignment - a raw alignment file name in FASTA format*)
(*Parameters*)
(*	missingProportion - The max percentage of missing data you accept. All positions with more missing data than this will be deleted.  For example, a value of 0.2 will remove all nucleotide positions with 20% or more missing data. A higher number means that more nucleotides will be deleted*)


trimAlign2[alignment_String, missingProportion_];


(* ::Text:: *)
(*This is a version of the above compatible with amino-acid sequences.*)


trimAlign2AA[alignment_String, missingProportion_];


(* ::Text:: *)
(*This is a slimmed down version of the above functions that takes a fastaParsed list as input, rather than a file name.*)


trimAlign2Slim[alignment_List, missingProportion_];


(* ::Subsubsection::Closed:: *)
(*Trim from ends (general)*)


(* ::Text:: *)
(*Automated trimming is great but could potentially change codon structure or delete incorrectly internally aligned regions. To account for this we can just make the decision to trim from the end of the alignments. We can base how much we trim on an arbitrary number (e.g. 50 nucleotides), or we can base it on the number of sequences represented (e.g. 20%).*)
(**)
(*Input*)
(*	fastaFile - the name of an alignment file in the working directory*)
(*	emptinessAllowed - when using the "Percentage" method. The maximum percentage of emptiness you're willing to allow. Any percentage lower than this will be removed*)
(*	Method: "Percentage" - specifies that this is the "Percentage" method. This is the default, so it's optional.*)
(*	length - when using method:"Length" this number species the number of nucleotides cut off BOTH ends of the alignment.*)
(*	Method: "Length" - specifies that this is the "Length" method.*)


trimEnds[fastaFile_,emptinessAllowed_];
trimEnds[fastaFile_,emptinessAllowed_,"Percentage"];


trimEnds[fastaFile_,length_, "Length"]


(* ::Text:: *)
(*In the simple version we will automatically chop the alignment down to the core data set (sites with 75 % of their data present).*)


trimEnds[fastaFile_]:=trimEnds[fastaFile,.25]


(* ::Subsubsection::Closed:: *)
(*Trim codon alignments at right*)


(* ::Text:: *)
(*This function will trim the end of all alignments so that the last codon isn't cut off. IMPORTANT: This function assumes your first nucleotide on the left is a first codon position and everything is in the same reading frame. In other words...all this function does is make sure your alignment length is a multiple of 3.*)
(**)
(*Input is:*)
(*	alignment - a string specifying the name of the alignment file. This does not accept fastaParsed objects or the "Hold" option at this time.*)


makeAlignmentLengthDivisibleby3[alignment_String];


(* ::Subsection::Closed:: *)
(*"Square" an alignment*)


(* ::Text:: *)
(*This function combines two trimming functions to fix an alignment with a high proportion of missing data. It trims the data vertically (by removing taxa with missing data) and horizontally (by removing positions with missing data).*)
(**)
(*Input*)
(*	alignment - an alignment file name. Note that you must set the directory to the folder with your alignments.*)
(**)
(*Parameters*)
(*	verticalTrim - parameter for deleteEmptySequences function. The maximum amount of missing data a sequence can have, otherwise it is deleted.*)
(*	horizontalTrim - parameter for trimAlign2Slim function. The max percentage of missing data you accept. All positions with more missing data than this will be deleted.  For example, a value of 0.2 will remove all nucleotide positions with 20% or more missing data. A higher number means that more nucleotides will be deleted.*)
(*	format - a string indicating the output style. Currently accepted options are "Fasta", "Phylip" and "Nexus". Nexus format will remove taxon names.*)


squareAlignment[alignment_String, verticalTrim_, horizontalTrim_, "Nexus" (*format*)];


squareAlignment[alignment_, verticalTrim_, horizontalTrim_, "Fasta"];


squareAlignment[alignment_, verticalTrim_, horizontalTrim_, "Phylip"];


(* ::Subchapter::Closed:: *)
(*Calculating alignment stats*)


(* ::Text:: *)
(*Some alignment stats are output with the functions that concatenate alignments and make partition files. These are other stats.*)


(* ::Subsection::Closed:: *)
(*Count stop-codons*)


Hyperlink["Click here to go to it", {EvaluationNotebook[], "countStop"}]


(* ::Subsection::Closed:: *)
(*Counting number of taxa in a certain group (e.g. outgroups)*)


(* ::Text:: *)
(*The function below counts the number of taxa in a specified list are present in a list of taxa.*)


(* ::Text:: *)
(*Input is:*)
(*	fasta - is either a fastaParsed object or an alignment/sequence file.*)
(*	listOfTaxa - is a list of strings EXACTLY matching the list of strings (e.g. taxon names) you want to count in the file.*)
(*	headerPos - is the position in the fasta header you should look for the above list of strings.*)


countTaxa[fasta_List, listOfTaxa_, headerPos_];
countTaxa[fasta_String, listOfTaxa_, headerPos_];


(* ::Subsection::Closed:: *)
(*Counting missing data*)


(* ::Subsubsection::Closed:: *)
(*For a whole alignment*)


(* ::Text:: *)
(*These functions will calculate the total missing data for an alignment, the mean and StdDev of missing data per site. They can be calculated based on the total number of sequences in the alignment, or a specific number of sequences (if, for example, the alignment is missing taxa with no data). *)
(*Input:*)
(*	align - a nucleotide or amino acid alignment file name or fastaParsed object*)
(*	alignName - a string with the name of your alignment. Only used if passing a fastaParsed object.*)
(*	total - the total number of taxa in the alignment. If not specified, it will calculate this on its own. If specified, valid options are:*)
(*		"Count" - which will do the same as the default;*)
(*		An integer - which specifies how many total taxa you should consider as being the maximum. This is useful if you have deleted empty sequences from your alignment, but want to consider the total number of taxa from a greater set of sequences.*)
(*	dataType - either "nuc" or "aa"; this determines the set of characters considered  as missing data.*)
(*	*)
(*	Output is given in the order: *)
(*	"locus name ", "mean % of missing data per site ", "std dev of msising data per site ", "# of sites missing 100% of data ", "mean % of missing data per taxon ", "std. dev of missing data per taxon ", "# of taxa missing 100% of data".*)


missingDataCalculator[align_String, total_, dataType_String];
missingDataCalculator[align_List, alignName_String, total_, dataType_String]


(* ::Subsubsection::Closed:: *)
(*By taxon*)


(* ::Text:: *)
(*Function 1:*)


(* ::Text:: *)
(*This function calculates the total number of characters, and the % of total characters that are missing or ambiguous.*)
(**)
(*Input is:*)
(*	fasta - a fastaParsed list or a sequence file name.*)
(*	position -  the position in the header that contains the thing you're counting missing data for (i.e. the taxon name)*)
(*	dataType - a string specifying the type of data, which determines what characters are treated as missing. *)
(*		Options are: "nuc" or "aa".*)


taxMissingCharacters[fasta_, position_Integer, dataType_String];


(* ::Text:: *)
(*Function 2:*)
(**)
(*This function takes a list of file names and counts the total and % number of times a taxon appears in the files with entirely missing data.*)
(**)
(*Input is:*)
(*	fileNames - a list of strings specifying the file names for each alignment.*)
(*	position -  the position in the header that contains the thing you're counting missing data for (i.e. the taxon name)*)
(*	OPTIONAL: "Full" - specifying this option in the thrid position will output the list of all the loci for which the taxon has data.*)


taxMissingBlocks[fileNames_List,position_Integer];


taxMissingBlocks[fileNames_List,position_Integer, "Full"];


(* ::Subsection::Closed:: *)
(*Nucleotide compositional bias*)


(* ::Subsubsection::Closed:: *)
(*Total (empirical method)*)


(* ::Text:: *)
(*The function below calculates the prevalence (%) of each nucleotide among all positions with a determined base (doesn't count missing data). It also gives the standard deviation of the percentages, which is a measure of compositional bias.*)
(*Input is:*)
(*	input - a string with the name of the file you want to import. It doesn't have to be aligned and could be in phylip or fasta format. Alternatively, a fastaParsed object, in which case you also need to define "name", which is a string giving the name of the set of sequences.*)
(*	nucs - an optional input consisting of a list of character strings you want to treat as the nucleotides to be counted. Default is: {"A","T","C","G"}*)


compositionalBiasTotal[input_List,name_String, nucs_List];
compositionalBiasTotal[input_List,name_String];
compositionalBiasTotal[input_String, nucs_List];
compositionalBiasTotal[input_String];


(* ::Subsubsection::Closed:: *)
(*By codon position (empirical method)*)


(* ::Text:: *)
(*The function below calculates the prevalence (%) of each nucleotide among all positions with a determined base (doesn' t count missing data).It also gives the standard deviation of the percentages, which is a measure of compositional bias.*)
(**)
(*Input is : *)
(*	fileName - a string with the name of the alignment file you want to import.It can be in phylip or fasta format. Alternatively, a fastaParsed object, in which case you also need to define "name", which is a string giving the name of the set of sequences.*)


compositionalBiasCodons[filename_String];
compositionalBiasCodons[filename_List, name_String];


(* ::Subsubsection::Closed:: *)
(*Total (RCFV method)*)


(* ::Text:: *)
(*One accepted, but simplistic, method of determining base compositional heterogeneity is to calculate "Relative Composition of Frequency Variability" (RCFV). This method is detailed in Zhong, M., Hansen, B., Nesnidal, M., Golombek, A., Halanych, K. M., and Struck, T. H. (2011). Detecting the symplesiomorphy trap: a multigene phylogenetic analysis of terebelliform annelids. BMC Evolutionary Biology, 11(1):369. and the equation for it is: *)


(* ::Text:: *)
(*\!\( *)
(*\*UnderoverscriptBox[\(\[Sum]\), \(i = 1\), \(m\)]\( *)
(*\*UnderoverscriptBox[\(\[Sum]\), \(j = 1\), \(n\)]*)
(*\*FractionBox[\(Abs[*)
(*\*SubscriptBox[\(A\), \(ij\)] - *)
(*\*SubscriptBox[\(A\), \(i\)]]\), \(n\)]\)\)*)


(* ::Text:: *)
(*Where:*)
(*	m is the number of character states (4 for nucleotide data), *)
(*	Subscript[A, ij] is the frequency of character i in taxon j*)
(*	Subscript[A, i] is the frequency of character i in all taxa*)
(*	n is the number of taxa.*)
(**)
(*Simply calculate this by putting your alignment (fastaParsed or file name) into this function.*)


rCFV[alignment_];


(* ::Subsubsection::Closed:: *)
(*By codon position (RCFV method)*)


(* ::Text:: *)
(*See the above section for method description and other information.*)


rCFVCodons[alignment_];


RCFVCodonsexport[alignments_List];


(* ::Chapter::Closed:: *)
(*2. Trees*)


(* ::Subchapter::Closed:: *)
(*Combining tree files*)


(* ::Text:: *)
(*This function combines multiple newick tree files into a single file. The files must all be in the current working directory. *)
(*	*)
(*Parameters:*)
(*	exportFileName - a string representing the name you would like the resulting combined file to be called.*)
(*	treeList - a list of string representing tree files you want to combine that are in the current working directory.*)


combineTrees[exportFileName_, treeList_];


(* ::Subchapter::Closed:: *)
(*Taxon name operations*)


(* ::Subsection::Closed:: *)
(*Swapping taxon names*)


(* ::Text:: *)
(*This function takes a tree file (should work with any format, even an alignment, actually) and swaps the names with a predefined list of names.*)
(**)
(*Input is:*)
(*	input - the name of a file (only tested with RAXML outputted tree files) or a list of files.*)
(*	nameSwapList - the name of a .CSV file with two columns of names. The first column is the list of names in the input file, the second column is the list of names to swap them with.*)


nameSwap[input_String, nameSwapList_String];
nameSwap[input_List, nameSwapList_String]


(* ::Subsection::Closed:: *)
(*Extracting taxon names*)


(* ::Text:: *)
(*This function takes a tree and returns a list of the file names.*)
(**)
(*	The input is:*)
(*		tree - either an imported tree string, or just a tree file name*)
(*		option - can be either "String" if the tree is already imported or "File" if the tree is not yet imported. Default is "File".*)
(*		*)
(*Note: If the following characters are in the taxon names the script will fail: ][)(,:;*)
(**)


extractNamesFromTree[treeFile_];
extractNamesFromTree[treeFile_, "File"];
extractNamesFromTree[treeString_, "String"];
extractNamesFromTree[treeFile_List];


(* ::Subchapter::Closed:: *)
(*Tree stats*)


(* ::Subsection::Closed:: *)
(*Bootstrap statistics (from SumTrees)*)


(* ::Text:: *)
(*The function below takes a tree output by the software SumTrees and gives a summary of the bootstrap scores in the tree. It does this AFTER deleting the "100" support frequencies from the tips (i.e. each lone tip taxon is automaticall given 100% support by SumTrees).*)
(**)
(*Input is: *)
(*	treeName - a string with the name of your sumTrees output tree or a list of file names. If the latter, it outputs the results as a table and takes a list of multiple trees as input.*)


bootstrapsSummary[treeName_];


(* ::Subchapter::Closed:: *)
(*Making Navajo rug plots for node support*)


(* ::Text:: *)
(*This function will output ravajo rug plots which you can then copy-paste into an illustrator program (or save as SVG file) on a tree to show node support. *)
(**)
(*Input is:*)
(*	matrix - an table of values for node support between -1 and 1 with node names in the first column. Normally, values between 0 and 1 are sufficient, but if you calculate internode certainty then you might have negatuve values. NOTE that if your matrix contains negative values, you should round all the numbers to the nearest tenth.*)
(*	rows - an integer representing the number of rows you want to plot. The number of columns your data has, must be evenly divisible by this number.*)
(*	colorFunction - a mathematica colorfunction. If you don't specify, it will default to a predefined function. (see the built-in Mathematica guide/ColorSchemes)*)
(*	*)
(*Output is:*)
(*	A list of nodes with navajo rugs for each.*)
(*	A color legend.*)
(**)
(*NOTE that the color legend starts at -1, even if none of your values are negative. The negative values are specifically defined to be in grayscale, with lighter values closer to zero.*)


navajoRug[matrix_, rows_Integer, colorFunction_];


navajoRug[matrix_, row_];


(* ::Text:: *)
(*This function will output a single rowed ravajo plots which you can then put into an illustrator program on a tree to show node support. *)
(**)
(*Input is:*)
(*	matrix - an table of values for node support between -1 and 1 with node names in the first column. Normally, values between 0 and 1 are sufficient, but if you calculate internode certainty then you might have negatuve values. NOTE that if your matrix contains negative values, you should round all the numbers to the nearest tenth.*)
(*	colorFunction - a mathematica colorfunction. If you don't specify, it will default to a predefined function. (see guide/ColorSchemes)*)
(*	*)
(*Output is:*)
(*	A list of nodes with navajo rugs for each.*)
(*	A color legend.*)
(**)
(*NOTE that the color legend starts at -1, even if none of your values are negative. The negative values are specifically defined to be in grayscale, with lighter values closer to zero.*)


navajoRow[matrix_, colorFunction_];


navajoRow[matrix_];


(* ::Subchapter::Closed:: *)
(*A RADICAL-like function*)


(* ::Text:: *)
(*The software RADICAL (https://www.ncbi.nlm.nih.gov/pubmed/22094860) performs phylogenetic analysis on an alignment that is increasing in size by randomly sampling a selected set of loci. It does this by making successive trees on the increasing alignment. In the end, the goal is to compare all trees to each other, or to a baseline tree. By remwriting the software I can tailor it to my needs. This provides the added benefit of using IQTREE instead of RAXML, because IQTREE is faster and with some more useful options. Additionally, this version does non-random alignment composition in the beginning of the selection process that is necessary because of high proportions of missing data in the alignments. In the end, we will have a set of outputs, but a summary file that can be plotted to show the convergence of the trees from the random concatenation to the baseline trees over time.*)


(* ::Text:: *)
(*The tree comparisons can be done two ways: 1. by the Robinson-Fould's metric, 2. Consensus Fork Index, 3. Mean bootstrap of a summary tree. Since IQTree can calculate 1, it is the simplest option. IQTree+Biosystematica can calculate 3. The function currently only uses 1 but I can easily update it to do 3 or potentially 2. *)


(* ::Text:: *)
(*The constituent functions are in the "subfunctions" section below. But most of them take mostly the same input. The input for the highest level section is as follows:*)
(**)
(*	lociDirectory - a string giving the full directory of the location of the loci to be concatenated. Each locus should be in an individual fasta or phylip alignment file.*)
(*	workingDir - a string giving the full directory of the location where the output folders will be put. Before starting, this folder must contain the iqtree executable and any other files required for iqtree, as well as the baseline tree against which to compare your calculated trees. If you want to compare the calculated trees to each other, there is another end-processing function (computeRFAlltoALL) to handle that.*)
(*	startingSize - an integer representing how many loci you want to have in the initial alignment. As currently written, this value cannot be lower than 6. Default is 15. *)
(*	stepSize - an integer representing how many loci are added upon each concatenation. Default is 5.*)
(*	baselineTree - a string with the exact file name of the baseline tree in your working directory. This will be compared against all other calculated trees to generate the Radical curve.*)
(*	outGroup - the exact taxon name of the outgroup. so that all the trees are easily read in the same way*)
(*	noOfReplicates - the maximum number of times you want to randomly sample all of the loci. Default, 100.*)
(*	checkLength - an integer telling the script how often (in replicates) to check for convergence. Default, 20.*)
(*	*)
(*	NOTE: In the backend there is a version of this that should work on Mac machines, but it hasn't been tested. It can easily be adapted for any OS by changing the way IQTree is called and how pathnames are written in the terminal. But you must edit the original function to make it work.*)


radicalRun[lociDirectory_String, workingDir_String,startingSize_Integer, stepSize_Integer, 
baselineTree_String, outGroup_String, noOfReplicates_Integer, checkLength_Integer];

radicalRun[workingDir_String, baselineTree_String, outGroup_String]


(* ::Chapter::Closed:: *)
(*3. Other Software*)


(* ::Subsection::Closed:: *)
(*Import RAXML partition file*)


(* ::Text:: *)
(*This function will import a RAXLM partition file and reformat it into a table. It will either process the partition file as containing loci (where block definitions are sequential) or codons (where block definitions are broken up by codon position).*)
(**)
(*Input:*)
(*	partitions - a string specifying the name of a RAXML style partition file.*)
(*	parse method - either "Loci" or "Codons". See explanation above.*)


partitionFileImporter[partitions_, "Loci"];

partitionFileImporter[partitions_, "Codons"];


(* ::Subsection::Closed:: *)
(*Extracting partitionfinder locus blocks from output*)


(* ::Text:: *)
(*This function takes the "best_schemes.txt" output from partition finder and processes it into a number of files, which will tell you the partition assignments of your loci, and the number of loci in each partition.*)
(**)
(*Input:*)
(*	fileName - "best_schemes.txt" or the name of the partitionfinder best schemes file in the working directory.*)


pFinderSchemesProcess[fileName_String];


(* ::Subsection::Closed:: *)
(*Matching partitionFinder schemes with a Biosystematica RAXML_part file*)


(* ::Text:: *)
(*Anytime you concatenate an alignment in Biosystematica, you also output a RAXML style partitions file. You can use this to specify blocks in partitionFinder. partitionFinder then lumps them based on its analysis and you can use their output to partition your analysis.*)
(**)
(*However, when you have a very large alignment, with many partitions, and then you edit the original alignments, your partition file no longer matches the lengths of the actual partititions. This function fixes that.*)
(**)
(*In order for this to work, you need to have the output of the Biosystematica concatenation and the pFinder "best_scheme.txt" output in the working directory. Just invoking the function with no options will run the script assuming the default file names. Specifying the input, you can put renamed files.*)
(**)
(*Input is:*)
(*	bioInformaticaRAXMLPart - a string specifying the "RAXMLPart.txt" file from the concatenation output.*)
(*	pFinderBestsSchemes - a string specifying the name of the best schemes output from pFinder.*)


matchPartitionFormat[bioInformaticaRAXMLPart_String, pFinderBestsSchemes_String];


(* ::Section::Closed:: *)
(*NOTE on Section 3.*)


(* ::Text:: *)
(*In the Backend there are more functions contained in this section that are not included here. They are for very specific uses that may not be of interest to a lot of people. Also, they are not "stand-alone" in the sense that they require other software to complete their work-flows. *)
(**)
(*I am including the scripts in this notebook in case they are of use to myself or others. However, I do not include them in the front-end of the package because I have not confirmed that the scripts works and I do not want to make them user-friendly because they are difficult to test.*)


(* ::Title::Closed:: *)
(*Backend*)


(* ::Subsubsection::Closed:: *)
(*Dev. notes*)


(* ::Text:: *)
(*Use the following pattern condition to define a fastaParsedObject in a custom function slot definition.*)


(* ::Input:: *)
(*fasta_/;(ListQ[fasta]&&(Length[fasta[[1]]]>0)&&StringQ[fasta[[2]]])*)


(* ::Text:: *)
(*Or it's possible this condition can be used with the below form of Condition and function defintions.*)


(* ::Input:: *)
(*(*{*)
(* {, lhs:=rhs/;test*)
(*is a definition to be used only if test yields True. }*)
(*}*)*)


(* ::Chapter::Closed:: *)
(*Sequence file functions*)


(* ::Subchapter::Closed:: *)
(*File operations *)


(* ::Text:: *)
(*The functions in this section act on files at the highest level only (not modifying sequences). The first section acts only on file structure and the second section acts on file contents (but not sequence contents)*)


(* ::Section::Closed:: *)
(*Trival (e.g. file import, export, converting formats, moving, mending) *)


(* ::Subsection::Closed:: *)
(*Importing, parsing and exporting FASTA or Phylip files*)


(* ::Subsubsection::Closed:: *)
(*Import*)


(* ::Text:: *)
(*Input format is a string that contains the textfile version of the FASTA file. In accordance with genBank conventions,  the parts of the header are considered to be are separated by "|" and ";"*)


importAlignment[filename_]:=importAlignment[Directory[], filename]


importAlignment[directory_, fileName_]:=Block[{align, type, output},
align=Import[directory<>"//"<>fileName, "Text"];
If[StringContainsQ[align, ">"], type="FASTA";, type="PHYLIP";];
Which[type=="FASTA", output=fastaParser[align];, 
type=="PHYLIP", output=phylipParser[align];];
output
]


importAlignment[directory_, "ImportTogether"]:=Block[{fn},
SetDirectory[directory];
fn=FileNames[];
Flatten[importAlignment[directory, #]&/@fn, 1]
]


importAlignment[listOfNames_List, "ImportTogether"]:=Block[{fn},
Flatten[importAlignment[#]&/@listOfNames, 1]
]


fastaParser[fastaString_]:=Block[{seqBlock, front, back, all, head},
seqBlock=StringSplit[fastaString//StringTrim, ">"];
all=StringSplit[#, "
"]&/@seqBlock;
front=all[[All, 1]];
back=(StringDelete[Drop[#, 1], WhitespaceCharacter]//StringJoin)&/@all;
head=StringTrim/@(DeleteCases[StringSplit[StringReplace[#, "."->" "], {"|", ";"}], {" ", "
"}]&/@front);
{head, back}//Transpose
]


(* ::Text:: *)
(*This is the same as above but now you can define the delimiters.*)


fastaParser[fastaString_, {delimiters__}]:=Block[{seqBlock, front, back, all, head},
seqBlock=StringSplit[fastaString//StringTrim, ">"];
all=StringSplit[#, "
"]&/@seqBlock;
front=all[[All, 1]];
back=(StringDelete[Drop[#, 1], WhitespaceCharacter]//StringJoin)&/@all;
head=StringTrim/@(DeleteCases[StringSplit[StringReplace[#, "."->" "], {delimiters}], {" ", "
"}]&/@front);
{head, back}//Transpose
]


(* ::Text:: *)
(*The function below creates a "fasta list" style object when importing a phylip formatted file.*)


phylipParser[phylipString_]:=Block[{},
{{#[[1]]//StringTrim},#[[2]]//StringTrim }&/@Partition[Drop[StringSplit[phylipString], 2], 2]
]


(* ::Subsubsection::Closed:: *)
(*Output*)


(* ::Text:: *)
(*The functions below takes the format that is the same as the output of the above*)


fastaOutput[fpOUT_]:=Block[{heads, backs},
(*(*Here's an older version that worked well but put spaces between the fasta entries and at the end of the fasta header, which causes an error in some R software*)

heads=fpOUT[[All, 1]];
backs=fpOUT[[All, 2]];
heads=" 
>"<>StringJoin[Riffle[#//StringTrim, "|"]]<>" 
"&/@heads;
StringTrim[Riffle[("
"<>#&/@heads), (StringTrim/@backs) ]//StringJoin]*) 
heads=fpOUT[[All, 1]];
backs=fpOUT[[All, 2]];
heads=">"<>StringJoin[Riffle[#//StringTrim, "|"]]<>"
"&/@heads;
StringTrim[Riffle[(#&/@heads), (StringJoin[StringTrim[#], "
"]&/@backs) ]//StringJoin]
]


fastaOutput[fpOUT_, delimiter_]:=Block[{heads, backs},
heads=fpOUT[[All, 1]];
backs=fpOUT[[All, 2]];
heads=" 
>"<>StringJoin[Riffle[StringTrim/@#, delimiter]]<>" 
"&/@heads;
StringTrim[Riffle[("
"<>#&/@heads), (StringTrim/@backs) ]//StringJoin]
]


(* ::Text:: *)
(*The function below will take a name and a fastaParsed object and export it to the working directory. The fileName MUST have some kind of file name extension (suffix). Otherwise it won't work.*)


fastaExport[fileName_String,fastaParsed_List]:=
Export[fileName//exportFileRename, fastaParsed//fastaOutput, "Text"]


fastaExport[fileNames_List, fastaParsedLists_List]:=Block[{temp},
temp=Partition[Riffle[fileNames, fastaParsedLists], 2];
fastaExport[#[[1]], #[[2]]]&/@temp
]


(* ::Text:: *)
(*This function is just an easy way to switch the file name based on the file type suffix. If it is a .fas it turns it into a .fasta. even if you import it as a .nex, or .phy it will still export it as .fas, so this only works if you export as FASTA file type. It actually still does work but the file name would misrepresent the actual contents of the file.*)


exportFileRename[fileName_]:=Block[{split},
suffix=Take[(split=StringSplit[fileName, "."]), -1][[1]];
If[suffix=="fas", nSuf=".fasta",  nSuf=".fas"];
If[(split//Length)>2, Riffle[Drop[split,-1], "."]//StringJoin, 
Drop[split,-1][[1]]
]<>nSuf]


exportFileRenamePhylip[fileName_]:=Block[{split},
suffix=Take[(split=StringSplit[fileName, "."]), -1][[1]];
If[suffix=="phy", nSuf=".phylip",  nSuf=".phy"];
If[(split//Length)>2, Riffle[Drop[split,-1], "."]//StringJoin, 
Drop[split,-1][[1]]
]<>nSuf]


(* ::Text:: *)
(*The function below will take a fastaParsed object and export it as a PHYLIP file. The input is:*)
(*fastaParsed - a fastaParsed list*)
(*headerPosition - an integer representing the part of the fasta header you want to turn into the phylip headers. Usually this will be the taxon name.*)
(*padLength - the amount of whitespace you want after your taxon name. This should be some number greater than the longest taxon name.*)


toPhylip[fastaParsed_, headerPosition_, padLength_]:=Block[{},
( 

StringJoin[#,"
"]&/@Prepend[

(StringJoin[StringPadRight[#[[1, headerPosition]],padLength ],#[[ 2]]]&/@fastaParsed)

, StringJoin[ToString[fastaParsed//Length], "\t",ToString[ fastaParsed[[1, 2]]//StringLength]]]

)//StringJoin
]


toPhylip[fastaParsed_]:=toPhylip[fastaParsed, 1, 70]


toPhylip[fastaParsed_, padLength_]:=toPhylip[fastaParsed, 1, padLength]


phylipExport[fileName_String, fastaParsed_,headerPos_Integer, padLength_Integer]:=Export[fileName//exportFileRenamePhylip, 
toPhylip[fastaParsed, headerPos, padLength]
, "Text"]


phylipExport[fileNames_List, fastasParsed_List,headerPos_Integer, padLength_Integer]:=Block[{temp},
temp=Partition[Riffle[fileNames,fastasParsed], 2];
phylipExport[#[[1]], #[[2]],headerPos, padLength]&/@temp
]


phylipExport[fileNames_List, fastasParsed_List]:=Block[{temp},
temp=Partition[Riffle[fileNames,fastasParsed], 2];
phylipExport[#[[1]], #[[2]]]&/@temp
]


phylipExport[fileNames_List, fastasParsed_List,padLength_Integer]:=Block[{temp},
temp=Partition[Riffle[fileNames,fastasParsed], 2];
phylipExport[#[[1]], #[[2]]]&/@temp
]


phylipExport[fileName_String, fastaParsed_]:=Export[fileName//exportFileRenamePhylip, 
toPhylip[fastaParsed, 1, 70]
, "Text"]


phylipExport[fileName_String, fastaParsed_, padLength_]:=Export[fileName//exportFileRenamePhylip, 
toPhylip[fastaParsed, 1, padLength]
, "Text"]


(* ::Subsection::Closed:: *)
(*Alignment file conversion*)


alignmentFileConverter[FILENAME_String,headerPos_Integer,  outFormat_String]:=Block[{temp, outTemp, suffix, out,pad,exp},
temp=importAlignment[FILENAME];
(*outTemp=Switch[inFormat, 
(*FASTA*)
"FASTA", fastaParser[temp],
"fasta", fastaParser[temp],
"Fasta", fastaParser[temp],
".fas", fastaParser[temp],
".fst", fastaParser[temp],
(*Phylip*)
"PHY", phylipParser[temp],
"phy", phylipParser[temp],
"PHYLIP", phylipParser[temp],
"Phylip", phylipParser[temp],
"phylip", phylipParser[temp],
".phy", phylipParser[temp]*)
(*to add: NEXUS*)
(*];*)
(*now to determine the ouput format*)
out=Switch[outFormat, 
(*FASTA*)
"FASTA", suffix=".fas";fastaOutput[temp],
"fasta", suffix=".fas";fastaOutput[temp],
"Fasta",suffix=".fas"; fastaOutput[temp],

(*Phylip*)
pad=70;
"PHYLIP", suffix=".phy";toPhylip[temp, headerPos, pad],
"Phylip",suffix=".phy"; toPhylip[temp, headerPos, pad],
"phylip",suffix=".phy"; toPhylip[temp, headerPos, pad],
"phy",  suffix=".phy";toPhylip[temp, headerPos, pad],
"PHY",  suffix=".phy";toPhylip[temp, headerPos, pad]
(*to add: NEXUS*)
];
If[outFormat=="Nexus",suffix=".nex";out= temp[[All, 2]];exp="nexus", exp="other"];

Switch[exp,
"other",
Export[
(Riffle[Drop[StringSplit[FILENAME, "."],-1], "."]//StringJoin)<>suffix,out,"String"],
"nexus",
Export[
(Riffle[Drop[StringSplit[FILENAME, "."],-1], "."]//StringJoin)<>suffix,out,"Nexus"]]
]


sequenceFileConverter[FILENAME_String,headerPos_Integer,  outFormat_String]:=alignmentFileConverter[
FILENAME,headerPos,  outFormat]


sequenceFileConverter[FILENAME_List,headerPos_Integer, outFormat_String]:=alignmentFileConverter[
#,headerPos,  outFormat]&/@FILENAME


(* ::Subsection::Closed:: *)
(*Mending FASTA files with misread headers or empty data*)


(* ::Text:: *)
(*The function below combines the two other functions in this section, and modifies it to import and export the files automatically.*)
(**)
(*NOTE: Update this function so it works with fastaParsed objects, lists of illegal characters, and protein data.*)


mendFastaFile[fileName_String, illegalCharacter_String]:=Block[{fasta},
fasta=fileName//importAlignment;
fasta=removeEmpties[fasta];
fHeadSpill[fasta, illegalCharacter];
Export[fileName//exportFileRename, fasta//fastaOutput, "Text"];
]


mendFastaFile[fileName_String, illegalCharacter_String, "Hold"]:=Block[{fasta},
fasta=fileName//importAlignment;
fasta=removeEmpties[fasta];
fHeadSpill[fasta, illegalCharacter]
]


mendFastaFile[fileName_List, illegalCharacter_String]:=mendFastaFile[#, illegalCharacter]&/@fileName


mendFastaFile[fileName_List, illegalCharacter_String, "Hold"]:=mendFastaFile[#, illegalCharacter, "Hold"]&/@fileName


mendFastaFile[fileName_String, illegalCharacter_String, legalChars_List]:=Block[{fasta},
fasta=fileName//importAlignment;
fasta=removeEmpties[fasta];
fHeadSpill[fasta, illegalCharacter,legalChars];
Export[fileName//exportFileRename, fasta//fastaOutput, "Text"];
]


mendFastaFile[fileName_String, illegalCharacter_String, legalChars_List, "Hold"]:=Block[{fasta},
fasta=fileName//importAlignment;
fasta=removeEmpties[fasta];
fHeadSpill[fasta, illegalCharacter,legalChars]
]


mendFastaFile[fileName_List, illegalCharacter_String,legalChars_List]:=mendFastaFile[#, illegalCharacter,legalChars]&/@fileName


mendFastaFile[fileName_List, illegalCharacter_String,legalChars_List, "Hold"]:=mendFastaFile[#, illegalCharacter,legalChars, "Hold"]&/@fileName


(* ::Text:: *)
(*The function below will read a FASTA file, and rewrite it with a corrected FASTA header format. It only works for FASTA files that have had headers spill over into the beginning of the sequence. Also, it only reconigzes the FIRST instance of a DNA character after the spilled part of the header.*)
(**)
(*NOTE that this has only been tested with illegal characters of String Length 1.*)


fHeadSpill[fastaParsed_, illegalCharacter_String, legalChars_List]:=Block[{legalCharacters},
legalCharacters=legalChars;(*{"A","T","C","G","a","t","c","g","N","?","-"}*)
Block[{newSeq, newHead, bad, good},
newSeq=#[[2]];
newHead=#[[1]];
If[StringContainsQ[newSeq, illegalCharacter],Goto["fixCode"];, Goto["returnSeq"];];

Label["fixCode"];
bad=StringPosition[newSeq, illegalCharacter][[1, 2(*this might need to be changed*)]];
good=Select[(StringPosition[newSeq, legalCharacters][[All, 1]]),#>bad &][[1]];
newHead=Append[newHead,StringTake[newSeq, {1, good-1}]];
newSeq=StringTake[newSeq, {good, StringLength[newSeq]}];

Label["returnSeq"];
{newHead, newSeq}
]&/@fastaParsed
]


fHeadSpill[fastaParsed_, illegalCharacter_String]:=fHeadSpill[fastaParsed, illegalCharacter, 
{"A","T","C","G","a","t","c","g","N","?","-"}]


(* ::Text:: *)
(*The function below takes a fastaParsed object as input, finds all cases where the sequence section is empty, and deletes it.*)


removeEmpties[fasta_]:=Block[{a},
If[
Length[(a=Position[fasta[[All, 2]], ""])]<1,fasta, Delete[fasta,Partition[a[[All, 1]], 1]]]
]


(* ::Subsection::Closed:: *)
(*Renaming FASTA files*)


(* ::Text:: *)
(*The code below will rename fasta files by prepending a block from the fasta headers. Note that the fasta file MUST contain THE SAME value in all the headers at that block.*)


prependFastaFileName[directory_String, filenames_, fastaPartToPrepend_Integer]:=Block[{},
SetDirectory[directory];
(RenameFile[#,((Import[#, "String"]//fastaParser)[[All, 1]][[ All, fastaPartToPrepend]]//Union)[[1]]<>"_"<>#])&/@filenames
]


(* ::Text:: *)
(*The code below will entirely rename a file using the FASTA headers by making a copy*)


renameFastaWH[directory_String, filenames_, fastaPartsToCompose_List, fileExtension_String]:=Block[{},
SetDirectory[directory];


(CopyFile[#,Riffle[((Import[#, "String"]//fastaParser)[[All, 1]][[ All, fastaPartsToCompose]]//Union)[[1]], "."]<>"."<>(*StringTake[StringSplit[ToString[SessionTime[]], "."][[2]], 3]<>*)fileExtension])
&/@filenames
]


(* ::Subsection::Closed:: *)
(*Move a subset of files*)


(* ::Text:: *)
(*This function compares a file list against a list of names and takes the files with names shared by the list and moves them to a new folder.*)
(**)
(*Input:*)
(*	fileDir - the string name of the directory your files are in*)
(*	nameList - the list of the files you want to move*)
(*	folderName - a string that will be the name of the directory you want to move the files to.*)


moveFiles[fileDir_String,nameList_List, folderName_String]:=Block[{fileDirectory, moveDirectory, filePositon, deleteList},
fileDirectory=SetDirectory[fileDir];
moveDirectory=CreateDirectory[ParentDirectory[]<>"\\"<>folderName];
Table[
filePositon=(Position[StringContainsQ[#, nameList[[i]] ]&/@FileNames[], True]//Flatten)[[1]];

CopyFile[fileDirectory<>"\\"<>FileNames[][[filePositon]],moveDirectory<>"\\"<>FileNames[][[filePositon]]];
(*DeleteFile[fileDirectory<>"\\"<>FileNames[][[filePositon]]];*)

, {i, 1, Length[nameList]}];
SetDirectory[ParentDirectory[]<>"\\"<>folderName];
deleteList=FileNames[];
SetDirectory[fileDir];
DeleteFile[#]&/@deleteList
]


(* ::Subsection::Closed:: *)
(*Getting sequence lengths*)


(* ::Text:: *)
(*The function below will return a list of the number of characters for each sequence. It works for sequence files and alignments. For alignments, it will return one number, or a list of Unioned numbers.*)
(**)
(*Input is:*)
(*	alignment - a sequence or alignment in fastaParsed format or a file name*)
(*	option: "Alignment" - if used it will treat the sequence file as an alignment.*)


getSequenceLengths[alignment_List]:=Block[{},
(StringLength/@alignment[[All, 2]])
]


getSequenceLengths[alignment_String]:=Block[{},
getSequenceLengths[alignment//importAlignment]
]


getSequenceLengths[alignment_List, "Alignment"]:=Block[{},
(StringLength/@alignment[[All, 2]])//Union
]


getSequenceLengths[alignment_String, "Alignment"]:=Block[{},
getSequenceLengths[alignment//importAlignment, "Alignment"]
]


(* ::Section::Closed:: *)
(*Non-trivial (e.g.: file merging, splitting; sequence sorting, extraction, renaming, cutting)*)


(* ::Subsection::Closed:: *)
(*Sorting sequence files by their header*)


(* ::Text:: *)
(*This simple function will sort a sequence file so that the entries are in a sorting order of whatever header block you specify. *)
(**)
(*Input is:*)
(*	fileName -  either a sequence file name or a list of sequence files.*)
(*	position  - an integer specifying the position in the header to search through the file. Default is 1, if not specified.*)
(*	option: "Hold" - specifying this option will output a fastaParsed object. Otherwise the script exports a new file.*)


sortFASTA[fileName_String, position_, "Hold"]:=Block[{},
SortBy[importAlignment[fileName], #[[1, position]]&]
]


sortFASTA[fileName_String, position_]:=Block[{},
fastaExport[fileName,SortBy[importAlignment[fileName], #[[1, position]]&]]
]


sortFASTA[fileName_String, "Hold"]:=Block[{},
SortBy[importAlignment[fileName], #[[1, 1]]&]
]


sortFASTA[fileName_String]:=Block[{},
fastaExport[fileName,SortBy[importAlignment[fileName], #[[1, 1]]&]
]]


sortFASTA[fileNames_List, position_, "Hold"]:=sortFASTA[#,position, "Hold"]&/@fileNames


sortFASTA[fileNames_List, "Hold"]:=sortFASTA[#, "Hold"]&/@fileNames


sortFASTA[fileNames_List]:=sortFASTA[#]&/@fileNames


sortFASTA[fileNames_List,position_]:=sortFASTA[#,position]&/@fileNames


(* ::Subsection::Closed:: *)
(*Pooling FASTA files and redistributing by a FASTA header *)
(*(usually, taxon FASTAs to gene FASTAs)*)


(* ::Text:: *)
(*If you have a collection of fasta files that each represent one taxon, with multiple sequences in each, sometimes you want to reorganize those by the genes within the taxa. It doesn't even have to be taxa files and genes within. The function below pools any collection of fasta files (in the same folder) bunches them by one of the features in the fasta header, and outputs them by the number of unique features. It could be accession numbers, taxon names, gene names, domain names or anything else. *)
(**)
(*Example explanation: Say you are interested in aligning orthologous sequences for 80 taxa using some software (e.g. MAFFT or MUSCLE). The files you have are transcriptome libraries for 80 taxa. The files each contain 7000 orthologous sequences from a single taxon. The function "taxFilesToGenes" will take all of those 80 files and turn them into 7000 files, each file containing an orthologous set of sequences. Thus, each file is now alignable and can subsequenly be used in a phylogenetic analysis.*)
(**)
(*Input:*)
(**)
(*	taxFileDirectory - a string representing where the original files are*)
(*	geneHeaderPosition - an integer representing the position in the FASTA header that you want to sort by.*)
(*	outDirectory - a string representing the directory you want to output the files to.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


taxFilesToGenes[taxFileDirectory_String,geneHeaderPosition_Integer,outDirectory_String]:=Block[{IA, GB},
SetDirectory[taxFileDirectory];
(*importing all the taxon files*)
IA=importAlignment[#]&/@FileNames[];
GB=GatherBy[Flatten[IA, 1], #[[1, geneHeaderPosition]]&];
Export[outDirectory<>"\\"<>ToString[#[[1, 1, geneHeaderPosition]]  ]<>".fasta",#//fastaOutput, "Text"]&/@GB
]


taxFilesToGenes[taxFileDirectory_String,geneHeaderPosition_Integer,outDirectory_String, "Hold"]:=Block[{IA, GB},
SetDirectory[taxFileDirectory];
(*importing all the taxon files*)
IA=importAlignment[#]&/@FileNames[];
GB=GatherBy[Flatten[IA, 1], #[[1, geneHeaderPosition]]&];
#&/@GB
]


(* ::Subsection::Closed:: *)
(*Merging FASTA files *)


(* ::Text:: *)
(*This is vertical merging, not horizontal merging, like you might want to do with an alignment.*)


(* ::Subsubsection::Closed:: *)
(*Merging 2 fasta files*)


(* ::Text:: *)
(*file1 - The FASTA file to go at the beginning of the new file*)
(*file2 - The FASTA file to go at the end of the new file*)
(*exportFNAME - If you specify this it will export to a text file of this name*)


fastaMerge[file1_, file2_]:=Block[{fast1, fast2},
fast1=Import[file1, "Text"]//fastaParser;
fast2=Import[file2, "Text"]//fastaParser;
Print["Obj. 'newfasta' created."];
newfasta=Flatten[Append[{fast1}, fast2], 1]
]


fastaMerge[file1_, file2_, exportFNAME_]:=Block[{fast1, fast2},
fast1=Import[file1, "Text"]//fastaParser;
fast2=Import[file2, "Text"]//fastaParser;
newfasta=Flatten[Append[{fast1}, fast2], 1];
Print["Obj. 'newfasta' created."];
Export[exportFNAME, newfasta//fastaOutput, "Text"]
]


fastaMerge[file1_, file2_, "Hold"]:=fastaMerge[file1, file2]


(* ::Subsubsection::Closed:: *)
(*Merging more than 2 fasta files*)


(* ::Text:: *)
(*fastaFileList - a list of the file names in the working directory that can be imported as a fastaParsed object.*)
(*DeleteDups (TRUE, FALSE; default = TRUE) - a boolean value telling the script if you want to delete duplicate sequences. There's really no reason to ever specify FALSE, so TRUE is a default option.*)
(*exportFNAME - If you specify this it will export to a text file of this name*)


fastaMergeAll[fastaFileList_]:=Block[{}, 
newfasta=Join[Flatten[(importAlignment[#]&/@fastaFileList), 1]];
 newfasta=newfasta//Union;
Print["Obj. 'newfasta' created."];
]


fastaMergeAll[fastaFileList_, "Hold"]:=fastaMergeAll[fastaFileList]


fastaMergeAll[fastaFileList_, exportFNAME_]:=Block[{}, 
newfasta=Join[Flatten[(importAlignment[#]&/@fastaFileList), 1]];
 newfasta=newfasta//Union;
Export[exportFNAME, newfasta//fastaOutput, "Text"];
]


fastaMergeAll[fastaFileList_, exportFNAME_, DeleteDups_]:=Block[{}, 
newfasta=Join[Flatten[(importAlignment[#]&/@fastaFileList), 1]];
If[DeleteDups, newfasta=newfasta//Union, Null;];
Export[exportFNAME, newfasta//fastaOutput, "Text"];
]


(* ::Subsection::Closed:: *)
(*Deleting duplicate FASTA entries*)


(* ::Text:: *)
(*If the FASTA entries are exactly duplicate, you don't need to make a new function for this. Use the built in Mathematica Union[] function on a fastaParsed object.*)


Union[];


(* ::Text:: *)
(*If the FASTA entries are duplicate in the sequence only (the headers are different) you can use this function. It will merge all entries that have the exact same sequence information, and one entry in the FASTA header (e.g. the taxon name) are the same.*)
(**)
(*Input:*)
(*	fastaFile - a fasta file name or fastaParsed object with potential duplicate sequences.*)
(*	headerGuide - an integer representing the position in the FASTA header you want to choose as the guide to make sure your comparing among the sequences you want to be comparing. *)
(*	option: "Hold" - if you are supplying a file name but don't want the results to be exported as a new file, specify this option.*)
(*	*)
(*	Note: If a fileName is specified the output will be a newly exported fasta file.*)


unionFasta[fastaParsed_List, headerGuide_Integer]:=Block[{gathered},
gathered=GatherBy[fastaParsed,#[[1,  headerGuide]]& ];
Flatten[
(Block[{print, part, dups, k},
part=#;
If[
((dups=part[[All, 2]]//Union)//Length)<(part[[All, 2]]//Length), Goto["reduce"];, Goto["next"];];
(*tests if there is more than one of the same sequence at all in the set delimited by the "header guide"*)
Label["reduce"];
print=#[[
(Position[part, #]&/@dups)[[All, 1]][[All, 1]]
(*takes the first instance of each unique entry*)
]];
Goto["end"];
Label["next"];
print=#;
Label["end"];
print]&/@gathered), 1]]


unionFasta[fastaFile_String, headerGuide_Integer]:=fastaExport[fastaFile,unionFASTA[fastaFile//importAlignment, headerGuide]]


unionFasta[fastaFile_String, headerGuide_Integer, "Hold"]:=unionFasta[fastaFile//importAlignment, headerGuide]


(* ::Text:: *)
(*This function is the same as the above but can be used for mutliple files at once.*)


unionFastaAll[fastaFiles_List, headerGuide_Integer]:=unionFasta[#, headerGuide]&/@fastaFiles


unionFastaAll[fastaFiles_List, headerGuide_Integer, "Hold"]:=unionFasta[#, headerGuide, "Hold"]&/@fastaFiles


(* ::Text:: *)
(*See Alignment Manipulation section for another script that works on alignments*)


(* ::Subsection::Closed:: *)
(*Extracting a single sequence from a large FASTA file*)


(* ::Text:: *)
(*This function is for extracting a sequence based on an exact string in its header.*)
(**)
(*This only works when the header you are searching for is unique. If it is not unique it will only find the first instance of it.*)
(**)
(*Input is:*)
(*	fString - a sequence file name, or a fastaParsed object.*)
(*	header - the exact header string you want to extract the sequence for.*)


fastaExtract[fString_, header_String]:=Block[{},
{header, StringReplace[StringSplit[StringSplit[fString, header//StringTrim][[2]], ">"][[1]], WhitespaceCharacter->""]}

]


(* ::Text:: *)
(*more general version that works on files*)


sequenceExtract[file_String, header_String]:=fastaExtract[importAlignment[file]//fastaOutput, header]


sequenceExtract[file_String, header_String, "Hold"]:=fastaExtract[importAlignment[file]//fastaOutput, header]


sequenceExtract[file_list, header_String]:=fastaExtract[file//fastaOutput, header]


(* ::Subsection::Closed:: *)
(*Limiting an FASTA file to a specific sublist of taxa*)


(* ::Text:: *)
(*NOTE to DE: I can make this work for very very large files (GB's) by using OpenRead. It may not be faster but it's way more memory efficient.*)


(* ::Text:: *)
(*The function below can limit a set of sequences to a predefined subset of taxa. It can do this in one of two ways. 1. By making a fastaParsed object with only those taxa. 2. By turning all OTHER taxa into blank sequences.*)
(*	full - the full alignment in FASTA parsed format or a file name.*)
(*	keepSet - the list of taxa you want to keep. Need to be exact matches to the others in the alignment. Note that the names you give here can be present in any position of the FASTA header. *)
(*	method:*)
(*		"method1" -  makes a fastaParsed object with only those taxa.*)
(*		"method2" - turns all OTHER taxa into blank sequences.*)


limitSeqList[full_List, keepSet_List, method_String]:=
Block[{newAlign,keeps, deletes, toDelete, deleted, len,fullNewAlign},

Switch[method,
"method1",
(*METHOD 1: extracting the taxa you want*)
newAlign=full[[(Position[full,#]&/@keepSet)[[All, All, 1]]//Flatten]]
 ,
"method2",
(*METHOD 2: blanking out the taxa you don't want*)
keeps=(Position[full,#]&/@keepSet)[[All, All, 1]]//Flatten;
deletes =Complement[ Range[full//Length], keeps];
toDelete=full[[deletes]];
deleted=Table[
len=toDelete[[i, 2]]//StringLength;
{toDelete[[i, 1]], StringRepeat["?",len]}
,{i, 1, Length[toDelete]}];
fullNewAlign=
SortBy[Partition[Flatten[{Flatten[newAlign, 1],Flatten[deleted , 1]}, 1], 2], First]]
]



limitSeqList[full_String, keepSet_List, method_String]:=fastaExport[full,limitSeqList[full//importAlignment, keepSet, method]]


limitSeqList[full_String, keepSet_List, method_String,"Hold"]:=limitSeqList[full//importAlignment, keepSet, method]


(* ::Subsection::Closed:: *)
(*Deleting specific entries from sequence file*)


(* ::Text:: *)
(*The limitSeqList function can be used for this as well but I think this function is a little easier and more intuitive.*)


(* ::Text:: *)
(*The functions below will delete entries from a FASTA list that have the specified name or names in the specified position of the sequence header.*)
(**)
(*Input is*)
(*	fasta - either a fastaParsed object or a sequence file.*)
(*position - an integer indicating which position in the sequence header to look for the deleted string*)
(*	text - a string or a list of strings exactly matching the entries you want to delete in the sequence file.*)


deleteFastaEntry[fasta_String, position_Integer, text_String, "Hold"]:=Block[{fastaP,fastaD},
fastaP=importAlignment[fasta];
fastaD=Delete[fastaP, Position[fastaP[[All, 1, position]], text]]
]


deleteFastaEntry[fasta_String, position_Integer, text_String]:=Block[{fastaP,fastaD},
fastaExport[fasta,deleteFastaEntry[fasta, position, text, "Hold"]]
]


deleteFastaEntry[fasta_List, position_Integer, text_String]:=Block[{},
Delete[fasta, Position[fasta[[All, 1, position]], text]]
]


deleteFastaEntry[fasta_List, position_Integer, text_List]:=Block[{},
Delete[fasta,Flatten[Position[fasta[[All, 1, position]], #]&/@text, 1]]
]


deleteFastaEntry[fasta_String, position_Integer, text_List]:=Block[{fastaP,fastaD},
fastaP=importAlignment[fasta];
fastaD=Delete[fastaP,Flatten[Position[fastaP[[All, 1, position]], #]&/@text, 1]];
fastaExport[fasta,fastaD]
]


(* ::Subsection::Closed:: *)
(*Renaming FASTA headers*)


(* ::Text:: *)
(*The code below will add the specified string at the desired fasta block in all sequences. It has the same options as the "Insert" function.*)


insertIntoFastaHeader[fasta_List,string_, position_]:=Block[{},
{Insert[#[[1]], string, position], #[[2]]}&/@fasta
]


insertIntoFastaHeader[fasta_String,string_, position_]:=Block[{},
fastaExport[fasta, {Insert[#[[1]], string, position], #[[2]]}&/@importAlignment[fasta]]
]


insertIntoFastaHeader[fasta_String,string_, position_, "Hold"]:=Block[{},
{Insert[#[[1]], string, position], #[[2]]}&/@importAlignment[fasta]
]


(* ::Text:: *)
(*The code below will delete a part of a fasta header in all sequences. It will also save the position you are deleting under the object name "headerCut".*)


removeFromFastaHeader[fasta_List,position_ ]:=Block[{},
headerCut=(#[[1]][[position]]&/@fasta);
{Delete[#[[1]], position], #[[2]]}&/@fasta


removeFromFastaHeader[fasta_String,position_,"Hold"]:=removeFromFastaHeader[fasta//importAlignment,position]


removeFromFastaHeader[fasta_String,position_]:=fastaExport[fasta,removeFromFastaHeader[fasta//importAlignment,position]]






(* ::Text:: *)
(*The function below will move part of a fasta header from one position to another. To move more than one position, iterate this over your parsed fasta object more than once.*)


rearrangeFastaHeader[fasta_List, fromPosition_-> toPosition_]:=Block[{a},
a=removeFromFastaHeader[fasta,fromPosition ];
Table[
{Insert[a[[i, 1]], headerCut[[i]], toPosition], a[[i,2]]}, {i, 1, Length[headerCut]}]

]


rearrangeFastaHeader[fasta_String, fromPosition_-> toPosition_, "Hold"]:=rearrangeFastaHeader[fasta//importAlignment, fromPosition-> toPosition]


rearrangeFastaHeader[fasta_String, fromPosition_-> toPosition_]:=fastaExport[fasta, rearrangeFastaHeader[fasta//importAlignment, fromPosition-> toPosition]]


keepOnlyFastaHeader[fasta_List,position_ ]:=Block[{headerKeep},
headerKeep=(#[[1]][[position]]&/@fasta);
{#[[1, position]], #[[2]]}&/@fasta
]


keepOnlyFastaHeader[fasta_String,position_ ]:=keepOnlyFastaHeader[fasta//importAlignment,position ]



(* ::Subsection::Closed:: *)
(*Removing tokens from header names*)


(* ::Text:: *)
(*Some software (like MAFFT) will add tokens to taxon names under certain circumstances. The below function can fix this.*)


(* ::Text:: *)
(*Parameters:*)
(*alignment - will take either a fasta/phylip file, or a fastaParsed object.*)
(*token - is the exact substring you want removed from the taxon header (e.g. "_R_" from MAFFT -adjustdirection option).*)
(*direction - tells the script whether to take the substring off of the string at the front or the back. Options are "Suffix" or "Prefix".*)
(*position - tells the script what part of the fasta header it should look in. This should be an integer.*)


fixPrefix[alignment_String, token_,direction_,position_]:=fastaExport[alignment,fixPrefix[alignment//importAlignment, token,direction,position]]


fixPrefix[alignment_String, token_,direction_,position_, "Hold"]:=fixPrefix[alignment//importAlignment, token,direction,position]


fixPrefix[alignment_List, token_,direction_,position_]:=Block[{currentNamesList, fixedNamesList, tokenLength, a, tolken},
a=alignment;
tokenLength=StringLength[token];
tolken==token;
Which[direction=="Prefix", tolken=token ;, direction=="Suffix", tolken=(token*(-1));, direction=__, Print["Invalid direction"]];

currentNamesList=a[[All, 1, position]]//Flatten//Union;

fixedNamesList=(If[StringTake[#, tokenLength]==tolken, StringDrop[#, tokenLength], #]&/@currentNamesList);
(*so you can check it after to make sure it's ok*)
replaceList=(Table[
{currentNamesList[[i]]->fixedNamesList[[i]]}
,{i, 1, Length[fixedNamesList]}]);

(Table[a=a/.
{currentNamesList[[i]]->fixedNamesList[[i]]}
,{i, 1, Length[fixedNamesList]}]);
a
]


(* ::Subchapter::Closed:: *)
(*Sequence editing functions (e.g. blank/missing characters, padding, replacing characters, missing data, reverse complement, translation)*)


(* ::Section:: *)
(*Trivial sequence editing*)


(* ::Subsection:: *)
(*Padding sequences*)


(* ::Text:: *)
(*If you want to merge unaligned sequences it is necessary to have the alignments be the same length. *)
(*This function can also be used to put one or more buffer characters at the end of alignments before merging, so that it is easy to tell where the gaps between the alignments are.*)


sequencePadder[alignment_List, padCharacter_String]:=Block[{lengths, maxLength},
lengths=StringLength/@alignment[[All, 2]];
maxLength=Max[lengths];
{#[[1]], 
(#[[2]]<>StringRepeat[padCharacter,(maxLength-(StringLength[#[[2]]]-1))])
}&/@alignment
]


sequencePadder[alignment_String, padCharacter_String, "Hold"]:=Block[{lengths, maxLength,align},
align=importAlignment[alignment];
lengths=StringLength/@align[[All, 2]];
maxLength=Max[lengths];
{#[[1]], 
(#[[2]]<>StringRepeat[padCharacter,(maxLength-(StringLength[#[[2]]]-1))])
}&/@align
]


sequencePadder[alignment_String, padCharacter_String]:=fastaExport[alignment,sequencePadder[alignment, padCharacter, "Hold"]]


(* ::Subsection::Closed:: *)
(*Replacing characters in sequences*)


(* ::Text:: *)
(*You might want to use a software that cannot handle certain sequence characters (e.g. "*" or "?"). Using this function you can change them. It is also possible to delete characters from an alignment by making the toChar parameter a blank string ("").*)
(*	fastaParsed - a fastaParsed object*)
(*	fromChar - the character you want to remove.*)
(*	toChar - the character you want to replace it with.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


replaceChar[fastaParsed_List, fromChar_, toChar_]:=Block[{},
{#[[1]], StringReplace[#[[2]],fromChar->toChar ]}&/@fastaParsed
]


replaceChar[fastaParsed_String, fromChar_, toChar_]:=fastaExport[fastaParsed,replaceChar[fastaParsed//importAlignment, fromChar,toChar]]


replaceChar[fastaParsed_String, fromChar_, toChar_, "Hold"]:=replaceChar[fastaParsed//importAlignment, fromChar,toChar]


replaceChar[fastaParsed_, fromChar_->toChar_]:=
replaceChar[fastaParsed, fromChar,toChar]


replaceChar[fastaParsed_, fromChar_->toChar_, "Hold"]:=
replaceChar[fastaParsed, fromChar,toChar, "Hold"]


(* ::Section::Closed:: *)
(*Non-trivial sequence editing*)


(* ::Subsection::Closed:: *)
(*Deleting entries with missing data*)


(* ::Text:: *)
(*This function will delete any sequence that is composed of a certain amount of missing data.*)
(*alignment - the list of sequences in a fasta parsed format*)
(*percent - the maximum amount of missing data a sequence can have, otherwise it is deleted.*)


deleteEmptySequences[alignment_List, percent_]:=

(*METHOD 1:The problem with this method is that it doesn't eliminate sequences with a vast majority of missing data)
DeleteCases[If[StringContainsQ[#[[2]], "A"|"T"|"G"|"C"|"a"|"t"|"g"|"c"|"Y"|"U"|"R"|"Y"|"K"|"P"|"V"|"W"|"e"|"f"|"Z"|"L"|"M"|"N"|"n"|"m"|"z"|"y"|"g"],#, {} ]&/@alignment, {}]*)

(*METHOD 2*)
DeleteCases[Block[{seqLength},
(seqLength=StringLength[#[[2]]];
If[StringCount[#[[2]], {"?","N","n","-"}]<((percent*seqLength)), #, {}])&/@alignment], {}]


deleteEmptySequences[alignment_]:=deleteEmptySequences[alignment, 1]


deleteEmptySequences[alignment_String,percent_, "Hold"]:=deleteEmptySequences[alignment//importAlignment, percent]


deleteEmptySequences[alignment_String,percent_]:=fastaExport[alignment,deleteEmptySequences[alignment//importAlignment, percent]]


deleteEmptySequences[alignment_String, percent_]:=fastaExport[alignment, deleteEmptySequences[alignment//importAlignment, percent]]


(* ::Subsection::Closed:: *)
(*Reverse complement a FASTA file*)


(* ::Text:: *)
(*NOTE: Need to develop this section. *)


(* ::Text:: *)
(*This will rev-comp a single DNA string-sequence.*)


reverseComplementDNA[sequence_String]:=Block[{},
StringReplace[(sequence//ToUpperCase//StringReverse), {"A"->"T","T"->"A","G"->"C","C"->"G","R"->"Y","Y"->"R","K"->"M","M"->"K","B"->"N","V"->"N","D"->"N"}]
]


reverseComplementAll[fastaParsed_list]:=Block[{},
{Append[#[[1]], "RevComp"], #[[2]]//reverseComplementDNA}&/@fastaParsed
]


reverseComplementAll[fastaParsed_String, "Hold"]:=reverseComplementAll[fastaParsed//importAlignment]


reverseComplementAll[fastaParsed_String]:=fastaExport[fastaParsed,reverseComplementAll[fastaParsed//importAlignment]]


(* ::Subsection::Closed:: *)
(*Translating nucleotide data to AminoAcids (AA)*)


(* ::Subsubsection::Closed:: *)
(*Paramaters and matrices*)


(* ::Text:: *)
(*This is a standard ordered table of codons*)


nucCodeTable=Flatten[Transpose/@Table[
{StringJoin[i, j, k]}
,{i, {"T", "C", "A", "G"}}, {j, {"T", "C", "A", "G"}}, {k, {"T", "C", "A", "G"}}], 1];


(* ::Text:: *)
(*This is the standard genetic code table.*)


stdGenCode=
{{{"Phe"},{"Ser"},{"Tyr"},{"Cys"}},{{"Phe"},{"Ser"},{"Tyr"},{"Cys"}},{{"Leu"},{"Ser"},{"Stop"},{"Stop"}},{{"Leu"},{"Ser"},{"Stop"},{"Trp"}},{{"Leu"},{"Pro"},{"His"},{"Arg"}},{{"Leu"},{"Pro"},{"His"},{"Arg"}},{{"Leu"},{"Pro"},{"Gln"},{"Arg"}},{{"Leu"},{"Pro"},{"Gln"},{"Arg"}},{{"Ile"},{"Thr"},{"Asn"},{"Ser"}},{{"Ile"},{"Thr"},{"Asn"},{"Ser"}},{{"Ile"},{"Thr"},{"Lys"},{"Arg"}},{{"Met"},{"Thr"},{"Lys"},{"Arg"}},{{"Val"},{"Ala"},{"Asp"},{"Gly"}},{{"Val"},{"Ala"},{"Asp"},{"Gly"}},{{"Val"},{"Ala"},{"Glu"},{"Gly"}},{{"Val"},{"Ala"},{"Glu"},{"Gly"}}}/.{"Gly"->"G","Ala"->"A" , "Leu"->"L", "Met"->"M", "Phe"->"F", "Trp"->"W", "Lys"->"K", "Gln"->"Q", "Glu"->"E", "Ser"->"S", "Pro"->"P", "Val"->"V", "Ile"->"I", "Cys"->"C", "Tyr"->"Y", "His"->"H", "Arg"->"R", "Asn"->"N", "Asp"->"D", "Thr"->"T", "Stop"->"*"};


(* ::Text:: *)
(*Utilizing the stdn genetic code and the codon table, this is a standard genetic code list of replacement rules for translation.*)
(*(http://www.genome.jp/kegg/catalog/codes1.html)*)


replaceTableStd=Append[Table[
{nucCodeTable[[i, j, 1]]->stdGenCode[[i, j, 1]]}
,{i, 1, Length[nucCodeTable]}, {j, 1, Length[nucCodeTable[[1]]]}
]//Flatten, {"TTN"->"?","TCN"->"S", "TGN"->"?","CTN"->"L", "CCN" ->"P","CAN"->"?","CGN"->"R", "ATN"->"?", "ACT"->"T", "AAT"->"?","AGT"->"?", "GTN"->"V", "GCN"->"A", "GAN"->"?","GGN"->"G", "NAA"->"?", "NTA"->"?", "NCA"->"?", "NGA"->"?","NAT"->"?", "NTT"->"?", "NCT"->"?", "NGT"->"?","NAC"->"?", "NTC"->"?", "NCC"->"?", "NGC"->"?",
"NAG"->"?", "NTG"->"?", "NCG"->"?", "NGG"->"?","ANA"->"?", "TNA"->"?", "CNA"->"?", "GNA"->"?","ANT"->"?", "TNT"->"?", "CNT"->"?", "GNT"->"?","ANC"->"?", "TNC"->"?", "CNC"->"?", "GNC"->"?",
"ANG"->"?", "TNG"->"?", "CNG"->"?", "GNG"->"?",
"TTY"->"F","TTR"->"L","AUH"->"I","TAY"->"Y","TAR"->"*","TGY"->"C","CAY"->"H","CAR"->"Q","AAY"->"N","AAR"->"K","GAY"->"D","GAR"->"E", "AGY"->"S","AGY"->"K", "TRA"->"*","YUR"-> "L", "MGR"->"R"}]//Flatten;


temp={"CYT","ATT","ACT","CGT","GAG","TCA","GAG","AAG","CTA","CTG","CAT","TGC","TAA","CAT","CCA","AGA","AGA","TGG","TAT","ACA","GTA","AGT","CAA","TGT","TTA","ATC","GTG","ATG","GGA","TCC","AAA","GAT","GAC","GCT","AAT","TCA","ACG","GTT","TGA","ATG","CAA","AGA","AAG","GAG","TGT","TTA","TTG","CTG","GGT","CGC","AAA","TTG","TTT","CAT","GCT","AAA","CAA","GAT","TGA","TCA","TTT","CCA","TTG","GTT","TTC","TTT","CTT","AAA","GGA","TTG","GTA","TAT","AAC","CTT","GAA","AAT","ATG","GGT","GAA","ATA","GTG","TTC","ATA","TCC","ACG","TCA","AAA","TGA","ATG","GTG","AAA","TTC","CAA","GTG","TTC","CAA","TCA","CCA","CGC","TGG","CTG","GCA","TTT","CAA","GTC","TTA","CAG","ACT","TGT","TGC","CAG","AGA","TGC","CAC","TAC","CTT","CAC","CAT","TGC","CAC","AGA","CAT","TAA","GTA","ACA","AGT","CCC","TGC","TAT","TCC","ATC","CTC","GAG","TGG","CAG","AAG","AAG","CTC","AAA","TTC","TTC","TGA","GTG","TGC","GGG","ACG","ATG","CCT","TGG","TGC","CTC","AGC","TGA","TCC","AAT","CTC","TTG","TTC","AGA","CGT","CTG","CTG","ATC","ACA","TTG","AGC","TGA","AGG","ATC","ATT","ATG","CTG","GAA","CAG","AAC","CAC","CTG","TGG","ACC","AGC","AAC","AGA","ATA","TTC","CAG","AAC","TCC","TGA","AAG","CTA","TTC","TTC","AAC","GGA"};


((temp/.replaceTableStd)/.{x_/;(StringLength[x]>2)->"?"})//Quiet


(* ::Subsubsection::Closed:: *)
(*Functions*)


(* ::Text:: *)
(*NOTE: I need to update the below functions to handle non-standard genetic codes. I can add it as an option to choose the matrix used.*)


(* ::Text:: *)
(*IMPORTANT that the code below does not work about 10% of the time because reverse complement reading directions can be more optimal choices quite often. Since this function decides on reading frame from individual strands, this is a problem. It is highly recommended that you align first with the --adjustdirection option in MAFFT first and then use the Alignment version of this function.*)


(* ::Text:: *)
(*Translate multiple FASTA files*)


(* ::Text:: *)
(*input = the nucleotide FASTA file name you want to translate, or a list of file names*)
(*suffix = the suffix you want to add to the file, INCLUDING the format suffix (e.g ".fasta", ".txt" )*)


translateNucleotideFile[input_String]:=Block[{},
fastaExport["aa."<>input,importAlignment[input]//translateFASTA];
]


translateNucleotideFile[input_String,"Hold"]:=Block[{},
importAlignment[input]//translateFASTA
]


translateNucleotideFile[input_List]:=translateNucleotideFile[input]&/@input


(* ::Text:: *)
(*Translate a whole FASTA parsed object*)


(* ::Text:: *)
(*fastaParsed = a fastaParsed object*)


translateFASTA[fastaParsed_]:=Block[{},{#[[1]], translate1[#[[2]]]}&/@fastaParsed]


(* ::Text:: *)
(*Translating a single FASTA entry*)


translate1[sequence_String]:=Block[{a, b, c,d, transLateIn6Frames,numStops,stopPoss,distances,maxDistance,numstopsMiddle, crit1, crit2, crit3,crit4,crit5, crit6, crit7, crit8, crit9,translation, scores1, scores2, scores3, tally},
(*translate in 6 standard reading frames*)
a=(StringPartition[StringDrop[sequence//ToUpperCase,#], 3]&/@{0, 1, 2});
b=(StringPartition[StringDrop[sequence//ToUpperCase//revComp,#], 3]&/@{0, 1, 2});
transLateIn6Frames=Flatten[{a, b}, 1]/.replaceTableStd;
transLateIn6Frames=(transLateIn6Frames/.x_/;(StringLength[x]>2)->"?")//Quiet; (*this line just turns any untranslated codons (because they have some kind of undefined degeneracy, into ?'s*)

(*I am using three criteria to determine the reading frame of the sequence.
1. The reading frame that reduces the number of stop codons.
2. The reading frame that creates the largest gap without stop codons.
3. The reading frame that reduces the number of stop codons in the middle of the read.

Criteria 3 is the tie breaking criterion. The rationale is that a read or transcript should be dirty on the end and we would expect stop codons there because these are introns, or dirty data.
*)
numStops=StringCount[#,"*"]&/@StringJoin/@transLateIn6Frames;
stopPoss=(Flatten[{(Union[#]&/@StringPosition[#,"*"]), 0, StringLength[#]}]//Sort)&/@StringJoin/@transLateIn6Frames;
distances=(Differences[#]&/@#&/@((Partition[#, 2])&/@stopPoss));
maxDistance=Max/@distances;
numstopsMiddle=StringCount[#,"*"]&/@(StringDrop[StringDrop[#,10],-10]&/@StringJoin/@transLateIn6Frames);

crit1=Position[numStops, numStops//Min]//Flatten;
crit2=Position[maxDistance, maxDistance//Max]//Flatten;
crit3 = Position[numstopsMiddle, numstopsMiddle//Min]//Flatten;

(*this part actually makes the decision of which criteria wins. It is unfinished because it doesn't say what to do if there is a tie, which is possible, although unlikely.*)
(*Which[
crit1\[Equal]crit2,translation=transLateIn6Frames[[crit1[[1]]]];,
crit3\[Equal]crit2,translation=transLateIn6Frames[[crit2[[1]]]];,
((c=Intersection[crit1, crit2, crit3])//Length)\[Equal]1,translation=transLateIn6Frames[[c[[1]]]];,
(c//Length)\[NotEqual] 1,translation=c; Print["Criteria ambiguous."](*throw to a script that makes more than one sequence*)
]; 
(*print a single output*)

(*note that if a nucleotide sequence has an ambiguity (N) it could be that there is a frame shift within the sequence. We could account for this by duplicating the original sequence by replacing all the "N"'s with "NN"'s or ""'s. I looked in the transcriptome files and this seems to be a very rare case, so I am not adding it now. It might be an issue witht eh AHE files but since orthograph translated those for me this issue is irrelevant*)
translation//StringJoin*)
Which[
crit1==crit2,translation=transLateIn6Frames[[crit1[[1]]]];,(*which condition 1*)
crit3==crit2,translation=transLateIn6Frames[[crit2[[1]]]];, (*condition 2*)
((d=Intersection[crit1, crit2, crit3])//Length)==1,translation=transLateIn6Frames[[d[[1]]]];,(*condition 3*)


(*Calculate further criteria*)
(crit4=Position[numStops[[1;;3]], numStops[[1;;3]]//Min]//Flatten;
crit5=Position[maxDistance[[1;;3]], maxDistance[[1;;3]]//Max]//Flatten;
crit6= Position[numstopsMiddle[[1;;3]], numstopsMiddle[[1;;3]]//Min]//Flatten;);

((c=Intersection[crit4, crit5, crit6])//Length)==1,translation=transLateIn6Frames[[c[[1]]]];, (*condition 4*)

(*Calculate even more criteria*)
(crit7=Position[numStops[[4;;6]], numStops[[4;;6]]//Min]//Flatten;
crit8=Position[maxDistance[[4;;6]], maxDistance[[4;;6]]//Max]//Flatten;
crit9= Position[numstopsMiddle[[4;;6]], numstopsMiddle[[4;;6]]//Min]//Flatten;);

((c=Intersection[crit7, crit8, crit9])//Length)==1,translation=transLateIn6Frames[[c[[1]]]];,(*condition 5*)

(*Calculate another criteria (this one depends on giving scores based on ranks, and the one with the lowest score, wins.*)
(scores1=((Position[numStops//Sort, #][[1]]&/@numStops)//Flatten);
scores2=(Position[maxDistance//Sort//Reverse, #][[1]]&/@maxDistance)//Flatten;
scores3=(Position[numstopsMiddle//Sort, #][[1]]&/@numstopsMiddle)//Flatten;
tally=scores1+scores2+scores3;);
((c=Position[tally, Min[tally]])//Length)==1,translation=transLateIn6Frames[[c[[1]]]];, (*condition 6*)

(*another criteria: this one will pick randomly from among some of the best options. At this point, we have eliminated the vast majority of sequences. Now, we are only dealing with very rare cases, so choosing randomly among a set of possible options isn't such a bad idea. The bad ones should be eliminated in masking phase anyway*)

1==1 (*will always be true...*), translation=transLateIn6Frames[[Append[Intersection[crit1, crit2, crit3], crit2]//Flatten//RandomChoice]]

]; 
translation//StringJoin
]


(* ::Section::Closed:: *)
(*Miscellaneous sequence file operations*)


(* ::Subsection::Closed:: *)
(*Make a table from files headers*)


(* ::Text:: *)
(*This function will make a ".csv" file of any number of available entries from the entry headers in a Phylip of FASTA file.*)
(**)
(*	exportFileName - a string with the name of the file, including the file suffix. If you omit this input it has the same affect has using the "Hold" option.*)
(*	fastaFile - a phylip or fasta file in the current working directory, or a list of sequence files in the current directory.*)
(*	headerPositions - a list of integers representing the positions in the fasta Parsed object version of the fastaFile you want to turn into a table.*)
(*	option: "Hold" - if specified, will take a file name as input but will output a fastaParsed object.*)


exportFastaHeadTable[listName_,fastaFile_String, headerPositions_]:=Block[{},

Export[listName, importAlignment[fastaFile][[All, 1, headerPositions]]//Union, "CSV"]
]


exportFastaHeadTable[listName_,fastaFile_String, headerPositions_, "Hold"]:=Block[{},

importAlignment[fastaFile][[All, 1, headerPositions]]//Union]


exportFastaHeadTable[fastaFile_String, headerPositions_]:=Block[{},
importAlignment[fastaFile][[All, 1, headerPositions]]//Union]


exportFastaHeadTable[listName_,fastaFile_List, headerPositions_]:=Block[{},

Export[listName, Flatten[(importAlignment[#]&/@fastaFile), 1][[All, 1, headerPositions]]//Union
]]


exportFastaHeadTable[listName_,fastaFile_List, headerPositions_, "Hold"]:=Block[{},

Flatten[(importAlignment[#]&/@fastaFile), 1][[All, 1, headerPositions]]//Union
]


exportFastaHeadTable[fastaFile_List, headerPositions_]:=Block[{},
Flatten[(importAlignment[#]&/@fastaFile), 1][[All, 1, headerPositions]]//Union
]


(* ::Subsection::Closed:: *)
(*Nexus file import elements*)


(* ::Text:: *)
(*The script below imports a simplified nexus file without all the leading information. It basically just treats it like a phylip file.*)


nexusSimpleParser[nexusString_]:=Block[{},
StringTrim[StringSplit[StringSplit[nexusString,"MATRIX
"][[2]], "END;"][[1]], ";"]//StringTrim//phylipParser
]


(* ::Text:: *)
(*The script below will take the "SETS" Section from a Nexus file and parse it to extract the set boundaries, and set names.*)


nexusSetsParser[nexusString_]:=Block[{ranges},
ranges=(StringTrim/@StringSplit[#, "="]&/@(StringTrim[#, ";"]&/@StringTrim/@StringSplit[StringSplit[StringSplit[nexusString, {"BEGIN SETS;"}][[2]], "END;"][[1]], "
"]))[[All,{1, 2}
]];
{StringSplit[#[[1]], "charset "][[1]], #[[2]]//ToExpression}&/@((StringSplit[#, "-"])&/@ranges)
]



(* ::Subchapter::Closed:: *)
(*Alignment editing functions*)


(* ::Text:: *)
(*These functions were designed to only be used on alignments. Only use them on unaligned sequences if you understand how the function works (see Backend) and if you know what you're doing. *)


(* ::Section::Closed:: *)
(*Consensus sequences*)


(* ::Subsection::Closed:: *)
(*Making strict consensus sequences*)


(* ::Text:: *)
(*NOTE: THE WAY THIS FUNCTION IS WRITTEN IT CANNOT WORK FOR AMINO ACID SEQUENCES (because "N" is an amino-acid code). I WILL NEED TO REWRITE A NEW VERSION FOR AA'S.*)


(* ::Text:: *)
(*This  will take a fasta file and output a strict consensus (100% similarity only) of all the sequences. You can do this easily with EMBOSS, but this version will take terminal gaps and exclude them from the character consideration. This requires that you use the terminalGapsFastaFix and/or terminalGapsToUnknown functions first to change all the terminal gaps to a FASTA UNIQUE character. "?"s are recommended.*)
(**)
(*The input is:*)
(*	 termGappedAlign which is an alignment with terminal gaps. The format is a list of string alignments, or what you would get from fastaParsedFASTA[[All, 2]].*)
(*The parameters are...*)
(*	termGapCharacter  - a string indicating the character you are using as your terminal gap.*)
(*	minimumRequired  - a number indicating how many sequences you wish to be the minimum for choosing a nonambiguous (non-N) character. It is made such that the minimum cannot be less than 2. This means that the consensus you get will always be shorter than the longest sequence, assuming the sequences aren't the same length.*)


makeStrictConsensus[fastaFile_String,termGapCharacter_String,minimumRequired_, "Hold"]:=Block[{termGappedAlign},
termGappedAlign=importAlignment[fastaFile];
Partition[Riffle[termGappedAlign[[All, 1]],strictConsensus[termGappedAlign[[All, 2]],termGapCharacter,minimumRequired]], 2]]


makeStrictConsensus[fastaFile_String,termGapCharacter_String,minimumRequired_]:=Block[{termGappedAlign},
termGappedAlign=importAlignment[fastaFile];
fastaExport["cons."<>fastaFile,Partition[Riffle[termGappedAlign[[All, 1]],strictConsensus[termGappedAlign[[All, 2]],termGapCharacter,minimumRequired]], 2]]

]


makeStrictConsensus[termGappedAlign_List,termGapCharacter_String,minimumRequired_]:=Partition[Riffle[termGappedAlign[[All, 1]],strictConsensus[termGappedAlign[[All, 2]],termGapCharacter,minimumRequired]], 2]


strictConsensus[termGappedAlign_,termGapCharacter_String,minimumRequired_]:=Block[{min},
min=minimumRequired;
If[minimumRequired<= 1, Print[ToString[min]<>"is the min. Too low. Changing to 2."];min=2;, Null; ];

(makePolymorphismsAmbiguous[DeleteCases[
(If[(DeleteCases[#, termGapCharacter]//Length)<  min,{"N"}, #])
//Union, termGapCharacter]//ToUpperCase]&/@(a=((StringPartition[#, 1]&/@termGappedAlign)//Transpose)))//StringJoin
]


(* ::Text:: *)
(*This is the same as above but without the minimum requirement. Therefore, it will return the longest sequence for which there are no ambiguities.*)


longestStrictConsensus[termGappedAlign_,termGapCharacter_String,minimumRequired_]:=Block[{min},
min=minimumRequired;
(*If[minimumRequired\[LessEqual] 1, Print[ToString[min]<>"is the min. Too low. Changing to 2."];min=2;, Null; ];*)

(makePolymorphismsAmbiguous[DeleteCases[
(If[(DeleteCases[#,termGapCharacter]//Length)<  min,{"N"}, #])//Union, termGapCharacter]//ToUpperCase]&/@(a=((StringPartition[#, 1]&/@termGappedAlign)//Transpose)))//StringJoin
] 


makeLongestStrictConsensus[termGappedAlign_List,termGapCharacter_String,minimumRequired_]:=Partition[
Riffle[termGappedAlign[[All, 2]],
longestStrictConsensus[termGappedAlign[[All, 2]],termGapCharacter,minimumRequired]], 2]


makeLongestStrictConsensus[inputFile_String,termGapCharacter_String,minimumRequired_, "Hold"]:=Block[{termGappedAlign},
termGappedAlign=importAlignment[inputFile];
Partition[
Riffle[termGappedAlign[[All, 2]],
longestStrictConsensus[termGappedAlign[[All, 2]],termGapCharacter,minimumRequired]], 2]]


makeLongestStrictConsensus[inputFile_String,termGapCharacter_String,minimumRequired_]:=fastaExport[inputFile,makeLongestStrictConsensus[inputFile,termGapCharacter,minimumRequired, "Hold"]


(* ::Text:: *)
(*This is a small dependency script.*)


makePolymorphismsAmbiguous[nucs_]:=Block[{ns},
ns=DeleteCases[DeleteCases[nucs, "-"], "?"];
Which[
(ns//Length)==1,ns[[1]],  (ns//Length)>1, "?",
(nucs//Length)<1, "ERROR: nucs object less than length 1"
]]


(* ::Subsection::Closed:: *)
(*Making a consensus of duplicate sequences*)


(* ::Text:: *)
(*Specifically for when you have multiple sequences for the same thing (e.g. taxon) but their sequences are different (e.g. different regions of the same locus). For example, something like this... (see the output of the next cell)*)


TableForm[
{
{{{"Polyzosteria sp.","Locus 1","Region 1 "}}//TableForm,"------------ATGTAGGTAT"},
	{{{"Polyzosteria sp.","Locus 1","Region 2 "}}//TableForm,"TGTGGGTAAT------------"}
}
]


(* ::Text:: *)
(*...consensed to...*)


TableForm[
{
{{{"Polyzosteria sp.","Locus 1"}}//TableForm,"TGTGGGTAAT--ATGTAGGTAT"}
}
]


(* ::Text:: *)
(* This function is best utilized with an alignment that has already had messy ends trimmed.*)
(**)
(*	fastaParsed - a fastaParsed object or alignment file name with potential duplicate sequences*)
(*	headerGuide - an integer representing the position in the FASTA header you want to choose as the guide to make sure your comparing among the sequences you want to be comparing (in the above example, headerGuide = 1 or headerGuide = 2 would be sufficient, but if you had other taxa in the alignment "1" would probably be a better choice).*)
(*	termGapCharacter - a string indicating the character you are using as your terminal gap.*)


consenseDuplicates[fastaParsed_List, headerGuide_, terminalGapChar_]:=Block[{poss, gathered, g2},
poss=Position[(#>1)&/@(Length[#]&/@(gathered=GatherBy[fastaParsed,#[[1, headerGuide]]&])), True];
g2=gathered;
Table[
g2=ReplacePart[g2,poss[[i]]->
{{g2[[poss[[i]], 1, 1, 1]],longestStrictConsensus[Extract[g2,poss][[i]][[All, 2]], terminalGapChar,1(*minimum requirement*)]}}
]
, {i, 1, Length[poss]}];
Flatten[g2, 1]
]


consenseDuplicates[fastaParsed_String, headerGuide_, terminalGapChar_]:=fastaExport[fastaParsed,consenseDuplicates[fastaParsed//importAlignment, headerGuide, terminalGapChar]]


consenseDuplicates[fastaParsed_String, headerGuide_, terminalGapChar_, "Hold"]:=consenseDuplicates[fastaParsed//importAlignment, headerGuide, terminalGapChar]


(* ::Section::Closed:: *)
(*Gap, unknown, and ambiguous characters*)


(* ::Subsection::Closed:: *)
(*Changing terminal gaps to unknown in FASTA alignments*)


(* ::Text:: *)
(*The code below takes a single string of nucleotides and replaces the defined gap character (e.g. "-") with a new terminal character (e.g. "?"). This works for nucleotide data ONLY.*)


terminalGapsToUnknown[string_, fromGapCharacter_String,toGapCharacter_String]:=Module[{temp (*replace with string*),gaps, openGapLength,closingGapLength},
temp=string;
If[(gaps=StringSplit[temp, Flatten[{{"A","T","G","C","a","t","g","c", "N", "n", "U","R","Y","K","M","S","W","B","D","H","V"},{"*","A","C","D","E","F","G","H","I","K","L","M","N","P","Q","R","S","T","V","W","Y"}}]]); gaps=={}, Goto[endClosed];, Goto[lengthDefine];];
Label[lengthDefine];
openGapLength=gaps[[1]]//StringLength;
closingGapLength=gaps[[Length[gaps]]]//StringLength;

If[StringStartsQ[temp, fromGapCharacter], Goto[beginningGaps];,Goto[beginningClosed];];

Label[beginningGaps];
(*Print["Gaps in the beginning"];*)
(*here...replace the openning gaps with ?'s*)

temp=StringReplace[temp,(StartOfString~~fromGapCharacter... ) ->  StringRepeat[toGapCharacter, openGapLength]];
Label[beginningClosed];


If[StringEndsQ[temp, fromGapCharacter], Goto[endGaps];, Goto[endClosed];];


Label[endGaps];
(*Print["Gaps in the end"];*)
temp=StringTake[StringReplace[temp,(fromGapCharacter...~~EndOfString) ->  StringRepeat[toGapCharacter, Round[closingGapLength+1, 2]/2(*the /2 is because it is repeating sometimes and I don't know why. It seems to be double looping this part and I don't really understand why it is.*)]], StringLength[string]];

Label[endClosed];
(*Print["No gaps in the end"];*)
temp
]

terminalGapsToUnknown[string_, fromGapCharacter_String->toGapCharacter_String]:=terminalGapsToUnknown[string, fromGapCharacter, toGapCharacter]



terminalGapsFastaFix[fasta_List, fromGapCharacter_String, toGapCharacter_String]:=Block[{},
{#[[1]],terminalGapsToUnknown[#[[2]], fromGapCharacter, toGapCharacter]}&/@fasta
]
terminalGapsFastaFix[fasta_List, fromGapCharacter_String-> toGapCharacter_String]:=terminalGapsFastaFix[fasta, fromGapCharacter, toGapCharacter]


terminalGapsFastaFix[fasta_String, fromGapCharacter_String, toGapCharacter_String]:=Block[{},
fastaExport[fasta,{#[[1]],terminalGapsToUnknown[#[[2]], fromGapCharacter, toGapCharacter]}&/@importAlignment[fasta]]]


terminalGapsFastaFix[fasta_String, fromGapCharacter_String, toGapCharacter_String,"Hold"]:=Block[{},
{#[[1]],terminalGapsToUnknown[#[[2]], fromGapCharacter, toGapCharacter]}&/@importAlignment[fasta]]


(* ::Subsection::Closed:: *)
(*Changing all gap characters in nucleotide alignments*)


(* ::Text:: *)
(*This function will replace all the gap characters in your alignment with the specified character*)


changeAmbiguous[fastaFile_String, newCharacter_String]:=Block[{fasta},
fastaExport[fastaFile, ({#[[1]],StringReplace[#[[2]], {"-"->newCharacter, "N"->newCharacter, "?"-> newCharacter}]}&/@(Evaluate[importAlignment[fastaFile]]))
	]
]


changeAmbiguous[fastaFile_String, newCharacter_String,"Hold"]:=Block[{fasta},
({#[[1]],StringReplace[#[[2]], {"-"->newCharacter, "N"->newCharacter, "?"-> newCharacter}]}&/@(Evaluate[importAlignment[fastaFile]]))
]


changeAmbiguous[fasta_List, newCharacter_String]:=Block[{},
({#[[1]],StringReplace[#[[2]], {"-"->newCharacter, "N"->newCharacter, "?"-> newCharacter}]}&/@fasta)
]


(* ::Subsection::Closed:: *)
(*Putting empty sequences into an alignment*)


(* ::Text:: *)
(*For some applications it is necessary to put empty sequences into an alignment. This is particularly important when you need taxon lists in alignments to always be the same or when you need to have comparable or mergable alignments. *)
(**)
(*Input:*)
(*inputAlignment - in a parsed FASTA format*)
(*tNameList - a simple list of all the taxon names you want to be added. They CAN be all the names, but they don't HAVE TO be all the names...they just have to be the names you want to add. In other words, inputAlignment can contain names that tNameList doesn't and it will work just fine.*)
(*blankCharacter - a string which is the character you want to make your empty sequences out of (e.g. "-", "N", "?")*)
(*namePos - an integer which represents the position in the FASTA header where your taxon name resides.*)
(**)
(*The function will create an object "outputAlign" which is the output. But also it will output on it's own as well.*)


alignmentTaxonPadder[inputAlignment_List, tNameList_, blankCharacter_String, namePos_Integer]:=Block[{alignment, nucLength,missingNames, blank,blankSeqs, alignment2, NL},
alignment=inputAlignment;
outputAlign=alignment;
nucLength=If[NL=((StringLength/@alignment[[All, 2]])//Union); Length[NL]>1, Print["ERROR: NUMBER OF NUCLEOTIDES IN ALIGNMENT ARE NOT EQUAL."], NL[[1]]];

missingNames=Complement[tNameList,alignment[[All, 1, namePos(*position in FastaHeader with name*)]] ];
If[(missingNames//Length)==0, Goto["skip"];, Null;];
blank=StringRepeat[blankCharacter, nucLength];
blankSeqs={{#[[1]]}//Flatten, #[[2]]}&/@(Table[{missingNames[[i]], blank}, {i, 1, Length[missingNames]}]);
alignment2=SortBy[Flatten[{alignment,blankSeqs }, 1], #[[1, 1 (*position in fasta header with name...but it has to be 1 here*)]]&];
outputAlign=alignment2;
Label["skip"];
(*output/export*)
outputAlign
]



(* ::Text:: *)
(*This version is the same as the above but with the option to add extra blocks to the fasta header of blank sequences.*)
(*entry - is the entry (row) you want to use the header info from. It needs to be an integer*)
(*block - is(are) the header block(s) you want to copy into the padded sequences. It can be a single block (e.g. 4) or a consecutive row of blocks (e.g. 2;;4) or the same block multiple times (e.g. {5, 5, 5, 5, 5})*)


alignmentTaxonPadder[inputAlignment_List, tNameList_, blankCharacter_String, namePos_Integer, {entry_Integer, block_}]:=Block[{alignment, nucLength,missingNames, blank,blankSeqs, alignment2, NL,mHeaderLength, remainingHeader},
alignment=inputAlignment;
outputAlign=alignment;
nucLength=If[NL=((StringLength/@alignment[[All, 2]])//Union); Length[NL]>1, Print["ERROR: NUMBER OF NUCLEOTIDES IN ALIGNMENT ARE NOT EQUAL."], NL[[1]]];

mHeaderLength=Min[Length/@alignment[[All, 1]]];
remainingHeader=alignment[[All, 1]][[entry, block]];

missingNames=Complement[tNameList,alignment[[All, 1, namePos(*position in FastaHeader with name*)]] ];
If[(missingNames//Length)==0, Goto["skip"];, Null;];
blank=StringRepeat[blankCharacter, nucLength];
blankSeqs={{#[[1]],remainingHeader}//Flatten, #[[2]]}&/@(Table[{missingNames[[i]], blank}, {i, 1, Length[missingNames]}]);
alignment2=SortBy[Flatten[{alignment,blankSeqs }, 1], #[[1, 1 (*position in fasta header with name...but it has to be 1 here*)]]&];
outputAlign=alignment2;
Label["skip"];
(*output/export*)
outputAlign
]


alignmentTaxonPadder[inputAlignment_String, tNameList_, blankCharacter_String, namePos_Integer, "Hold"]:=alignmentTaxonPadder[inputAlignment//importAlignment, 
tNameList, blankCharacter, namePos]


alignmentTaxonPadder[inputAlignment_String, tNameList_, blankCharacter_String, namePos_Integer]:=fastaExport[inputAlignment,alignmentTaxonPadder[inputAlignment//importAlignment, 
tNameList, blankCharacter, namePos]]


alignmentTaxonPadder[inputAlignment_String, tNameList_, blankCharacter_String, namePos_Integer, {entry_Integer, block_}, "Hold"]:=alignmentTaxonPadder[inputAlignment//importAlignment, 
tNameList, blankCharacter, namePos, {entry, block}]


alignmentTaxonPadder[inputAlignment_String, tNameList_, blankCharacter_String, namePos_Integer, {entry_Integer, block_}]:=fastaExport[inputAlignment,alignmentTaxonPadder[inputAlignment//importAlignment, 
tNameList, blankCharacter, namePos, {entry, block}]]


(* ::Subsection::Closed:: *)
(*Removing/Collapsing gap-only characters*)


(* ::Text:: *)
(*This function takes a nucleotide alignment (NOT AMINO ACID) and checks to see which columns have only gap characters or entirely ambiguous characters (N's).*)
(**)
(*Input is: *)
(*alignment - either an alignment file or a fastaParsed object.*)
(**)
(*Note: characters considered are: "-", "N", "?"*)
(*	These can be easily modified in the backend code (for instance, for use with amino acids).*)


collapseGapOnly[alignment_String]:=fastaExport[alignment,collapseGapOnly[alignment//importAlignment]]


collapseGapOnly[alignment_List]:=Block[{chars, align, newAlignment},

chars=StringPartition[#, 1]&/@alignment[[All, 2]];

newAlignment=Partition[Riffle[alignment[[All, 1]],StringJoin/@(DeleteCases[If[ContainsOnly[#,{"-", "N", "?"}], Null, #]&/@(chars//Transpose), Null]//Transpose)], 2]
]


collapseGapOnly[alignment_String, "Hold"]:=collapseGapOnly[alignment//importAlignment]


(* ::Section:: *)
(*Concatenation and partitioning functions*)


(* ::Subsection::Closed:: *)
(*Calculating stats and partitions for mutliple alignments*)


(* ::Text:: *)
(*This function will generate a RAXML style partition file and a text document giving the total information of multiple alignments.*)
(**)
(*listOfParsedAlign - is a fastaParsed list of fasta alignments.*)
(*locusName - is an integer indicating the position in the header where the locus name resides*)
(*datatype - is a string indicating what type of data is in the file. This will be printed out in the RAXML file.*)
(*		Possible options are:*)
(*			"DNALoci" - this will output a RAXML style block with specifications for each locus, no codon positions*)
(*			"DNACodon" - this will output a RAXML style block with specifications for each locus by codon position, assuming that the alignments are in reading frame (first positions = 1st codon, with no frame shifts throughout).*)


alignmentRandR2[listOfParsedAlign_, locusName_Integer, dataType_String]:=Block[{alignment, startingPos, lName, locusLength, ll, str, endingpos, a, b, bb, c},
Print["beginning RAXML partition file generation..."];
startingPos=1;
RAXMLPart=Table[
lName=listOfParsedAlign[[i, All, 1,(*PROBLEM*) locusName]]//Union;
If[(lName//Length)>1, Print["ERROR: FASTA CONSISTS OF >1 LOCUS NAME. IS THIS AN ALIGNMENT FILE?
CHECK THE LOCUS NAME POSITION IN THE FASTA FILE"];Goto["thow";];, Null;];

locusLength=(ll=(StringLength/@listOfParsedAlign[[i, All, 2]])//Union)[[1]];

If[(ll//Length)>1, Print["ERROR: SEQUENCE lengths are not equal. IS THIS AN ALIGNMENT FILE?
CHECK FOR FORMATTING ERRORS"];Goto["thow";];, Null;];

Switch[dataType,
(*if the data type are just nucleotide loci*)"DNALoci",
str=StringJoin[dataType<>", ", lName<>"="<>ToString[startingPos]<>"-"<>ToString[endingpos=((locusLength-1)+startingPos)]<>"
"];, 
(*if the data type are codons*)"DNACodon",
str=StringJoin[
(*codon1*)dataType<>", ", lName<>"_c1="<>ToString[startingPos]<>"-"<>ToString[endingpos=((locusLength-1)+startingPos)]<>"\\3;
",(*codon 2*) dataType<>", ", lName<>"_c2="<>ToString[startingPos+1]<>"-"<>ToString[endingpos=((locusLength-1)+startingPos)]<>"\\3;
", (*codon 3*)dataType<>", ", lName<>"_c3="<>ToString[startingPos+2]<>"-"<>ToString[endingpos=((locusLength-1)+startingPos)]<>"\\3;
"];
];(*end switch*)
startingPos=locusLength+startingPos;
str
, {i, 1, Length[listOfParsedAlign]}]//StringJoin;
Label["throw"];

(*ALIGNMENT STATISTICS FILE*)
Print["calculating basic alignment statistics..."];
alignStat=StringJoin[
"There are ", ToString[endingpos], " nucleotides in this alignment.", 
"
There are ", ToString[Length[listOfParsedAlign] ], " loci in this alignment.", 
"

Avg. locus length is ", ToString[(endingpos/Length[listOfParsedAlign])//N ],".",
"

The number of missing (?, -, or N) characters is ", ToString[bb=StringCount[b=(listOfParsedAlign[[All, All, 2]]//StringJoin),{"?", "-", "N"} ]],
" out of ", ToString[a=(StringLength[listOfParsedAlign[[All, All, 2]]//StringJoin ])],
" or ",
ToString[((bb/a)//N)*100], " %.", 
"
The total number of missing data blocks (taxa missing all it's data from a given locus) is ", ToString[Count[StringLength/@(StringTrim[#,("N"|"?"|"-")...]&/@(Flatten[listOfParsedAlign[[All,All, 2]]])), 0]], " out of ",ToString[(*# of RAXML parititions times number of taxa*)((StringCount[RAXMLPart, "="]*(listOfParsedAlign[[1,All]]//Length))*(listOfParsedAlign[[All, All, 1, 1]]//Union//Flatten//Length))]," total. 

GREAT JOB! You rock!"
];
Export["RAXMLpart.txt", RAXMLPart];
Export["alignmentStats.txt", alignStat];
Print["
...
Done."];
]



(* ::Subsubsection::Closed:: *)
(*Old versions*)


(* ::Text:: *)
(*These are the original versions of the R&R function. It differs in that it does not specify codon positions.*)


alignmentRandR[listOfParsedAlign_, locusName_Integer, dataType_String]:=Block[{alignment, startingPos, lName, locusLength, ll, str, endingpos, a, b, bb, c},
Print["beginning RAXML partition file generation..."];
startingPos=1;
RAXMLPart=Table[
lName=listOfParsedAlign[[i, All, 1,(*PROBLEM*) locusName]]//Union;
If[(lName//Length)>1, Print["ERROR: FASTA CONSISTS OF >1 LOCUS NAME. IS THIS AN ALIGNMENT FILE?
CHECK THE LOCUS NAME POSITION IN THE FASTA FILE"];Goto["thow";];, Null;];

locusLength=(ll=(StringLength/@listOfParsedAlign[[i, All, 2]])//Union)[[1]];

If[(ll//Length)>1, Print["ERROR: SEQUENCE lengths are not equal. IS THIS AN ALIGNMENT FILE?
CHECK FOR FORMATTING ERRORS"];Goto["thow";];, Null;];

str=StringJoin[dataType<>", ", ToString[lName[[1]]]<>"="<>ToString[startingPos]<>"-"<>ToString[endingpos=((locusLength-1)+startingPos)]<>"
"];
startingPos=locusLength+startingPos;
str
, {i, 1, Length[listOfParsedAlign]}]//StringJoin;
Label["throw"];

(*ALIGNMENT STATISTICS FILE*)
Print["calculating basic alignment statistics..."];
alignStat=StringJoin[
"There are ", ToString[endingpos], " nucleotides in this alignment.", 
"
There are ", ToString[Length[listOfParsedAlign] ], " loci in this alignment.", 
"

Avg. locus length is ", ToString[(endingpos/Length[listOfParsedAlign])//N ],".",
"

The number of missing (?, -, or N) characters is ", ToString[bb=StringCount[b=(listOfParsedAlign[[All, All, 2]]//StringJoin),{"?", "-", "N"} ]],
" out of ", ToString[a=(StringLength[listOfParsedAlign[[All, All, 2]]//StringJoin ])],
" or ",
ToString[((bb/a)//N)*100], " %.", 
"
The total number of missing data blocks (taxa missing all it's data from a given locus) is ", ToString[Count[StringLength/@(StringTrim[#,("N"|"?"|"-")...]&/@(Flatten[listOfParsedAlign[[All,All, 2]]])), 0]], " out of ",ToString[(*# of RAXML parititions times number of taxa*)((StringCount[RAXMLPart, "="]*(listOfParsedAlign[[1,All]]//Length))*(listOfParsedAlign[[All, All, 1, 1]]//Union//Flatten//Length))]," total. 

GREAT JOB! You rock!"
];
Export["RAXMLpart.txt", RAXMLPart];
Export["alignmentStats.txt", alignStat];
Print["
...
Done."];
]



alignmentRandR[listOfParsedAlign_, locusName_String, dataType_String]:=Block[{alignment, startingPos, lName, locusLength, ll, str, endingpos, a, b, bb, c},
Print["beginning RAXML partition file generation..."];
startingPos=1;
RAXMLPart=Table[
lName= locusName;
locusLength=(ll=(StringLength/@listOfParsedAlign[[i, All, 2]])//Union)[[1]];

If[(ll//Length)>1, Print["ERROR: SEQUENCE lengths are not equal. IS THIS AN ALIGNMENT FILE?
CHECK FOR FORMATTING ERRORS"];Goto["thow";];, Null;];

str=StringJoin[dataType<>", ", lName<>"="<>ToString[startingPos]<>"-"<>ToString[endingpos=((locusLength-1)+startingPos)]<>"
"];
startingPos=locusLength+startingPos;
str
, {i, 1, Length[listOfParsedAlign]}]//StringJoin;
Label["throw"];

(*ALIGNMENT STATISTICS FILE*)
Print["calculating basic alignment statistics..."];
alignStat=StringJoin[
"There are ", ToString[endingpos], " nucleotides in this alignment.", 
"
There are ", ToString[Length[listOfParsedAlign] ], " loci in this alignment.", 
"

Avg. locus length is ", ToString[(endingpos/Length[listOfParsedAlign])//N ],".",
"

The number of missing (?, -, or N) characters is ", ToString[bb=StringCount[b=(listOfParsedAlign[[All, All, 2]]//StringJoin),{"?", "-", "N"} ]],
" out of ", ToString[a=(StringLength[listOfParsedAlign[[All, All, 2]]//StringJoin ])],
" or ",
ToString[((bb/a)//N)*100], " %.", 
"
The total number of missing data blocks (taxa missing all it's data from a given locus) is ", ToString[Count[StringLength/@(StringTrim[#,("N"|"?"|"-")...]&/@(Flatten[listOfParsedAlign[[All,All, 2]]])), 0]], " out of ",ToString[(*# of RAXML parititions times number of taxa*)((StringCount[RAXMLPart, "="]*(listOfParsedAlign[[1,All]]//Length))*(listOfParsedAlign[[All, All, 1, 1]]//Union//Flatten//Length))]," total. 

GREAT JOB! You rock!"
];
Export["RAXMLpart.txt", RAXMLPart];
Export["alignmentStats.txt", alignStat];
Print["
...
Done."];
]



(* ::Subsection::Closed:: *)
(*Concatenating alignments*)


(* ::Text:: *)
(*This function will concatenate multiple alignments if their taxon sets are all the same. It also outputs a RAXML style partition file. NOTE that your input MUST have the same formatting of the fasta files (same data positions in the headers) and you must have the same taxa in all the alignments.. *)
(**)
(*Input and parameters:*)
(*alignments - is a fastaParsed list of fasta alignments.*)
(*locusNamePosition - is an integer indicating the position in the header where the locus name resides*)
(*datatype - is a string indicating what type of data is in the file. This will be printed out in the RAXML file.*)
(*	Possible options are:*)
(*			"DNALoci" - this will output a RAXML style block with specifications for each locus, no codon positions*)
(*			"DNACodon" - this will output a RAXML style block with specifications for each locus by codon position, assuming that the alignments are in reading frame (first positions = 1st codon, with no frame shifts throughout).*)
(**)


concatenateAlignments[alignments_List,locusNamePosition_,dataType_String]:=Block[{out},
Export["concatAlign_"<>(Riffle[ToString/@Date[], "-"]//StringJoin)<>".fasta",out=concatAlign[alignments], "Text"];

alignmentRandR2[alignments,locusNamePosition, dataType ];
]


concatenateAlignments[alignments_List,locusNamePosition_,dataType_String]:=Block[{out},
Export["concatAlign_"<>(Riffle[ToString/@Date[], "-"]//StringJoin)<>".fasta",out=concatAlign[alignments], "Text"];

alignmentRandR2[alignments,locusNamePosition, dataType ]
]


concatenateAlignmentsFromFile[alignmentFiles_List,locusNamePosition_,dataType_String]:=Block[{out, alignments},
alignments=SortBy[importAlignment[#], #[[1, locusNamePosition]]&]&/@alignmentFiles;
Export["concatAlign_"<>(Riffle[ToString/@Date[], "-"]//StringJoin)<>".fasta",out=concatAlign[alignments], "Text"];

alignmentRandR2[alignments,locusNamePosition, dataType ];
]


(* ::Text:: *)
(*Dependency script that does the actual merging of the alignment.*)


concatAlign[listOfParsedAlign_]:=Block[{temp,elf },
If[(((Length/@listOfParsedAlign)//Union)//Length)==1, Null;, Print["ERROR: ALIGNMENTS HAVE DIFFERENT NUMBER OF ENTRIES. FIX BEFORE YOU CONTINUE"]; Goto["throw"];];
elf=SortBy[
Table[
(*the name                               The sequences*)
temp={((#[[j, 1, 1]])&/@listOfParsedAlign)//Union, #[[j, 2]]&/@listOfParsedAlign};
{temp[[1]], StringJoin[temp[[2;;Length[temp]]]]}
, {j, 1, Length[listOfParsedAlign[[1]]]}]
, #[[1, 1]]&]//fastaOutput;
Label["throw"];
Print["done merging files..."];
elf
]


(* ::Subsection::Closed:: *)
(*Cutting an alignment based on a sets or partition file*)


(* ::Text:: *)
(*This function will take an alignment and limit it to a single part based on a RAXML style partition file. As of right now, only consecutive sections of nucleotides will work. I should modify this later to be able to work with the notation "3-499/3" to extract codon positions.*)


alignmentSet[alignment_List, nucleotidePositions_]:=Block[{alpha},
alpha={#[[1]],StringTake[#[[2]], nucleotidePositions[[2]]]}&/@alignment;

If[Length[alpha[[1, 2]]]==0, alpha,
{#[[1]], StringJoin[#[[2]] ]}&/@alpha]

]


alignmentSet[alignment_String, nucleotidePositions_]:=alignmentSet[alignment//importAlignment, nucleotidePositions]


(* ::Subsection::Closed:: *)
(*Reordering characters in an alignment based on a partitions file*)


(* ::Text:: *)
(*This function will take an alignment, and a partition file, and re-sort all the characters in the alignment so that each partition is a single block, and the partitions are sequential.*)
(**)
(*The input is:*)
(*	alignmentFile - a string indicating the exact name of the alignment file in your working directory.*)
(*	partitionFile - a string indicating the exact name of the RAXML style partition file in your working directory.*)


reorderCharInAlign[alignmentFile_String, partitionFile_String]:=Block[{taxonNames, alSplit, partFileInit, partDesignations, dataType, resubed, newAlign, start, np1, newPart, sub},
Block[{alignment1}(*blocked off this part because alignment1 could be very large*),alignment1=importAlignment[alignmentFile];
taxonNames=alignment1[[All, 1, 1]];
alSplit=StringPartition[#, 1]&/@alignment1[[All, 2]];];

partFileInit=Import[partitionFile];
partDesignations=StringTrim/@FlattenAt[{StringSplit[#[[1]],","], StringSplit[#[[2]], ","]}, 1]&/@Partition[StringSplit[partFileInit, {"=", "
"}], 2];
dataType=(partDesignations[[All, 1]]//Union)[[1]]; 
If[(dataType//Length)>1, Print["Error: more than one data type in partition file"];Goto["end"];, Null;];(*checkes that all the dataType lines in the partition file are the same*)

Block[{allPositions, beginAndEnd}(*blocked off this part because allPositions object is going to be very big*),
allPositions=Table[{partDesignations[[i, 1]],partDesignations[[i, 2]],Flatten[If[StringContainsQ[(beginAndEnd=StringSplit[#, "-"])[[2]], "\\"](*this part says if the part designation is divided by codon position (i.e. is non-sequential)*)
,(*make the list like this...*)beginAndEnd=Flatten[{beginAndEnd[[1]]//ToExpression, ToExpression/@StringSplit[beginAndEnd[[2]], "\\"]}]; Apply[Range, beginAndEnd]
,(*otherwise make the list like this..*)Range[beginAndEnd[[1]]//ToExpression, beginAndEnd[[2]]//ToExpression]]&/@partDesignations[[i, 3]]]}
, {i, 1, Length[partDesignations]}];
resubed=Table[{taxonNames[[taxa]],#[[2]],sub=alSplit[[taxa,#[[3]]]]//StringJoin, sub//StringLength}&/@allPositions, {taxa, 1, Length[alSplit]}]; (*with the right part specifications, this section will split up the alignment into lists of taxa with lists of each subset for each taxa, followed by the string length of that subset*)];


(*Now rearrange the alignment and sew together the partition file.*)
newAlign=({#[[All, 1]]//Union,StringJoin[#[[All, 3]] ]}&/@resubed);
np1=Flatten[({#[[All, 2]], #[[All, 4]]}&/@resubed)//Union, 1]//Transpose;
start=0;
newPart=StringJoin[{dataType<>", "<>#[[1]]<>" = "<>ToString[start+1]<>"-"<>ToString[start=(#[[2]]+start)]<>";
"}&/@np1];

Export["rearranged."<>alignmentFile,newAlign//fastaOutput, "Text" ];
Export["sequentialPartitionFile.txt",newPart, "Text" ];

Label["end"];

]


reorderCharInAlign[alignmentFile_String, partitionFile_String,"Hold"]:=Block[{taxonNames, alSplit, partFileInit, partDesignations, dataType, resubed, newAlign, start, np1, newPart, sub},
Block[{alignment1}(*blocked off this part because alignment1 could be very large*),alignment1=importAlignment[alignmentFile];
taxonNames=alignment1[[All, 1, 1]];
alSplit=StringPartition[#, 1]&/@alignment1[[All, 2]];];

partFileInit=Import[partitionFile];
partDesignations=StringTrim/@FlattenAt[{StringSplit[#[[1]],","], StringSplit[#[[2]], ","]}, 1]&/@Partition[StringSplit[partFileInit, {"=", "
"}], 2];
dataType=(partDesignations[[All, 1]]//Union)[[1]]; 
If[(dataType//Length)>1, Print["Error: more than one data type in partition file"];Goto["end"];, Null;];(*checkes that all the dataType lines in the partition file are the same*)

Block[{allPositions, beginAndEnd}(*blocked off this part because allPositions object is going to be very big*),
allPositions=Table[{partDesignations[[i, 1]],partDesignations[[i, 2]],Flatten[If[StringContainsQ[(beginAndEnd=StringSplit[#, "-"])[[2]], "\\"](*this part says if the part designation is divided by codon position (i.e. is non-sequential)*)
,(*make the list like this...*)beginAndEnd=Flatten[{beginAndEnd[[1]]//ToExpression, ToExpression/@StringSplit[beginAndEnd[[2]], "\\"]}]; Apply[Range, beginAndEnd]
,(*otherwise make the list like this..*)Range[beginAndEnd[[1]]//ToExpression, beginAndEnd[[2]]//ToExpression]]&/@partDesignations[[i, 3]]]}
, {i, 1, Length[partDesignations]}];
resubed=Table[{taxonNames[[taxa]],#[[2]],sub=alSplit[[taxa,#[[3]]]]//StringJoin, sub//StringLength}&/@allPositions, {taxa, 1, Length[alSplit]}]; (*with the right part specifications, this section will split up the alignment into lists of taxa with lists of each subset for each taxa, followed by the string length of that subset*)];


(*Now rearrange the alignment and sew together the partition file.*)
newAlign=({#[[All, 1]]//Union,StringJoin[#[[All, 3]] ]}&/@resubed);
np1=Flatten[({#[[All, 2]], #[[All, 4]]}&/@resubed)//Union, 1]//Transpose;
start=0;
newPart=StringJoin[{dataType<>", "<>#[[1]]<>" = "<>ToString[start+1]<>"-"<>ToString[start=(#[[2]]+start)]<>";
"}&/@np1];

Export["sequentialPartitionFile.txt",newPart, "Text" ];

Label["end"];
newAlign
]


reorderCharInAlign[alignment_List, partitionFile_String]:=Block[{taxonNames, alSplit, partFileInit, partDesignations, dataType, resubed, newAlign, start, np1, newPart, sub},
Block[{alignment1}(*blocked off this part because alignment1 could be very large*),alignment1=alignment;
taxonNames=alignment1[[All, 1, 1]];
alSplit=StringPartition[#, 1]&/@alignment1[[All, 2]];];

partFileInit=Import[partitionFile];
partDesignations=StringTrim/@FlattenAt[{StringSplit[#[[1]],","], StringSplit[#[[2]], ","]}, 1]&/@Partition[StringSplit[partFileInit, {"=", "
"}], 2];
dataType=(partDesignations[[All, 1]]//Union)[[1]]; 
If[(dataType//Length)>1, Print["Error: more than one data type in partition file"];Goto["end"];, Null;];(*checkes that all the dataType lines in the partition file are the same*)

Block[{allPositions, beginAndEnd}(*blocked off this part because allPositions object is going to be very big*),
allPositions=Table[{partDesignations[[i, 1]],partDesignations[[i, 2]],Flatten[If[StringContainsQ[(beginAndEnd=StringSplit[#, "-"])[[2]], "\\"](*this part says if the part designation is divided by codon position (i.e. is non-sequential)*)
,(*make the list like this...*)beginAndEnd=Flatten[{beginAndEnd[[1]]//ToExpression, ToExpression/@StringSplit[beginAndEnd[[2]], "\\"]}]; Apply[Range, beginAndEnd]
,(*otherwise make the list like this..*)Range[beginAndEnd[[1]]//ToExpression, beginAndEnd[[2]]//ToExpression]]&/@partDesignations[[i, 3]]]}
, {i, 1, Length[partDesignations]}];
resubed=Table[{taxonNames[[taxa]],#[[2]],sub=alSplit[[taxa,#[[3]]]]//StringJoin, sub//StringLength}&/@allPositions, {taxa, 1, Length[alSplit]}]; (*with the right part specifications, this section will split up the alignment into lists of taxa with lists of each subset for each taxa, followed by the string length of that subset*)];


(*Now rearrange the alignment and sew together the partition file.*)
newAlign=({#[[All, 1]]//Union,StringJoin[#[[All, 3]] ]}&/@resubed);
np1=Flatten[({#[[All, 2]], #[[All, 4]]}&/@resubed)//Union, 1]//Transpose;
start=0;
newPart=StringJoin[{dataType<>", "<>#[[1]]<>" = "<>ToString[start+1]<>"-"<>ToString[start=(#[[2]]+start)]<>";
"}&/@np1];

Export["rearranged."<>alignmentFile,newAlign//fastaOutput, "Text" ];
Export["sequentialPartitionFile.txt",newPart, "Text" ];

Label["end"];

]


(* ::Subsection::Closed:: *)
(*Cutting alignment based on codon positions, when codon positions are known*)


(* ::Text:: *)
(*This function will remove characters in sets of three, following codon position patterns. However, this function does not infer the position of codons from the alignment, you have to do that elsewhere.*)
(**)
(*Input:*)
(*	alignment = a fastaParsed alignment object*)
(*	positionToExtract = a list of integers representing the codons you want to extract from your alignment*)
(*	codonStartPos = an integer representing the position of the FIRST instance of a FIRST codon position*)


codonExtract[alignment_, positionToExtract_List, codonStartPos_]:=Block[{},
If[(positionToExtract//Length)>1, Null;, Goto["single"];];
(*the part immediately below is doing something wrong because positionToExtract={1, 2, 3} and {1, 2} do the same thing...*)
If[(positionToExtract//Length)==2, Null;, Goto["triple"];];
abc=StringJoin[Riffle[#[[1]], #[[2]]]]&/@(codonParse[alignment, codonStartPos][[positionToExtract]][[All, All, 2]]//Transpose);
alignedCodons=Partition[Riffle[alignment[[All, 1]],abc], 2];
Goto["end"];
Label["triple"];
(*this one just cuts out the beginning of the alignment so that it is aligned with the first nucleotide being the start of the reading frame*)
alignedCodons={#[[1]], StringDrop[#[[2]], codonStartPos-1]}&/@aaa;
Goto["end"];
Label["single"];
alignedCodons={#[[1]], #[[2]]//StringJoin}&/@codonParse[alignment, codonStartPos][[positionToExtract]][[1]];
Label["end"];
alignedCodons
]


(* ::Text:: *)
(*This function will just take an alignment and prepare it for easy codon extraction. Options are the same as above.*)


codonParse[alignment_, codonStartPos_]:=Block[{aligns,alignLength},

alignLength=Union[StringLength/@alignment[[All, 2]]];
If[(alignLength//Length)>1, Print["ERROR: NUCLEOTIDE SEQS NOT OF EQUAL LENGTH. IS THIS AN ALIGNMENT?"], Null;];
aligns=StringDrop[#, codonStartPos-1]&/@alignment[[All, 2]];
FirstCodonPos=Partition[Riffle[alignment[[All, 1]], StringPartition[#, 1, 3]&/@aligns], 2];
aligns=StringDrop[#, 1]&/@aligns;
SecondCodonPos=Partition[Riffle[alignment[[All, 1]],StringPartition[#, 1, 3]&/@aligns], 2];
aligns=StringDrop[#, 1]&/@aligns;
ThirdCodonPos=Partition[Riffle[alignment[[All, 1]],StringPartition[#, 1, 3]&/@aligns], 2];
{FirstCodonPos,SecondCodonPos, ThirdCodonPos}
]


(* ::Section::Closed:: *)
(*Trimming alignments*)


(* ::Subsection::Closed:: *)
(*Trimming alignments (horizontal)*)


(* ::Subsubsection::Closed:: *)
(*Trim positions*)


(* ::Text:: *)
(*TrimAl is a very good software for quickly trimming alignments. However, it can't handle large files. I wrote a very simplistic alignment reducer that can handle larger alignments simply because it's based in mathematica.*)
(*Input:*)
(*	alignment - a raw alignment file name in FASTA format*)
(*Parameters:*)
(*	reductionPercent - the % of data you want to reduce by. For example, a value of .80 will delete the 80% least complete positions.*)


trimAlign[alignment_String, reductionPercent_]:=Block[{nucleotides,  abc, best, names, worst}, 
Print["Importing file..."];

Block[{align},
align=importAlignment[alignment];
Print["Import complete.
Sorting and counting..."];
nucleotides=StringPartition[#, 1]&/@align[[All, 2]];
names=align[[All, 1]]];

abc=SortBy[nucleotides//Transpose,Count[#, ("?"|"-"|"N"|"n")]& ];
Print["Sorting and counting complete.
Making the better alignment..."];
best=Take[abc[[1;;(Round[(Length[abc]*(1 - reductionPercent)), 1])]]];
worst=Take[abc[[(Round[(Length[abc]*(1 - reductionPercent)), 1]);;Length[abc]]]   ];
(*
Print["All positiongs in the alignment have ~"<>ToString[]<>" or more nucleotides."];*)
Print["Made the best one from your parameters...just need to export."];
Export["bestOf_"<>alignment,Partition[Riffle[names,StringJoin/@(best//Transpose)], 2]//fastaOutput, "String"];
Export["worstOf_"<>alignment,Partition[Riffle[names,StringJoin/@(worst//Transpose)], 2]//fastaOutput, "String"];
Print["Done.

HHHHHYAAA!   "];
]


(* ::Text:: *)
(*This function is similar to the above but uses a different (possibly more useful) method. The parameter it uses to trim the alignment is the proportion of sequences with missing data.*)
(**)
(*Input:*)
(*	alignment - a raw alignment file name in FASTA format*)
(*Parameters:*)
(*	missingProportion - The max percentage of missing data you accept. All positions with more missing data than this will be deleted.  For example, a value of 0.2 will remove all nucleotide positions with 20% or more missing data. A higher number means that more nucleotides will be deleted*)


trimAlign2[alignment_, missingProportion_]:=Block[{nucleotides,  abc, best, names, worst, alignLength, missingDataCounts, a}, 
Print["Importing file..."];

Block[{align},
align=importAlignment[alignment];
Print["Import complete.
Doing some data prep..."];
nucleotides=StringPartition[#, 1]&/@align[[All, 2]];
names=align[[All, 1]];
alignLength=align//Length;];
abc=nucleotides//Transpose;
Print["Initial steps complete.
Making the better alignment..."];
missingDataCounts=ParallelTable[
Count[abc[[i(*loop*)]],"?"|"-"|"N"|"n" ]
, {i, 1, Length[abc] }];
worst=StringJoin/@(Pick[abc,missingDataCounts,x_/;(x>= (missingProportion*alignLength))]//Transpose);
best=StringJoin/@(If[a=Pick[abc,missingDataCounts,x_/;(x<(missingProportion*alignLength))];Length[a]==0,Print[ToString[alignment]<>"is eliminated completly after removing missing data positions. Raise 'missingProportion'."];Goto["end"];, a ]//Transpose);(*edited this part jan 27 2018*)
(*
Print["All positiongs in the alignment have ~"<>ToString[]<>" or more nucleotides."];*)
Print["Made the best one from your parameters...just need to export."];
Export["bestOf_"<>alignment,Partition[Riffle[names,best], 2]//fastaOutput, "String"];
Label["end"];
Export["worstOf_"<>alignment,Partition[Riffle[names,worst], 2]//fastaOutput, "String"];
Print["Done with "<>ToString[alignment]];
]


(* ::Text:: *)
(*This is a version of the above compatible with amino-acid sequences.*)


trimAlign2AA[alignment_, missingProportion_]:=Block[{nucleotides,  abc, best, names, worst, alignLength, missingDataCounts}, 
Print["Importing file..."];

Block[{align},
align=importAlignment[alignment];
Print["Import complete.
Doing some data prep..."];
nucleotides=StringPartition[#, 1]&/@align[[All, 2]];
names=align[[All, 1]];
alignLength=align//Length;];
abc=nucleotides//Transpose;
Print["Initial steps complete.
Making the better alignment..."];
missingDataCounts=ParallelTable[
Count[abc[[i(*loop*)]],"?"|"-" ]
, {i, 1, Length[abc] }];
worst=StringJoin/@(Pick[abc,missingDataCounts,x_/;(x>= (missingProportion*alignLength))]//Transpose);
best=StringJoin/@(If[a=Pick[abc,missingDataCounts,x_/;(x<(missingProportion*alignLength))];Length[a]==0,Print[ToString[alignment]<>"is eliminated completly after removing missing data positions. Raise 'missingProportion'."];Goto["end"];, a ]//Transpose);(*edited this part jan 27 2018*)
(*
Print["All positiongs in the alignment have ~"<>ToString[]<>" or more nucleotides."];*)
Print["Made the best one from your parameters...just need to export."];
Export["bestOf_"<>alignment,Partition[Riffle[names,best], 2]//fastaOutput, "String"];
Label["end"];
Export["worstOf_"<>alignment,Partition[Riffle[names,worst], 2]//fastaOutput, "String"];
Print["Done.

GRRRRAAAAAHHHHHHHHHHH!   "];
]


(* ::Text:: *)
(*This is a slimmed down version of the above function that takes a fastaParsed list as input, rather than a file name.*)


trimAlign2Slim[alignment_List, missingProportion_]:=
Block[{nucleotides,  abc, best, names, worst, alignLength, align, missingDataCounts}, 
align=alignment;
nucleotides=StringPartition[#, 1]&/@align[[All, 2]];
names=align[[All, 1]];
alignLength=align//Length;
abc=nucleotides//Transpose;

missingDataCounts=ParallelTable[
Count[abc[[i(*loop*)]],"?"|"-"|"N"|"n" ]
, {i, 1, Length[abc] }];
worst=StringJoin/@(Pick[abc,missingDataCounts,x_/;(x>= (missingProportion*alignLength))]//Transpose);
best=StringJoin/@(Pick[abc,missingDataCounts,x_/;(x<(missingProportion*alignLength))]//Transpose);(*NOTE add an edit here to reflect the same edits from the other functions above: situations where the whole alignment is eliminated.*)

bestPositions=Partition[Riffle[names,best], 2];
worstPositions=Partition[Riffle[names,worst], 2];
]


(* ::Subsubsection::Closed:: *)
(*Trim from ends (general)*)


(* ::Text:: *)
(*Automated trimming is great but could potentially change codon structure or delete incorrectly internally aligned regions. To account for this we can just make the decision to trim from the end of the alignments. We can base how much we trim on an arbitrary number (e.g. 50 nucleotides), or we can base it on the number of sequences represented (e.g. 20%).*)
(**)
(*fastaFile=the name of an alignment file in the working directory*)
(*emptinessAllowed= the maximum percentage of emptiness you're willing to allow. Any percentage lower than this will be removed*)


(*trimEnds[#, .8]&/@fn*)


trimEnds[fastaFile_,emptinessAllowed_]:=Block[{seqs, fasta, seqsRev, align, alignRev, totCharacters, totTaxa,frontCut, backCut,emptinessPercent},
seqs=(fasta=importAlignment[fastaFile])[[All, 2]];
seqsRev=(StringReverse[#]&/@seqs);
emptinessPercent=emptinessAllowed;

(align=(StringPartition[#,1]&/@seqs)//Transpose);
(alignRev=(StringPartition[#,1]&/@seqsRev)//Transpose);

totCharacters=align//Length;
totTaxa=seqs//Length;
(*find cut front cut*)

frontCut=findcut[align, emptinessPercent];
backCut=findcut[alignRev, emptinessPercent];

Export["endCut."<>fastaFile,({#[[1]], StringDrop[StringDrop[#[[2]],frontCut], -backCut]}&/@fasta)//fastaOutput, "Text"];
]


(* ::Text:: *)
(*In the simple version we will automatically chop the alignment down to the core data set (sites with 75 % of their data present).*)


trimEnds[fastaFile_]:=trimEnds[fastaFile,.25]


(* ::Text:: *)
(*This version will simply trim the specified amount off of both ends of the alignment.*)


trimEnds[fastaFile_,length_, "Both"]:=Block[{seqs, fasta, seqsRev, align, alignRev, totCharacters, totTaxa,frontCut, backCut,emptinessPercent},
fasta=importAlignment[fastaFile];
frontCut=length;
backCut=length;

Export["endCut."<>fastaFile,({#[[1]], StringDrop[StringDrop[#[[2]],frontCut], -backCut]}&/@fasta)//fastaOutput, "Text"];
]


(* ::Text:: *)
(*This version will trim the specified amount off the left or right.*)


trimEnds[fastaFile_,length_, "Right"]:=Block[{seqs, fasta, seqsRev, align, alignRev, totCharacters, totTaxa,frontCut, backCut,emptinessPercent},
fasta=importAlignment[fastaFile];
frontCut=0;
backCut=length;

Export["rightCut."<>fastaFile,({#[[1]], StringDrop[StringDrop[#[[2]],frontCut], -backCut]}&/@fasta)//fastaOutput, "Text"];
]


trimEnds[fastaFile_,length_, "Left"]:=Block[{seqs, fasta, seqsRev, align, alignRev, totCharacters, totTaxa,frontCut, backCut,emptinessPercent},
fasta=importAlignment[fastaFile];
frontCut=length;
backCut=0;

Export["leftCut."<>fastaFile,({#[[1]], StringDrop[StringDrop[#[[2]],frontCut], -backCut]}&/@fasta)//fastaOutput, "Text"];
]


(* ::Text:: *)
(*Another version to keep the formatting consistent.*)


trimEnds[fastaFile_,emptinessAllowed_,"Percentage"]:=trimEnds[fastaFile,emptinessAllowed]


(* ::Text:: *)
(*Dependency script.*)


findcut[align_, emptinessPercent_]:=Block[{blockEmptiness,totTaxa},
totTaxa=align[[1]]//Length;
Table[
blockEmptiness=((((countMissing/@{#1,#2, #3, #4, #5, #6, #7, #8, #9, #10})&[align[[i]], align[[i+1]], align[[i+2]], align[[i+3]],  align[[i+4]],  align[[i+5]],  align[[i+6]],  align[[i+7]],  align[[i+8]],  align[[i+9]]])//Total)/10);
(*the above block will count the average number of characters missing (- or ?) in a block of 10 in an alignment. if you want the sliding window to be >10 you will have to change the above code*) 
If[blockEmptiness>(totTaxa*emptinessPercent),Null;,cut=i; Goto["throw"]; ]
(*the above says if the average number of characters missing is above the amount specified by the input then keep going...when it's above that amount, log the position (cut)*)
, {i, 1, Length[align]}];
Label["throw"];
cut
]


(* ::Text:: *)
(*Dependancy script.*)


countMissing[nucList_]:=Block[{},
Count[nucList, "-"]+Count[nucList, "?"]
]


(* ::Subsubsection::Closed:: *)
(*Trim codon alignments at right*)


(* ::Text:: *)
(*This function will trim the end of all alignments so that the last codon isn't cut off. IMPORTANT: This function assumes your first nucleotide on the left is a first codon position and everything is in the same reading frame. In other words...all this function does is make sure your alignment length is a multiple of 3. *)


makeAlignmentLengthDivisibleby3[alignment_String]:=Which[
Divisible[getSequenceLengths[alignment, "Alignment"][[1]], 3],fastaExport["rightCut."<>alignment,alignment//importAlignment ],
Divisible[getSequenceLengths[alignment, "Alignment"][[1]]-1, 3],trimEnds[alignment,1 , "Right"] ,
Divisible[getSequenceLengths[alignment, "Alignment"][[1]]-2, 3],trimEnds[alignment,2, "Right"]  ]


(* ::Subsection::Closed:: *)
(*"Square" an alignment*)


(* ::Text:: *)
(*This function combines two trimming functions to fix an alignment with a high proportion of missing data. It trims the data vertically (by removing taxa with missing data) and horizontally (by removing positions with missing data).*)
(*Input*)
(*alignment = an alignment file name. So you must set the directory to the folder with your alignments.*)
(*Parameters*)
(*verticalTrim - parameter for deleteEmptySequences function. The maximum amount of missing data a sequence can have, otherwise it is deleted.*)
(*horizontalTrim - parameter for trimAlign2Slim function. The max percentage of missing data you accept. All positions with more missing data than this will be deleted.  For example, a value of 0.2 will remove all nucleotide positions with 20% or more missing data. A higher number means that more nucleotides will be deleted.*)
(*format - a string indicating the output style. Currently accepted options are "Fasta" and "Nexus". Nexus format will remove taxon names.*)


squareAlignment[alignment_String, verticalTrim_, horizontalTrim_, "Nexus" (*format*)]:=Block[{align, newAlign},
align=importAlignment[alignment];
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
Export[alignment<>".square.nex", bestPositions[[All, 2]],"Nexus"];

]


squareAlignment[alignment_String, verticalTrim_, horizontalTrim_, "Nexus" (*format*), "Hold"]:=Block[{align, newAlign},
align=importAlignment[alignment];
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
bestPositions[[All, 2]]
]


squareAlignment[alignment_List, verticalTrim_, horizontalTrim_, "Nexus" (*format*)]:=Block[{align, newAlign},
align=alignment;
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
bestPositions[[All, 2]]
]


squareAlignment[alignment_String, verticalTrim_, horizontalTrim_, "Fasta"]:=Block[{align, newAlign},
align=importAlignment[alignment];
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
Export[alignment<>".square.fasta", bestPositions//fastaOutput,"Text"];
]


squareAlignment[alignment_String, verticalTrim_, horizontalTrim_, "Fasta", "Hold"]:=Block[{align, newAlign},
align=importAlignment[alignment];
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
bestPositions//fastaOutput
]


squareAlignment[alignment_List, verticalTrim_, horizontalTrim_, "Fasta"]:=Block[{align, newAlign},
align=alignment;
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
bestPositions//fastaOutput
]


squareAlignment[alignment_String, verticalTrim_, horizontalTrim_, "Phylip"]:=Block[{align, newAlign},
align=importAlignment[alignment];
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
Export[alignment<>".square.phy", bestPositions//toPhylip,"Text"];
]


squareAlignment[alignment_String, verticalTrim_, horizontalTrim_, "Phylip", "Hold"]:=Block[{align, newAlign},
align=importAlignment[alignment];
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
bestPositions//toPhylip
]


squareAlignment[alignment_List, verticalTrim_, horizontalTrim_, "Phylip"]:=Block[{align, newAlign},
align=alignment;
trimAlign2Slim[deleteEmptySequences[align, verticalTrim], horizontalTrim];
bestPositions//toPhylip
]


(* ::Section:: *)
(*Codons and AminoAcids*)


(* ::Text:: *)
(*NOTE: Add in a function here that calls MAFFT or Muscle to realign if the number of stop codons is too high.*)


(* ::Subsection::Closed:: *)
(*Translate an alignment to amino acids*)


(* ::Text:: *)
(*NOTE: I need to update the below functions to handle non-standard genetic codes. I can add it as an option to choose the matrix used.*)


(* ::Text:: *)
(*NOTE: That this does work with alignments, but still messes up some sequences that should be aligned correctly. I am not sure why but I should explore more.*)


(* ::Text:: *)
(*This version requires that you decide on a correct reading direction in the alignment. This can be done via the --adjustdirection option in MAFFT. The only way this differs from the analogous function in the FASTA section is that this does not test reverse complement trand reads...so it's actually faster in that respect.*)


(* ::Text:: *)
(*Translate multiple FASTA files*)


(* ::Text:: *)
(*input = the nucleotide FASTA file name you want to translate*)


translateAlignment[input_String]:=Block[{},
fastaExport["aa."<>input,importAlignment[input]//translateAlignment//fastaOutput]
]


translateAlignment[input_String,"Hold"]:=Block[{},
importAlignment[input]//translateAlignment//fastaOutput
]


(* ::Text:: *)
(*Translate a whole FASTA parsed object*)


(* ::Text:: *)
(*fastaParsed = a fastaParsed object*)


translateAlignment[fastaParsed_List]:=Block[{},{#[[1]], translate2[#[[2]]]}&/@fastaParsed]


(* ::Text:: *)
(*Translating a single FASTA entry*)


translate2[sequence_String]:=Block[{a, c,d, transLateIn3Frames,numStops,stopPoss,distances,maxDistance,numstopsMiddle, crit1, crit2, crit3,crit4,crit5, crit6, crit7, crit8, crit9,translation, scores1, scores2, scores3, tally},
(*translate in 6 standard reading frames*)
a=(StringPartition[StringDrop[sequence//ToUpperCase,#], 3]&/@{0, 1, 2});
(*b=(StringPartition[StringDrop[sequence//ToUpperCase//revComp,#], 3]&/@{0, 1, 2}); Commentted out because this was the reverse complement section*)
transLateIn3Frames=Flatten[{a}, 1]/.replaceTableStd;
transLateIn3Frames=(transLateIn3Frames/.x_/;(StringLength[x]>2)->"?")//Quiet; (*this line just turns any untranslated codons (because they have some kind of undefined degeneracy, into ?'s*)

(*I am using three criteria to determine the reading frame of the sequence.
1. The reading frame that reduces the number of stop codons.
2. The reading frame that creates the largest gap without stop codons.
3. The reading frame that reduces the number of stop codons in the middle of the read.

Criteria 3 is the tie breaking criterion. The rationale is that a read or transcript should be dirty on the end and we would expect stop codons there because these are introns, or dirty data.
*)
numStops=StringCount[#,"*"]&/@StringJoin/@transLateIn3Frames;
stopPoss=(Flatten[{(Union[#]&/@StringPosition[#,"*"]), 0, StringLength[#]}]//Sort)&/@StringJoin/@transLateIn3Frames;
distances=(Differences[#]&/@#&/@((Partition[#, 2])&/@stopPoss));
maxDistance=Max/@distances;
numstopsMiddle=StringCount[#,"*"]&/@(StringDrop[StringDrop[#,10],-10]&/@StringJoin/@transLateIn3Frames);

crit1=Position[numStops, numStops//Min]//Flatten;
crit2=Position[maxDistance, maxDistance//Max]//Flatten;
crit3 = Position[numstopsMiddle, numstopsMiddle//Min]//Flatten;

(*this part actually makes the decision of which criteria wins. It is unfinished because it doesn't say what to do if there is a tie, which is possible, although unlikely.*)
(*Which[
crit1\[Equal]crit2,translation=transLateIn6Frames[[crit1[[1]]]];,
crit3\[Equal]crit2,translation=transLateIn6Frames[[crit2[[1]]]];,
((c=Intersection[crit1, crit2, crit3])//Length)\[Equal]1,translation=transLateIn6Frames[[c[[1]]]];,
(c//Length)\[NotEqual] 1,translation=c; Print["Criteria ambiguous."](*throw to a script that makes more than one sequence*)
]; 
(*print a single output*)

(*note that if a nucleotide sequence has an ambiguity (N) it could be that there is a frame shift within the sequence. We could account for this by duplicating the original sequence by replacing all the "N"'s with "NN"'s or ""'s. I looked in the transcriptome files and this seems to be a very rare case, so I am not adding it now. It might be an issue witht eh AHE files or different data types*)
translation//StringJoin*)
Which[
crit1==crit2,translation=transLateIn3Frames[[crit1[[1]]]];,(*which condition 1*)
crit3==crit2,translation=transLateIn3Frames[[crit2[[1]]]];, (*condition 2*)
((d=Intersection[crit1, crit2, crit3])//Length)==1,translation=transLateIn3Frames[[d[[1]]]];,(*condition 3*)


(*Calculate further criteria*)
(crit4=Position[numStops[[1;;3]], numStops[[1;;3]]//Min]//Flatten;
crit5=Position[maxDistance[[1;;3]], maxDistance[[1;;3]]//Max]//Flatten;
crit6= Position[numstopsMiddle[[1;;3]], numstopsMiddle[[1;;3]]//Min]//Flatten;);

((c=Intersection[crit4, crit5, crit6])//Length)==1,translation=transLateIn3Frames[[c[[1]]]];, (*condition 4*)

(*Calculate another criteria (this one depends on giving scores based on ranks, and the one with the lowest score, wins.*)
(scores1=((Position[numStops//Sort, #][[1]]&/@numStops)//Flatten);
scores2=(Position[maxDistance//Sort//Reverse, #][[1]]&/@maxDistance)//Flatten;
scores3=(Position[numstopsMiddle//Sort, #][[1]]&/@numstopsMiddle)//Flatten;
tally=scores1+scores2+scores3;);
((c=Position[tally, Min[tally]])//Length)==1,translation=transLateIn3Frames[[c[[1]]]];, (*condition 6*)

(*another criteria: this one will pick randomly from among some of the best options. At this point, we have eliminated the vast majority of sequences. Now, we are only dealing with very rare cases, so choosing randomly among a set of possible options isn't such a bad idea. The bad ones should be eliminated in masking phase anyway*)

1==1 (*will always be true...*), translation=transLateIn3Frames[[Append[Intersection[crit1, crit2, crit3], crit2]//Flatten//RandomChoice]]

]; 
translation//StringJoin
]


(* ::Subsection::Closed:: *)
(*Count stop-codons*)


(* ::Text:: *)
(*NOTE: What about non-standard genetic codes? This needs to be fixed.*)


(* ::Text:: *)
(*The functions here use the code from the translation functions.*)


countStopCodons[fileName_String]:=Block[{},
Total[Min/@(countStopCodonInAlignment[importAlignment[fileName]])]
]


countStopCodonsAll[fileNames_List]:={#,countStopCodons[#]}&/@fileNames


countStopCodons[fastaParsed_List]:=Block[{},
countStopCodonInSequence[#]&/@fastaParsed[[All, 2]]
]


countStopCodonInSequence[sequence_String]:=Block[{a, c,d, transLateIn3Frames,numStops,stopPoss,distances,maxDistance,numstopsMiddle, crit1, crit2, crit3,crit4,crit5, crit6, crit7, crit8, crit9,translation, scores1, scores2, scores3, tally},
(*translate in 6 standard reading frames*)
a=(StringPartition[StringDrop[sequence//ToUpperCase,#], 3]&/@{0, 1, 2});
(*b=(StringPartition[StringDrop[sequence//ToUpperCase//revComp,#], 3]&/@{0, 1, 2}); Commentted out because this was the reverse complement section*)
transLateIn3Frames=Flatten[{a}, 1]/.replaceTableStd;
transLateIn3Frames=(transLateIn3Frames/.x_/;(StringLength[x]>2)->"?")//Quiet; 
numStops=StringCount[#,"*"]&/@StringJoin/@transLateIn3Frames;
numStops
]


(* ::Subsection::Closed:: *)
(*Exporting alignments by codon position*)


(* ::Text:: *)
(*This function takes advantage of the AA translation scripts to determine reading frame. This version however, requires that sequences have been prealigned and are all in the same reading direction (i.e. not reverse complemented).*)
(*alignmentFile = alignment file name or a fastaParsed object.*)
(*codonsYouWantList = list of integers giving what codons you want in the exported alignment *)
(*exportName = the name of the file to export.*)


makeCodonReadAlignment[alignmentFile_String,codonsYouWantList_, exportName_]:=Block[{aaa},
Export[exportName, codonExtract[aaa=alignmentFile//importAlignment,codonsYouWantList, 
((readingFrame/@aaa[[All, 2]])//Commonest)[[1]]+1 ]//fastaOutput, "Text"]
]


makeCodonReadAlignment[alignmentFile_String,codonsYouWantList_, exportName_, "Hold"]:=Block[{aaa},
codonExtract[aaa=alignmentFile//importAlignment,codonsYouWantList, 
((readingFrame/@aaa[[All, 2]])//Commonest)[[1]]+1 ]//fastaOutput
]


makeCodonReadAlignment[alignmentFile_String,codonsYouWantList_,"Hold"]:=Block[{aaa},
codonExtract[aaa=alignmentFile//importAlignment,codonsYouWantList, 
((readingFrame/@aaa[[All, 2]])//Commonest)[[1]]+1 ]//fastaOutput
]


makeCodonReadAlignment[alignmentFile_List,codonsYouWantList_]:=Block[{aaa},
codonExtract[aaa=alignmentFile,codonsYouWantList, 
((readingFrame/@aaa[[All, 2]])//Commonest)[[1]]+1 ]
]


(* ::Text:: *)
(*Dependency script that determines the reading frame through a modified version of the AA translation code.*)


readingFrame[sequence_String]:=Block[{a, c,d, transLateIn3Frames,numStops,stopPoss,distances,maxDistance,numstopsMiddle, crit1, crit2, crit3,crit4,crit5, crit6, crit7, crit8, crit9,translation, scores1, scores2, scores3, tally},
(*translate in 6 standard reading frames*)
a=(StringPartition[StringDrop[sequence//ToUpperCase,#], 3]&/@{0, 1, 2});
(*b=(StringPartition[StringDrop[sequence//ToUpperCase//revComp,#], 3]&/@{0, 1, 2}); Commentted out because this was the reverse complement section*)
transLateIn3Frames=Flatten[{a}, 1]/.replaceTableStd;
transLateIn3Frames=(transLateIn3Frames/.x_/;(StringLength[x]>2)->"?")//Quiet; (*this line just turns any untranslated codons (because they have some kind of undefined degeneracy, into ?'s*)

(*I am using three criteria to determine the reading frame of the sequence.
1. The reading frame that reduces the number of stop codons.
2. The reading frame that creates the largest gap without stop codons.
3. The reading frame that reduces the number of stop codons in the middle of the read.

Criteria 3 is the tie breaking criterion. The rationale is that a read or transcript should be dirty on the end and we would expect stop codons there because these are introns, or dirty data.
*)
numStops=StringCount[#,"*"]&/@StringJoin/@transLateIn3Frames;
stopPoss=(Flatten[{(Union[#]&/@StringPosition[#,"*"]), 0, StringLength[#]}]//Sort)&/@StringJoin/@transLateIn3Frames;
distances=(Differences[#]&/@#&/@((Partition[#, 2])&/@stopPoss));
maxDistance=Max/@distances;
numstopsMiddle=StringCount[#,"*"]&/@(StringDrop[StringDrop[#,10],-10]&/@StringJoin/@transLateIn3Frames);

crit1=Position[numStops, numStops//Min]//Flatten;
crit2=Position[maxDistance, maxDistance//Max]//Flatten;
crit3 = Position[numstopsMiddle, numstopsMiddle//Min]//Flatten;

(*this part actually makes the decision of which criteria wins. It is unfinished because it doesn't say what to do if there is a tie, which is possible, although unlikely.*)
(*Which[
crit1\[Equal]crit2,translation=transLateIn6Frames[[crit1[[1]]]];,
crit3\[Equal]crit2,translation=transLateIn6Frames[[crit2[[1]]]];,
((c=Intersection[crit1, crit2, crit3])//Length)\[Equal]1,translation=transLateIn6Frames[[c[[1]]]];,
(c//Length)\[NotEqual] 1,translation=c; Print["Criteria ambiguous."](*throw to a script that makes more than one sequence*)
]; 
(*print a single output*)

(*note that if a nucleotide sequence has an ambiguity (N) it could be that there is a frame shift within the sequence. We could account for this by duplicating the original sequence by replacing all the "N"'s with "NN"'s or ""'s. I looked in the transcriptome files and this seems to be a very rare case, so I am not adding it now. It might be an issue witht eh AHE files or different data types*)
translation//StringJoin*)
Which[
crit1==crit2,whichOne=crit1[[1]];,(*which condition 1*)
crit3==crit2,whichOne=crit2[[1]];, (*condition 2*)
((d=Intersection[crit1, crit2, crit3])//Length)==1,whichOne=d[[1]];,(*condition 3*)


(*Calculate further criteria*)
(crit4=Position[numStops[[1;;3]], numStops[[1;;3]]//Min]//Flatten;
crit5=Position[maxDistance[[1;;3]], maxDistance[[1;;3]]//Max]//Flatten;
crit6= Position[numstopsMiddle[[1;;3]], numstopsMiddle[[1;;3]]//Min]//Flatten;);

((c=Intersection[crit4, crit5, crit6])//Length)==1,whichOne=c[[1]];, (*condition 4*)

(*Calculate another criteria (this one depends on giving scores based on ranks, and the one with the lowest score, wins.*)
(scores1=((Position[numStops//Sort, #][[1]]&/@numStops)//Flatten);
scores2=(Position[maxDistance//Sort//Reverse, #][[1]]&/@maxDistance)//Flatten;
scores3=(Position[numstopsMiddle//Sort, #][[1]]&/@numstopsMiddle)//Flatten;
tally=scores1+scores2+scores3;);
((c=Position[tally, Min[tally]])//Length)==1,whichOne=c[[1]];, (*condition 6*)

(*another criteria: this one will pick randomly from among some of the best options. At this point, we have eliminated the vast majority of sequences. Now, we are only dealing with very rare cases, so choosing randomly among a set of possible options isn't such a bad idea. The bad ones should be eliminated in masking phase anyway*)

1==1 (*will always be true...*), translation=Append[Intersection[crit1, crit2, crit3], crit2]//Flatten//RandomChoice;
]; 
whichOne-1
]


(* ::Subsection::Closed:: *)
(*Make stop-codons ambiguous*)


(* ::Text:: *)
(*Some software (like IQTree, when using codon models) doesn't like when there are stop-codons in your alignment (probably because they want to make sure your sequences are actually protien coding. This function takes all codons and turns them into ambigious codons by replacing them with gaps ("---").*)
(**)
(*The input is:*)
(*	file - either an alignment file or a fastaParsed object containing an alignment that is IN READING FRAME and BEGINS WITH CODON POSITION 1.*)


removeStopCodons[file_String]:=fastaExport[file ,removeStopCodons[file//importAlignment]]


removeStopCodons[file_String,"Hold"]:=removeStopCodons[file//importAlignment]


removeStopCodons[file_List]:=Block[{align,stopPositions,sPos,stopLess},
stopPositions=((StringPosition[#, "*"]&/@translateAlignment[align=(file)][[All, 2]])/.{}->{{0},{ 0}})[[All, All, 1]]; (*this section will return a list of positions where it thinks a stop-codon is. Otherwise it returns a dummy vector {0, 0}*)
sPos=Partition[Riffle[stopPositions, align], 2];

stopLess=(If[#[[1]]=={0, 0},#[[2]], 
{#[[2, 1]], 
new=StringPartition[#[[2, 2]], 3];
complete=StringJoin[(new=ReplacePart[new, #->"---"])&/@#[[1]];
new]}]&/@sPos)
]


(* ::Subchapter::Closed:: *)
(*Calculating alignment stats*)


(* ::Subsection::Closed:: *)
(*Counting number of taxa in a certain group (e.g. outgroups)*)


(* ::Text:: *)
(*The function below counts the number of taxa in a specified list are present in a list of taxa.*)


(* ::Text:: *)
(*Parameters are:*)
(*fasta - is either a fastaParsed object or an alignment/sequence file.*)
(*listOfTaxa - is a list of strings EXACTLY matching the list of strings (e.g. taxon names) you want to count in the file.*)
(*headerPos - is the position in the fasta header you should look for the above list of strings.*)


countTaxa[fasta_List, listOfTaxa_, headerPos_]:=Block[{},
Intersection[listOfTaxa, fasta[[All, 1, headerPos]]   ]//Length
]


countTaxa[fasta_String, listOfTaxa_, headerPos_]:=Block[{align},

align=fasta//importAlignment;
{fasta,Intersection[listOfTaxa, align[[All, 1, headerPos]]   ]//Length}
]


(* ::Subsection::Closed:: *)
(*XXFinding and counting alignment regionsXX*)


(* ::Text:: *)
(*This function uses a Button[SquaredEuclideanDistance, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/SquaredEuclideanDistance"] function to split the alignment into clusters horizontally and counts how many regions it splits it into.*)


(* ::Text:: *)
(*NOTE: That this function gives results that are not representative of what it is supposed to measure. DONOT use this function as written now (18 Jan 2018).*)


(*SetDirectory["F:\\Dropbox\\Projects\\Phylogeny of Blaberoidea\\Alignments\\Ready to merge alignments Jan 2018"];
fn=Drop[FileNames[], 5];*)


(*clusters=findAlignmentClusters[#]&/@fn*)


(* ::Text:: *)
(*Input is:*)
(*either an alignment fileName or a fasta parsed list.*)


findAlignmentClusters[fileName_List]:=Block[{binarizeNucs,binarizeNucs2, binarizeNucs3,binaryMat,out },
binarizeNucs=Replace[#, {
"a"->1, "t"->1,"c"->1,"g"->1,
"A"->1, "T"->1,"C"->1,"G"->1, 
"-"->0,"n"->0,"N"->0,"?"->0
}]&/@StringPartition[#, 1]&/@(fileName//importAlignment)[[All, 2]];
(*this section should delete empty rows and columns*)
(binarizeNucs2=DeleteCases[If[(#//Total)>9, #, Null]&/@binarizeNucs, Null]);
binarizeNucs3=DeleteCases[If[(#//Total)>9, #, Null]&/@(binarizeNucs2//Transpose), Null]//Transpose;
(*this section sorts the sequences in the specified direction*)
(binaryMat=(Sort/@(binarizeNucs3//Transpose)))//MatrixForm;
out=Colorize/@FindClusters[(binaryMat)];
{fileName, out//Length}

]


findAlignmentClusters[fasta_List]:=Block[{binarizeNucs,binarizeNucs2, binarizeNucs3,binaryMat,out },
binarizeNucs=Replace[#, {
"a"->1, "t"->1,"c"->1,"g"->1,
"A"->1, "T"->1,"C"->1,"G"->1, 
"-"->0,"n"->0,"N"->0,"?"->0
}]&/@StringPartition[#, 1]&/@(fasta)[[All, 2]];
(*this section should delete empty rows and columns*)
(binarizeNucs2=DeleteCases[If[(#//Total)>9, #, Null]&/@binarizeNucs, Null]);
binarizeNucs3=DeleteCases[If[(#//Total)>9, #, Null]&/@(binarizeNucs2//Transpose), Null]//Transpose;
(*this section sorts the sequences in the specified direction*)
(binaryMat=(Sort/@(binarizeNucs3//Transpose)))//MatrixForm;
out=Colorize/@FindClusters[(binaryMat)];
{out//Length}

]


(* ::Subsection:: *)
(*XXXCalculating synonymous:non-synonymous mutationsXX*)


(* ::Subsection:: *)
(*Counting missing data*)


(* ::Subsubsection::Closed:: *)
(*For whole alignment*)


(* ::Text:: *)
(*These functions will calculate the total missing data for an alignment, the mean and StdDev of missing data per site. They can be calculated based on the total number of sequences in the alignment, or a specific number of sequences (if, for example, the alignment is missing taxa with no data). *)
(*Input:*)
(*	align - a nucleotide or amino acid alignment file name or fastaParsed object*)
(*	alignName - a string with the name of your alignment. Only used if passing a fastaParsed object.*)
(*	total - the total number of taxa in the alignment. If not specified, it will calculate this on its own. If specified, valid options are:*)
(*		"Count" - which will do the same as the default;*)
(*		An integer - which specifies how many total taxa you should consider as being the maximum. This is useful if you have deleted empty sequences from your alignment, but want to consider the total number of taxa from a greater set of sequences.*)
(*	dataType - either "nuc" or "aa"; this determines the set of characters considered  as missing data.*)
(*	*)
(*	Output is given in the order: *)
(*	"locus name ", "mean % of missing data per site ", "std dev of msising data per site ", "# of sites missing 100% of data ", "mean % of missing data per taxon ", "std. dev of missing data per taxon ", "# of taxa missing 100% of data".*)


(*(*EXAMPLE: *)missingDataCalculator[fn[[15]], 136, "nuc"];*)


missingDataCalculator[align_List, alignName_String, total_, dataType_String]:=Block[{positions, alignment,missingTaxa,numTaxa,posMiss,seqLength,taxMiss,missChars, taxa},
alignment=align;
missChars=Switch[dataType, 
"aa", {"-","?"},
"nuc", {"-","?","n", "N"}
];

positions=StringJoin/@((StringPartition[#, 1]&/@(taxa=alignment[[All, 2]]))//Transpose);

If[total=="Count",numTaxa=taxa//Length;, numTaxa=total;];
missingTaxa=numTaxa-(taxa//Length);

posMiss=((StringCount[#,missChars])&/@positions)+missingTaxa;

seqLength=StringLength[taxa[[1]]];
taxMiss=Append[(StringCount[#,missChars]&/@taxa),ConstantArray[seqLength,missingTaxa ] ]//Flatten;

{alignName,((posMiss//Mean)/numTaxa)//N, (posMiss)//StandardDeviation//N,Count[posMiss,numTaxa ] ,
 ((taxMiss//Mean)/seqLength)//N, taxMiss//StandardDeviation//N,Count[taxMiss,seqLength ] }
]
(*the results are given as follows:
{"locus name", "mean % of missing data per site", "std dev of msising data per site", "# of sites missing 100% of data", "mean % of missing data per taxon", "std. dev of missing data per taxon", "# of taxa missing 100% of data"}*)


missingDataCalculator[align_String, total_, dataType_String]:=missingDataCalculator[importAlignment[align],align, total, dataType]


(* ::Subsubsection::Closed:: *)
(*By taxon*)


(* ::Text:: *)
(*Function 1:*)


(* ::Text:: *)
(*This function calculates the total number of characters, and the % of total characters that are missing or ambiguous.*)
(**)
(*Input is:*)
(*	fasta - a fastaParsed list or a sequence file name.*)
(*	position -  the position in the header that contains the thing you're counting missing data for (i.e. the taxon name)*)
(*	dataType - a string specifying the type of data, which determines what characters are treated as missing. *)
(*		Options are: "nuc" or "aa".*)


taxMissingCharacters[fasta_, position_Integer, dataType_String]:=Block[{count,missChars},
missChars=Switch[dataType, 
"aa", {"-","?"},
"nuc", {"-","?","n", "N"}
];
Export["missingDataByTaxon_characters.csv",
Prepend[{#[[1, position]], count=StringCount[#[[2]], missChars],((count/StringLength[#[[2]]])*100)//N }&/@fasta, {"taxon", "# of ambiguous characters", "% of ambiguous characters"}]
]
]


taxMissingCharacters[fasta_String, position_Integer, dataType_String]:=taxMissingCharacters[fasta//importAlignment, position, dataType]


(* ::Text:: *)
(*Function 2:*)
(**)
(*This function takes a list of file names and counts the total and %  of times a taxon appears in the files with entirely missing data.*)
(*Input is:*)
(*fileNames - a list of strings specifying the file names for each alignment.*)
(*position -  the position in the header that contains the thing you're counting missing data for (i.e. the taxon name)*)
(*OPTIONAL: "Full" - specifying this option in the thrid position will output the list of all the loci for which the taxon has data.*)


taxMissingBlocks[fileNames_List,position_Integer]:=Block[{allNames,totalBlocks, tfList,count},
(*import the taxon names*)
Block[{},
allNames=((importAlignment[#][[All, 1, position]]&/@fileNames)//Union)[[1]]];

totalBlocks=Length[fileNames];

tfList=Flatten[{#[[1, position]],StringFreeQ[#[[2]], {"A","T","C","G","a","t","c","g"}]}&/@importAlignment[#]&/@fileNames, 1];
(*the output of the above will give a taxon name and FALSE if the sequence has data and TRUE if the sequence is all undetermined*)

Export["missingDataByTaxon_Blocks.csv",
Prepend[{#, count=Count[tfList, {#, True}], ((count/totalBlocks)*100)//N}&/@allNames, {"taxon", "# of blocks missing", "% of blocks missing"}]
]
]


taxMissingBlocks[fileNames_List,position_Integer, "Full"]:=Block[{allNames,totalBlocks, tfList,tfGList,count, out, missing},
(*import the taxon names*)
Block[{},
allNames=((importAlignment[#][[All, 1, position]]&/@fileNames)//Union)[[1]]];

totalBlocks=Length[fileNames];

tfList=Flatten[{#[[1, position]],StringFreeQ[#[[2]], {"A","T","C","G","a","t","c","g"}],fn }&/@importAlignment[fn=#]&/@fileNames, 1];
(*the output of the above will give a taxon name and FALSE if the sequence has data and TRUE if the sequence is all undetermined*)
tfGList=GatherBy[#, #[[2]]&]&/@(SortBy[#, #[[2]]&]&/@GatherBy[tfList, First]);
out=({(missing=#[[2]])[[1, 1]], count=Length[missing], ((count/totalBlocks)*100)//N, #[[1, All, 3]]//Union}//Flatten)&/@tfGList;

Export["missingDataByTaxon_Blocks_Full.csv",
Prepend[out, {"taxon", "# of blocks missing", "% of blocks missing", "present in loci"}]
]
]


(* ::Subsubsection::Closed:: *)
(*Missing taxa by alignments*)


(* ::Text:: *)
(*This function counts how many taxa in an alignment are composed of entirely missing data.*)


(* ::Text:: *)
(*This function takes a list of sequence files and outputs a .csv table with the results.*)
(*Input is:*)
(*alignmentFiles - a list of file names*)
(*tname - an integer, giving the position in the sequence header with the taxon name. Default is 1 if not specified*)


missingTaxonCalculator[alignmentFiles_]:=missingTaxonCalculator[alignmentFiles, 1]


missingTaxonCalculator[alignmentFiles_, tname_Integer]:=Block[{},
Export["missingTaxa_byAlignment.csv",
Prepend[missTaxonCalc[#, tname]&/@alignmentFiles, {"locus name", "tot. tax. missing", "% tax missing", "present taxa"}]
]

]


(* ::Text:: *)
(*Dependancy function takes a single sequence and gives missing data stats for it.*)
(*  Input is :*)
(*  fileName - a file name or fastaParsed Object*)
(*  tname - an integer, giving the position in the sequence header with the taxon name. Default is 1 if not specified.*)
(*  If fileName is a fastaParsed Object you must also specify the position of the locus name in the sequence header.*)


missTaxonCalc[fileName_String]:=missTaxonCalc[fileName, 1]


missTaxonCalc[fileName_String, tName_Integer]:=Block[{ali,position,tfList,tfgLIst,totalPresent, totalMissing, taxaPresent},

ali=importAlignment[fileName];
position=tName;

tfList=SortBy[{#[[1, 1]],StringFreeQ[#[[2]], {"A","T","C","G","a","t","c","g"}]}&/@ali, #[[2]]&];
tfgLIst=GatherBy[tfList, #[[2]]&];

totalPresent=tfgLIst[[1]]//Length;
{fileName, totalMissing=tfgLIst[[2]]//Length,((totalMissing/(totalPresent+totalMissing))*100)//N, taxaPresent=tfgLIst[[1, All, 1]]}//Flatten

]


missTaxonCalc[fastaParsed_List, lName_Integer, tName_Integer]:=Block[{ali,position,tfList,tfgLIst,totalPresent, totalMissing, taxaPresent},

ali=fastaParsed;
position=tName;

tfList=SortBy[{#[[1, 1]],StringFreeQ[#[[2]], {"A","T","C","G","a","t","c","g"}]}&/@ali, #[[2]]&];
tfgLIst=GatherBy[tfList, #[[2]]&];

totalPresent=tfgLIst[[1]]//Length;
{lName, totalMissing=tfgLIst[[2]]//Length,((totalMissing/(totalPresent+totalMissing))*100)//N, taxaPresent=tfgLIst[[1, All, 1]]}//Flatten

]


(* ::Subsection:: *)
(*Nucleotide compositional bias*)


(* ::Subsubsection::Closed:: *)
(*Total*)


(* ::Text:: *)
(*The function below calculates the prevalence (%) of each nucleotide among all positions with a determined base (doesn't count missing data). It also gives the standard deviation of the percentages, which is a measure of compositional bias.*)
(*Input is:*)
(*	fileName - a string with the name of the file you want to import. It doesn't have to be aligned and could be in phylip or fasta format. Alternatively, a fastaParsed object, in which case you also need to define "name", which is a string giving the name of the set of sequences.*)
(*	nucs - an optional input consisting of a list of character strings you want to treat as the nucleotides to be counted. Default is: {"A","T","C","G"}*)


compositionalBiasTotal[fastaParsed_List, name_String,nucs_List]:=
Block[{nucFreqs, nucProportions, nucDev, align},
align=(fastaParsed)[[All, 2]];
nucFreqs=Total/@((Table[StringCount[#//ToUpperCase, nucs[[n]]], {n, 1, 4}]&/@align)//Transpose);(*given in the order ATCG*)
nucProportions=(((#*100)/(nucFreqs//Total))//N)&/@nucFreqs;
nucDev=nucProportions//StandardDeviation;
{name,nucProportions, nucDev }//Flatten
]


compositionalBiasTotal[fastaParsed_List, name_String]:=compositionalBiasTotal[fastaParsed, name,{"A","T","C","G"}]


compositionalBiasTotal[fastaParsed_String,nucs_List]:=compositionalBiasTotal[importAlignment[fastaParsed], fastaParsed,nucs]


compositionalBiasTotal[fastaParsed_String]:=compositionalBiasTotal[importAlignment[fastaParsed], fastaParsed,{"A","T","C","G"}]


(* ::Subsubsection::Closed:: *)
(*By codon position*)


(* ::Text:: *)
(*The function below calculates the prevalence (%) of each nucleotide among all positions with a determined base (doesn' t count missing data).It also gives the standard deviation of the percentages, which is a measure of compositional bias.*)
(**)
(*Input is : *)
(*fileName - a string with the name of the alignment file you want to import.It can be in phylip or fasta format.*)


compositionalBiasCodons[input_List, name_String]:=Block[{nucFreqs, nucProportions, nucDev, align, codonAligns},
(*first, break up the alignment by codon position*)
codonAligns=(makeCodonFASTAParsedObjects[input, #][[All, 2]]&/@{{1},{2},{3}});

(*now just cound the nucleotides in each*)
cBias=Table[align=codonAligns[[c]];
nucFreqs=Total/@((Table[StringCount[#//ToUpperCase, nucs[[n]]], {n, 1, 4}]&/@align)//Transpose);(*given in the order ATCG*)
nucProportions=(((#*100)/(nucFreqs//Total))//N)&/@nucFreqs;
nucDev=nucProportions//StandardDeviation;
{nucProportions, nucDev}//Flatten, {c, 1, 3}];
{name,cBias }//Flatten
]


compositionalBiasCodons[input_String]:=compositionalBiasCodons[input//importAlignment, input]


(* ::Text:: *)
(*Dependency script which is modified from the finding codons section.*)


makeCodonFASTAParsedObjects[alignmentFile_String, position_]:=Block[{aaa},
codonExtract[aaa=alignmentFile//importAlignment,position, 
((readingFrame/@aaa[[All, 2]])//Commonest)[[1]]+1 ]
]


makeCodonFASTAParsedObjects[alignmentFile_List, position_]:=Block[{aaa},
codonExtract[aaa=alignmentFile,position, 
((readingFrame/@aaa[[All, 2]])//Commonest)[[1]]+1 ]
]


(* ::Subsubsection::Closed:: *)
(*Total (RCFV method)*)


(* ::Text:: *)
(*One accepted, but simplistic, method of determining base compositional heterogeneity is to calculate "Relative Composition of Frequency Variability" (RCFV). This method is detailed in Zhong, M., Hansen, B., Nesnidal, M., Golombek, A., Halanych, K. M., and Struck, T. H. (2011). Detecting the symplesiomorphy trap: a multigene phylogenetic analysis of terebelliform annelids. BMC Evolutionary Biology, 11(1):369. and the equation for it is: *)
(**)


(* ::Text:: *)
(*\!\( *)
(*\*UnderoverscriptBox[\(\[Sum]\), \(i = 1\), \(m\)]\( *)
(*\*UnderoverscriptBox[\(\[Sum]\), \(j = 1\), \(n\)]*)
(*\*FractionBox[\(Abs[*)
(*\*SubscriptBox[\(A\), \(ij\)] - *)
(*\*SubscriptBox[\(A\), \(i\)]]\), \(n\)]\)\);*)


(* ::Text:: *)
(*Where:*)
(*m is the number of character states (4 for nucleotide data), *)
(*Subscript[A, ij] is the frequency of character i in taxon j*)
(*Subscript[A, i] is the frequency of character i in all taxa*)
(*n is the number of taxa.*)
(**)
(*In the above, frequency is expressed as the total number of occurances divided by the total number of opportunities. *)
(*Simply calculate this by putting your alignment (fastaParsed or file name) into this function.*)


rCFV[alignment_String]:=rCFV[alignment//importAlignment]


rCFV[alignment_List]:=Block[{ali, n, aliFull,AA,AC,AT,AG, alignLength},
ali=DeleteCases[If[(StringReplace[#, {"-"->"", "?"->"", "N"->"", "n"->""}]//StringLength)==0, "", #]&/@alignment [[All, 2]], ""];
(*above: the extra bit of code is there to delete empty sequences. Note that to alter this for amino-acid alignments I need to get rid of the N's*)
n=ali//Length; (*this is the new number of taxa after the empty sequences are deleted.*)
aliFull=(StringReplace[#, {"-"->"", "?"->"", "N"->"", "n"->""}]//ToUpperCase)&/@ali;

AA=StringCount[ aliFull//StringJoin, "A"]/StringLength[aliFull//StringJoin];
AC=StringCount[ aliFull//StringJoin, "C"]/StringLength[aliFull//StringJoin];
AT=StringCount[ aliFull//StringJoin, "T"]/StringLength[aliFull//StringJoin];
AG=StringCount[ aliFull//StringJoin, "G"]/StringLength[aliFull//StringJoin];

alignLength=Max[StringLength/@ali];

Total[Total[Table[
(Abs[
(StringCount[aliFull[[i]]//ToUpperCase, #[[1]] ]/StringLength[aliFull[[i]]])-#[[2]]
]/n)
,{i, 1, Length[aliFull]}]]&/@{{"A", AA}, {"C", AC}, {"T", AT}, {"G", AG}}]//N
](*this function was revised, and fixed on feb 5 2018. prior to this, the frequencies were calculated incorrectly and the values were correlated with locus length.*)


(* ::Subsubsection::Closed:: *)
(*By codon position (RCFV method)*)


(* ::Text:: *)
(*See above section for description of the method.*)


rCFVCodons[alignment_String]:=rCFVCodons[alignment//importAlignment]


rCFVCodons[alignment_List]:=Block[{aliC1, aliC3, aliC2, alis, codonAligns},
codonAligns=(makeCodonFASTAParsedObjects[alignment, #][[All, 2]]&/@{{1},{2},{3}});

aliC1=DeleteCases[If[(StringReplace[#, {"-"->"", "?"->"", "N"->"", "n"->""}]//StringLength)==0, "", #]&/@(codonAligns[[1]]), ""];
aliC2=DeleteCases[If[(StringReplace[#, {"-"->"", "?"->"", "N"->"", "n"->""}]//StringLength)==0, "", #]&/@(codonAligns[[2]]), ""];
aliC3=DeleteCases[If[(StringReplace[#, {"-"->"", "?"->"", "N"->"", "n"->""}]//StringLength)==0, "", #]&/@(codonAligns[[3]]), ""];

(*above: the extra bit of code is there to delete empty sequences. Note that to alter this for amino-acid alignments I need to get rid of the N's*)
alis={aliC1, aliC2, aliC3};

Block[{ali, n, aliFull,AA,AC,AT,AG},
ali=#;
n=ali//Length;
aliFull=(StringReplace[#, {"-"->"", "?"->"", "N"->"", "n"->""}]//ToUpperCase)&/@ali;


AA=StringCount[ aliFull//StringJoin, "A"]/StringLength[aliFull//StringJoin];
AC=StringCount[ aliFull//StringJoin, "C"]/StringLength[aliFull//StringJoin];
AT=StringCount[ aliFull//StringJoin, "T"]/StringLength[aliFull//StringJoin];
AG=StringCount[ aliFull//StringJoin, "G"]/StringLength[aliFull//StringJoin];

alignLength=Max[StringLength/@ali];

Total[Total[Table[
(Abs[
(StringCount[aliFull[[i]]//ToUpperCase, #[[1]] ]/StringLength[aliFull[[i]]])-#[[2]]
]/n)
,{i, 1, Length[aliFull]}]]&/@{{"A", AA}, {"C", AC}, {"T", AT}, {"G", AG}}]//N
]&/@alis

]


(* ::Text:: *)
(*This function will export a spreadsheet with all the output from the above function*)


RCFVCodonsexport[alignments_List]:=Export["RCFV_comp_bias_codons.xlsx", Flatten[{#, rCFVCodons[#]}]&/@alignments]


(* ::Chapter::Closed:: *)
(*Tree file functions*)


(* ::Subchapter::Closed:: *)
(*Importing a tree*)


(* ::Text:: *)
(*Currently, there is no use for this function since there are no functions that handle trees. But, if I was going to make such a function, the below function might be useful. It takes a simple newick tree file as input. It may or may not work with trees with branch lengths.*)


importTree[treePath_]:=Block[{treeNwk},
treeNwk=Import[treePath, "String"];
StringReplace[

StringDrop[StringTrim[StringReplace[treeNwk, 
{"):"->"},",
"("->"{",
")"->"}"
}]], -1]

,x:Except["{"|","|"}"]..:>"\""<>x<>"\""]//ToExpression

]


(* ::Subchapter::Closed:: *)
(*Combining tree files*)


(* ::Text:: *)
(*This function combines multiple newick tree files into a single file. The files must all be in the current working directory. *)
(*	*)
(*Parameters:*)
(*	fileName - a string representing the name you would like the resulting combined file to be called.*)
(*	treeList - a list of string representing tree files you want to combine that are in the current working directory.*)


combineTrees[fileName_, treeList_]:=Block[{},


Export[fileName<>".trees",StringJoin[Riffle[Import[#, "Text"]&/@treeList, "
"]]//StringTrim, "Text"]


]


(* ::Subchapter::Closed:: *)
(*Taxon name operations*)


(* ::Subsection::Closed:: *)
(*Swapping taxon names*)


(* ::Text:: *)
(*This function takes a tree file (should work with any format, even an alignment, actually) and swaps the names with a predefined list of names.*)
(**)
(*Input is:*)
(*	input - the name of a file (only tested with RAXML outputted tree files)*)
(*	nameSwapList - the name of a .CSV file with two columns of names. The first column is the list of names in the input file, the second column is the list of names to swap them with.*)


nameSwap[input_String, nameSwapList_String]:=Block[{namesToSwap},

namesToSwap=Import[nameSwapList][[All, {1, 2}]];

Export["nameFixed_"<>input, StringReplace[Import[input, "String"], Table[
namesToSwap[[i, 1]]->namesToSwap[[i, 2]]
,{i, 1, Length[namesToSwap]}]], "Text"]]


nameSwap[input_List, nameSwapList_String]:=nameSwap[#, nameSwapList]&/@input


(* ::Subsection::Closed:: *)
(*Extracting taxon names*)


(* ::Text:: *)
(*This function takes a tree and returns a list of the file names.*)
(**)
(*	The input is:*)
(*		tree - either an imported tree string, or just a tree file name*)
(*		option - can be either "String" if the tree is already imported or "File" if the tree is not yet imported. Default is "File".*)
(*		*)
(*Note: If the following characters are in the taxon names the script will fail: ][)(,:;*)
(**)


extractNamesFromTree[treeString_, "String"]:=Block[{elements},

elements=DeleteCases[StringSplit[StringTrim[treeString], {"]","[",")","(",",",":",";"}]//Sort, ""];
DeleteCases[If[NumberQ[#//ToExpression], Null, #]&/@elements, Null]

]


extractNamesFromTree[treeFile_, "File"]:=Block[{elements,treeString},
treeString=Import[treeFile, "String"];
elements=DeleteCases[StringSplit[StringTrim[treeString], {")", "(", ",", ":", ";"}]//Sort, ""];
DeleteCases[If[NumberQ[#//ToExpression], Null, #]&/@elements, Null]
]


extractNamesFromTree[treeFile_]:=extractNamesFromTree[treeFile, "File"]


extractNamesFromTree[treeFiles_List]:={#,extractNamesFromTree[#]}&/@treeFiles


(* ::Subchapter::Closed:: *)
(*Tree stats*)


(* ::Subsection:: *)
(*Bootstrap statistics*)


(* ::Subsubsection::Closed:: *)
(*From Sumtrees*)


(* ::Text:: *)
(*The function below takes a tree output by the software SumTrees and gives a summary of the bootstrap scores in the tree. It does this AFTER deleting the "100" support frequencies from the tips (i.e. each lone tip taxon is automaticall given 100% support by SumTrees).*)
(**)
(*Input is: *)
(*treeName - a string with the name of your sumTrees output tree.*)


bootstrapsSummary[treeName_String(*, method_String*)]:=Block[{(*bootTreeChim, *) supportValues, numTaxa, tree,allSupports},
(*Switch[method,
"Default",
bootTreeChim=StringSplit[Import[treeName, "String"], {"TREE 1 = [&U]", ";"}];
supportValues=ToExpression[StringSplit[#, "support="]]&/@Partition[StringSplit[bootTreeChim[[7]], {"[&", "][&length"}], 2][[All, 2]];
numTaxa=ToExpression[StringSplit[bootTreeChim[[2]], "="][[2]]];
supportValues=Drop[supportValues//Sort, -numTaxa];,
"Sumtrees",
allSupports=ToExpression[#]&/@(StringSplit[#, ","][[1]]&/@Drop[StringSplit[(tree=Import[treeName, "String"]), "support="], 1]);
numTaxa=ToExpression[StringSplit[Drop[StringSplit[tree, "ntax="], 1], ";"][[1, 1]]];
supportValues=Drop[allSupports//Sort, -numTaxa];
];*)
allSupports=ToExpression[#]&/@(StringSplit[#, {",","]"}][[1]]&/@Drop[StringSplit[Import[treeName, "String"], "support="], 1]);
numTaxa=ToExpression[StringSplit[Drop[StringSplit[tree, "ntax="], 1], ";"][[1, 1]]];
supportValues=Drop[allSupports//Sort, -numTaxa];

{
{"Mean Boostrap value",supportValues//Mean},
{"Median Boostrap value",supportValues//Median},
{"Std.Dev. Boostrap values",supportValues//StandardDeviation}, 
{"Distributution without 100% support",Histogram[DeleteCases[supportValues//Flatten, 100.]]},
{"Complete distribution",Histogram[supportValues//Flatten]}
}//TableForm
]


(* ::Text:: *)
(*The function below is the same as above, but it outputs the results as a table and takes a list of multiple trees as input.*)


bootstrapsSummary[treeFiles_List]:=Block[{},
Export["bootstrapsSummaryAll.csv",
Prepend[({#, bootstrapsSummary[#][[1, {1, 2, 3}, 2]]}//Flatten)&/@treeFiles, {"tree name","Mean bootstrap","Median Bootstrap","Std. Dev. of all bootstraps"}]
]
]


(* ::Subsubsection::Closed:: *)
(*From IQTREE*)


(* ::Text:: *)
(*The function below takes a tree output by the software IQTREE and gives a summary of the bootstrap scores in the tree.*)
(**)
(*Input is: *)
(*treeName - a string with the name of your IQTree output tree.*)


bootstrapsSummary[treeName_String, "IQTree"]:=Block[{bootTreeChim,supportValues, t},
bootTreeChim=Import[treeName, "String"];
supportValues=ToExpression/@Drop[DeleteCases[If[StringContainsQ[#, ")"], (t=StringSplit[#, ")"])[[Length[t] ]],Null;]&/@StringSplit[bootTreeChim, ":"], Null], -1];
{
{"Mean Boostrap value",supportValues//Mean//N},
{"Median Boostrap value",supportValues//Median//N},
{"Std.Dev. Boostrap values",supportValues//StandardDeviation//N}, 
{"Distributution without 100% support",Histogram[DeleteCases[supportValues//Flatten, 100]]},
{"Complete distribution",Histogram[supportValues//Flatten]}
}//TableForm
]


(* ::Text:: *)
(*The function below is the same as above, but it outputs the results as a table and takes a list of multiple trees as input.*)


bootstrapsSummaryAll[treeFiles_List, "IQTree"]:=Block[{},

Export["bootstrapsSummaryAll.csv",
Prepend[({#, bootstrapsSummary[#, "IQTree"][[1, {1, 2, 3}, 2]]}//Flatten)&/@treeFiles, {"tree name","Mean bootstrap","Median Bootstrap","Std. Dev. of all bootstraps"}]
]
]


(* ::Subchapter::Closed:: *)
(*Making Navajo rug plots for node support*)


(* ::Text:: *)
(*This function will output ravajo rug plots which you can then put into an illustrator program on a tree to show node support. *)
(**)
(*Input is:*)
(*	matrix - an table of values for node support between -1 and 1 with node names in the first column. Normally, values between 0 and 1 are sufficient, but if you calculate internode certainty then you might have negatuve values. NOTE that if your matrix contains negative values, you should round all the numbers to the nearest tenth.*)
(*	rows - an integer representing the number of rows you want to plot. The number of columns your data has, must be evenly divisible by this number.*)
(*	colorFunction - a mathematica colorfunction. If you don't specify, it will default to a predefined function. (see guide/ColorSchemes)*)
(*	*)
(*Output is:*)
(*	A list of nodes with navajo rugs for each.*)
(*	A color legend.*)
(**)
(*NOTE that the color legend starts at -1, even if none of your values are negative. The negative values are specifically defined to be in grayscale, with lighter values closer to zero.*)


navajoRug[matrix_, rows_Integer, colorFunction_]:=Block[{colorR, rug},
{
({#[[1]], ArrayPlot[
rug=Partition[Drop[#, 1], (Drop[#, 1]//Length)/rows

]
,Frame->False
,DataRange->{{-1, 1}, {0, 1}}
, ColorRules->(colorR={"NA"->CMYKColor[0, 1, 0, 0], Table[x->GrayLevel[1-Abs[x]], {x, -1, 0, .001}]}//Flatten)
(*, ColorFunction\[Rule]"TemperatureMap"*)
,ColorFunction->colorFunction
,ColorFunctionScaling->False
,AspectRatio->Length[rug]/Length[rug[[1]]]
, ImageSize->Tiny]}&/@matrix)//TableForm
,
{"Legend scale",
ArrayPlot[
{Prepend[Range[-1, 1, .001], "NA"]//Flatten}
,Frame->False
,DataRange->{{-1, 1}, {0, 1}}
, ColorRules->colorR
(*, ColorFunction\[Rule]"TemperatureMap"*)
,ColorFunction->colorFunction
,ColorFunctionScaling->False
, ImageSize->Tiny]}}
]


(colorR={"NA"->CMYKColor[0, 1, 0, 0], Table[x->GrayLevel[1-Abs[x]], {x, -1, 0, .001}]}//Flatten);
(*, ColorFunction\[Rule]"TemperatureMap"*)


navajoRug[matrix_, row_]:=navajoRug[matrix, row,
colorFunction=(*Function[{z},Hue[z*.4-.2]];*)ColorData[{"LightTemperatureMap", "Reverse"}]]


(* ::Text:: *)
(*This function will output a single rowed ravajo plots which you can then put into an illustrator program on a tree to show node support. *)
(**)
(*Input is:*)
(*	matrix - an table of values for node support between -1 and 1 with node names in the first column. Normally, values between 0 and 1 are sufficient, but if you calculate internode certainty then you might have negatuve values. NOTE that if your matrix contains negative values, you should round all the numbers to the nearest tenth.*)
(*	colorFunction - a mathematica colorfunction. If you don't specify, it will default to a predefined function. (see guide/ColorSchemes)*)
(*	*)
(*Output is:*)
(*	A list of nodes with navajo rugs for each.*)
(*	A color legend.*)
(**)
(*NOTE that the color legend starts at -1, even if none of your values are negative. The negative values are specifically defined to be in grayscale, with lighter values closer to zero.*)


navajoRow[matrix_, colorFunction_]:=Block[{colorR},
{
({#[[1]], ArrayPlot[
{Drop[#, 1]}
,Frame->False
,DataRange->{{-1, 1}, {0, 1}}
, ColorRules->(colorR={"NA"->CMYKColor[0, 1, 0, 0], Table[(x//N)->GrayLevel[1-Abs[x]], {x, -1, 0, .001}]}//Flatten)
(*, ColorFunction\[Rule]"TemperatureMap"*)
,ColorFunction->colorFunction
,ColorFunctionScaling->True
]}&/@matrix)//TableForm
,
{"Legend scale",
ArrayPlot[
{Prepend[Range[-1, 1, .1], "NA"]//Flatten}
,Frame->False
,DataRange->{{-1, 1}, {0, 1}}
, ColorRules->colorR
(*, ColorFunction\[Rule]"TemperatureMap"*)
,ColorFunction->colorFunction
,ColorFunctionScaling->True
, ImageSize->Tiny]}}


]


(colorR={"NA"->CMYKColor[0, 1, 0, 0], Table[(x//N)->GrayLevel[1-Abs[x]], {x, -1, 0, .001}]}//Flatten);



navajoRow[matrix_]:=navajoRow[matrix,
colorFunction=(*Function[{z},Hue[z*.4-.2]];*)ColorData[{"LightTemperatureMap", "Reverse"}]]


(* ::Subchapter::Closed:: *)
(*A RADICAL-like function*)


(* ::Text:: *)
(*The software RADICAL (https://www.ncbi.nlm.nih.gov/pubmed/22094860) performs phylogenetic analysis on an alignment that is increasing in size by randomly sampling a selected set of loci. It does this by making successive trees on the increasing alignment. In the end, the goal is to compare all trees to each other, or to a baseline tree. By remwriting the software I can tailor it to my needs. This provides the added benefit of using IQTREE instead of RAXML, because IQTREE is faster and with some more useful options. Additionally, this version does non-random alignment composition in the beginning of the selection process that is necessary because of high proportions of missing data in the alignments. In the end, we will have a set of outputs, but a summary file that can be plotted to show the convergence of the trees from the random concatenation to the baseline trees over time.*)


(* ::Text:: *)
(*The tree comparisons can be done two ways: 1. by the Robinson-Fould's metric, 2. Consensus Fork Index, 3. Mean bootstrap of a summary tree. Since IQTree can calculate 1, it is the simplest option. IQTree+Biosystematica can calculate 3. The function currently only uses 1 but I can easily update it to do 3 or potentially 2. *)


(* ::Text:: *)
(*The constituent functions are in the "subfunctions" section below. But most of them take mostly the same input. The input for the highest level section is as follows:*)
(**)
(*	lociDirectory - a string giving the full directory of the location of the loci to be concatenated. Each locus should be in an individual fasta or phylip alignment file.*)
(*	workingDir - a string giving the full directory of the location where the output folders will be put. Before starting, this folder must contain the iqtree executable and any other files required for iqtree, as well as the baseline tree against which to compare your calculated trees. If you want to compare the calculated trees to each other, there is another end-processing function (computeRFAlltoALL) to handle that.*)
(*	startingSize - an integer representing how many loci you want to have in the initial alignment. As currently written, this value cannot be lower than 6. Default is 15. *)
(*	stepSize - an integer representing how many loci are added upon each concatenation. Default is 5.*)
(*	baselineTree - a string with the exact file name of the baseline tree in your working directory. This will be compared against all other calculated trees to generate the Radical curve.*)
(*	outGroup - the exact taxon name of the outgroup. so that all the trees are easily read in the same way*)
(*	noOfReplicates - the maximum number of times you want to randomly sample all of the loci. Default, 100.*)
(*	checkLength - an integer telling the script how often (in replicates) to check for convergence. Default, 20.*)


radicalRun[lociDirectory_, workingDir_,startingSize_, stepSize_, baselineTree_, outGroup_, noOfReplicates_Integer, checkLength_Integer ];


radicalRun[workingDir_, baselineTree_, outGroup_ ]:=radicalRun[workingDir, workingDir,15, 5, baselineTree, outGroup, 100, 20 ]


(* ::Subsubsection::Closed:: *)
(*Example code*)


(* ::Text:: *)
(*the function below combines the other functions below and runs an entire stage of radical*)


(*radicalRun["F:\\Dropbox\\Projects\\Phylogeny of Blaberoidea\\Alignments\\Ready to merge alignments Jan 2018\\treatments\\test",
workingDir="F:\\Dropbox\\Projects\\Phylogeny of Blaberoidea\\Alignments\\Ready to merge alignments Jan 2018\\treatments\\Working_folder",
20(*startingSize*),
5 (*stepSize*),
"baseline_comb.nobl.tre" (*baselineTree*),
outgroup="Dermaptera_Diplatys_sp" (*outgroup*), 3, 2
]
SetDirectory["F:\\Dropbox\\Projects\\Phylogeny of Blaberoidea\\Alignments\\Ready to merge alignments Jan 2018\\treatments\\Working_folder"];*)


(* ::Subsection:: *)
(*Composing the program*)


(* ::Subsubsection::Closed:: *)
(*Mac version*)


radicalRunMac[lociDirectory_, workingDir_,startingSize_, stepSize_, baselineTree_, outGroup_, noOfReplicates_Integer,checkLength_Integer, restartAt_]:=radicalRun[lociDirectory, workingDir,startingSize, stepSize, baselineTree, outGroup, noOfReplicates,checkLength, 1]


(*aka radical resume*)
radicalRunMac[lociDirectory_, workingDir_,startingSize_, stepSize_, baselineTree_, outGroup_, noOfReplicates_Integer,checkLength_Integer, restartAt_]:=Block[{startTime, remainingHours, stopq},

Table[
startTime=AbsoluteTime[];
runASingleRadicalStageMac[lociDirectory, workingDir,startingSize, stepSize, stage, baselineTree, outGroup];

Print["The last replicate took "<>ToString[AbsoluteTime[]-startTime]<>" seconds. Multiplied by the total number of replicates your radical run will take "<>ToString[remainingHours=((((AbsoluteTime[]-startTime)/60)/60)*(noOfReplicates-stage))]<>" more hours. We expect radical to finish at "<>DateString[Date[]+{0, 0, 0, remainingHours//IntegerPart, (remainingHours//FractionalPart)*60, 0}]<>"."];

(*EmitSound[Sound[SoundNote["CSharp", 2,"ElectricGuitar"]]];*)

If[Divisible[stage, checkLength], Print["Reached checkpoint...assessing convergence"];If[(stopq=doWeStop[allRFs,noOfReplicates, checkLength ])<= stage, 
Print["Convergence reached, finishing up."];Goto["finishUp"];, Null;Print["Convergence not yet reached. Continuing for approximately " <>ToString[stopq]<>" total replicates"]];
, Null;];
stagesTOT=noOfReplicates;
,{stage, restartAt, noOfReplicates}];
Label["finishUp"];
(*make the ALLRFs list again, because it might not work from the above*)
SetDirectory["rf_intermediateOut"];
allRFs={};
Table[
allRFs=Append[allRFs,readRFSingle[ToString[i]<>"."<>ToString[j]<>"."<>"baseline_comb.nobl.tre"<>".rfdist", ToString[i]<>"."<>ToString[j]]], 
{i, 1,stagesTOT }, {j, 1, itersTOT}
];

radicalResultsMaker[allRFs, startingSize, stepSize];
Print["Radical has concluded. This is a good thing. You are a cool person."];
Speak["Program concluded. Good job."];
]


runASingleRadicalStageMAC[lociDirectory_, workingDir_,startingSize_, stepSize_, stage_, baselineTree_, outGroup_]:=Module[{numOfLoci, numIters, sri},

errorStatus="noError";

(*checks that all loci will be sampled*)
SetDirectory[lociDirectory];
numOfLoci=Length[FileNames[]];
If[IntegerQ[numIters=(numOfLoci-startingSize)/stepSize], Print["CHECK: All loci will be sampled. ... proceeding"];, Print["CHECK: ERROR. Not all loci will be sampled. Make sure the # of loci - starting size is divisible by stepsize. ... quitting"]; Goto["forceOut"];]


SetDirectory[workingDir];


(*create necessary output folders. move this one level up when i make the loop*)
CreateDirectory["alignments_All"];
CreateDirectory["iq_intermediateOut"]//Quiet;
CreateDirectory["rf_intermediateOut"]//Quiet;
CreateDirectory["trees_All"]//Quiet;
CreateDirectory["samplingInfo"]//Quiet;

(*instantiates some lists*)
allRFs={};
iterationStatus="First";

(*make the first alignment from the three most complete alignments and a certian number of other random loci*)
makeFirstAlignment[lociDirectory, workingDir<>"\\alignments_All", startingSize, stage];
If[errorStatus=="kill", Goto["forceOut"];, Print["first alignment successful. ... proceeding"]];

CopyFile[workingDir<>"\\alignments_All\\"<>ToString[stage]<>"."<>ToString[1]<>".fas", workingDir<>"\\"<>ToString[stage]<>"."<>ToString[1]<>".fas"]; (*makes a temporary copy of the file*)

(*makes an alignment and runs the first iteration of radical on it. at this point, even if the stop criteria are met it will do at least one more iteration*)
SetDirectory[workingDir];
iqTREEMac[ToString[stage]<>"."<>ToString[1]<>".fas", outGroup,ToString[stage]<>"."<>ToString[1]]; (*previously, this section had the singleRadicalIteration function*)

If[errorStatus=="kill", Goto["forceOut"];, Print["first iteration successful. ... proceeding"]];
(*Print[Directory[]<>ToString[" should be the working directory"]];*)(*this was just here to make sure the direcotyr was right. it doesn't need to be uncommented unless you shange the above code and are unsure.*)
DeleteFile[workingDir<>"\\"<>ToString[stage]<>"."<>ToString[1]<>".fas"];
(*deletes the temporary copy of the alignment*)
iterationStatus="Subsequent";

Table[
Print[iteration];
(*this loop will keep going until the stop criteria is met OR all the loci are sampled.*)
makeNextAlignments[lociDirectory, workingDir<>"\\alignments_All", stepSize, stage, iteration];

CopyFile[workingDir<>"\\alignments_All\\"<>ToString[stage]<>"."<>ToString[iteration]<>".fas", workingDir<>"\\"<>ToString[stage]<>"."<>ToString[iteration]<>".fas"]; (*makes a temporary copy of the file*)

If[errorStatus=="kill",Print["previous alignment file name is misspecified"]; Goto["forceOut"];,Null;];

SetDirectory[workingDir];
iqTREEMac[ToString[stage]<>"."<>ToString[iteration]<>".fas", outGroup,ToString[stage]<>"."<>ToString[iteration]]; (*previously, this section had the singleRadicalIteration function*)
If[errorStatus=="kill",Print["IQTree exited without evaluating... ending radical."]; Goto["forceOut"];,Null;];
If[sri, Print["Stop criterion met"];Goto["forceOut"], Null;];
DeleteFile[ workingDir<>"\\"<>ToString[stage]<>"."<>ToString[iteration]<>".fas"];(*deletes the temporary copy of the alignment*)
itersTOT=iteration;
, {iteration, 2,((numOfLoci-startingSize)/stepSize)+1 }];

Print["All trees in this stage done, calculating tree comparison metrics.."];
(*EmitSound[Sound[Sound[SoundNote["FFlat",.5,"Violin"]]]];*)
(*now calculcate Robinson-Foulds distances*)
CopyFile[workingDir<>"\\"<>baselineTree, workingDir<>"\\trees_All\\"<>baselineTree];
computeRFAll[baselineTree, workingDir<>"\\trees_All", stage, ((numOfLoci-startingSize)/stepSize)+1];
Export[workingDir<>"\\samplingInfo\\"<>ToString[stage]<>".csv", sampledLoci];

Label["forceOut"];
(*EmitSound[Sound[Sound[SoundNote["A",1,"Violin"]]]];*)
Print["Stage "<>ToString[stage]<>" completed."];
SetDirectory[ParentDirectory[]];
]


iqTREEMac[inputAlign_String, outGroup_String, iteration_String]:=Block[{},
(*run the tree. note that TREECOMMANDS go here*) 
(*the switch tells the script how to run IQTREE, either from an NJ starting tree, or using the tree from the previous run as the initial tree.*)
Switch[iterationStatus,
"First",
(*makes a tree starting from a BIONJ tree*)

Module[{startTime},

Print["iqtree -s "<>inputAlign<>" -m GTR+G -fast -nt 2 -st DNA -t BIONJ -ntop 10 -pre "<>iteration];
Print["tree started at "<>(startTime=DateString[])];
Run["iqtree -s "<>inputAlign<>" -m GTR+G -fast -nt 2 -st DNA -t BIONJ -ntop 10 -pre "<>iteration]; 
Print["...tree took "<>ToString[AbsoluteTime[DateString[]]-AbsoluteTime[startTime]]<>" seconds."];
];
,

"Subsequent",

Module[{text, startTime},
Print["tree started at "<>(startTime=DateString[])];Run[text=("iqtree -s "<>inputAlign<>" -m GTR+G -fast -nt 2 -st DNA -t initiate.treefile -ntop 10 -mem 3G -o "<>outGroup<>" -pre "<>iteration)];
Print[text];
Print["...tree took "<>ToString[AbsoluteTime[DateString[]]-AbsoluteTime[startTime]]<>" seconds."];
];


DeleteFile["initiate.treefile"];
];
CopyFile[iteration<>".treefile", "trees_All\\"<>iteration<>".treefile"];
CopyFile[iteration<>".treefile", "initiate.treefile"]; (*makes a new file that can later be used as a starting tree*)
DeleteFile[iteration<>".treefile"];
If[FileExistsQ[iteration<>".log"], Null;, errorStatus="kill"];
CopyFile[iteration<>".bionj", "iq_intermediateOut\\"<>iteration<>".bionj"];
DeleteFile[iteration<>".bionj"];
CopyFile[iteration<>".ckp.gz", "iq_intermediateOut\\"<>iteration<>".ckp.gz"];
DeleteFile[iteration<>".ckp.gz"];
CopyFile[iteration<>".log", "iq_intermediateOut\\"<>iteration<>".log"];
DeleteFile[iteration<>".log"];
CopyFile[iteration<>".mldist", "iq_intermediateOut\\"<>iteration<>".mldist"];
DeleteFile[iteration<>".mldist"];
CopyFile[iteration<>".iqtree", "iq_intermediateOut\\"<>iteration<>".iqtree"];
DeleteFile[iteration<>".iqtree"];

]


(* ::Code::Plain:: *)
(*note: if this doesn't work, delete the file extension on iqtree and try again.*)
computeRFAll[baselineTree_String, treeDir_, stage_, numIters_]:=Block[{fn},
(*calculate RF metric with iqtree*)

CopyFile["iqtree", treeDir<>"\\iqtree"];
SetDirectory[treeDir];
(*fn=DeleteCases[DeleteCases[DeleteCases[FileNames[], baselineTree], "iqtree.exe"],"libiomp5md.dll"];(*should yield a list of JUST the tree file names*)
*)
fn=Table[ToString[stage]<>"."<>ToString[iterations]<>".treefile",{iterations, 1, numIters} ];

allRFs={};

Block[{},Run["iqtree -rf "<>#<>" "<>baselineTree<>" -nt 2"];
(*put the results into an updatable object*)
allRFs=Append[allRFs,readRFSingle[baselineTree<>".rfdist", StringJoin[Riffle[Drop[StringSplit[#, "."], -1], "."]]] ];

(*manage the files*)
CopyFile[baselineTree<>".rfdist", ParentDirectory[]<>"\\rf_intermediateOut\\"<>StringJoin[Riffle[Drop[StringSplit[#, "."], -1], "."]]<>"."<>baselineTree<>".rfdist"];
CopyFile[baselineTree<>".log",  ParentDirectory[]<>"\\rf_intermediateOut\\"<> StringJoin[Riffle[Drop[StringSplit[#, "."], -1], "."]]<>"."<>baselineTree<>".log"];
DeleteFile[baselineTree<>".log"];
DeleteFile[baselineTree<>".rfdist"];
]&/@ fn;
DeleteFile["iqtree"];
SetDirectory[ParentDirectory[]];
]


(* ::Subsubsection::Closed:: *)
(*Base (PC) version*)


radicalRun[lociDirectory_, workingDir_,startingSize_, stepSize_, baselineTree_, outGroup_, noOfReplicates_Integer]:=radicalRun[lociDirectory, workingDir,startingSize, stepSize, baselineTree, outGroup, noOfReplicates, 1]


(* ::Text:: *)
(*This is the same as the above but with the added parameter "restartAt" which is an integer saying at what stage to restart the function*)


(*aka radical resume*)
radicalRun[lociDirectory_, workingDir_,startingSize_, stepSize_, baselineTree_, outGroup_, noOfReplicates_Integer,restartAt_]:=Block[{startTime, remainingHours, stopq},

Table[
startTime=AbsoluteTime[];
runASingleRadicalStage[lociDirectory, workingDir,startingSize, stepSize, stage, baselineTree, outGroup];

Print["The last replicate took "<>ToString[AbsoluteTime[]-startTime]<>" seconds. Multiplied by the total number of replicates your radical run will take "<>ToString[remainingHours=((((AbsoluteTime[]-startTime)/60)/60)*(noOfReplicates-stage))]<>" more hours. We expect radical to finish at "<>DateString[Date[]+{0, 0, 0, remainingHours//IntegerPart, (remainingHours//FractionalPart)*60, 0}]<>"."];

(*EmitSound[Sound[SoundNote["CSharp", 2,"ElectricGuitar"]]];*)(*decomment this to add a audio notification when a stage is completed and RF values have been assessed.*)

(*If[Divisible[stage, checkLength], Print["Reached checkpoint...assessing convergence"];If[(stopq=doWeStop[allRFs,noOfReplicates, checkLength ])<= stage, 
Print["Convergence reached, finishing up."];Goto["finishUp"];, Null;Print["Convergence not yet reached. Continuing for approximately " <>ToString[stopq]<>" total replicates"]];
, Null;];*)(*Decomment this if you come up with a better way of assessing convergence. For now, this is pointless because the variance is too high.*)

stagesTOT=noOfReplicates;
,{stage, restartAt, noOfReplicates}];
Label["finishUp"];
(*make the ALLRFs list again, because it might not work from the above*)
SetDirectory["rf_intermediateOut"];
allRFs={};
Table[
allRFs=Append[allRFs,readRFSingle[ToString[i]<>"."<>ToString[j]<>"."<>"baseline_comb.nobl.tre"<>".rfdist", ToString[i]<>"."<>ToString[j]]], 
{i, 1,stagesTOT }, {j, 1, itersTOT}
];
(*SetDirectory[ParentDirectory[]];*)
radicalResultsMaker[allRFs, startingSize, stepSize];
Print["Radical has concluded. This is a good thing. You are a cool person."];
Speak["Program concluded. Good job."];
]


radicalResultsMaker[allRFs_, startingSize_, stepSize_]:=Block[{currentSize, lm, data, allRFsNew,bestTree},
CreateDirectory["radical_results"];
SetDirectory["radical_results"];
Export["all_robinsonFoulds_distances.csv", allRFs];
allRFsNew=SortBy[Flatten[ToExpression/@{StringSplit[#[[1]], "."], Drop[#, 1]}]&/@allRFs, #[[1]]&];

data=(Flatten[{If[#[[2]]==1, currentSize=12,currentSize=currentSize+5], Drop[#, 2]//Mean}]&/@allRFsNew);

Export["radicalPlot."<>DateString[{"HourShort", "MinuteShort", "Second"}]<>".png",Rasterize[Show[ListPlot[data, PlotRange->{{1, (data[[All, 1]]//Max)*2}, {1, (data[[All, 2]]//Max)*2}}, Frame->True, FrameLabel->{"# of loci", "Mean RobinsonFoulds distance"}],
lm=LinearModelFit[data, 1/x, x];
Plot[lm[x], {x, -100, (data[[All, 1]]//Max)*2}, PlotStyle->Thin]
], RasterSize->1200, ImageSize->700]];
Export["model."<>DateString[{"HourShort", "MinuteShort", "Second"}]<>".txt", Normal[lm]];
SetDirectory[ParentDirectory[]];
bestTree=SortBy[{#[[1]], Drop[#, 1]//Mean}&/@allRFs, #[[2]]&][[1, 1]]<>".treefile";
CopyFile["trees_All\\"<>bestTree,"radical_results\\"<>"bestTree."<>bestTree ];

]


runASingleRadicalStage[lociDirectory_, workingDir_,startingSize_, stepSize_, stage_, baselineTree_, outGroup_]:=Module[{numOfLoci, numIters, sri},

errorStatus="noError";

(*checks that all loci will be sampled*)
SetDirectory[lociDirectory];
numOfLoci=Length[FileNames[]];
If[IntegerQ[numIters=(numOfLoci-startingSize)/stepSize], Print["CHECK: All loci will be sampled. ... proceeding"];, Print["CHECK: ERROR. Not all loci will be sampled. Make sure the # of loci - starting size is divisible by stepsize. ... quitting"]; Goto["forceOut"];]


SetDirectory[workingDir];


(*create necessary output folders. move this one level up when i make the loop*)
CreateDirectory["alignments_All"];
CreateDirectory["iq_intermediateOut"]//Quiet;
CreateDirectory["rf_intermediateOut"]//Quiet;
CreateDirectory["trees_All"]//Quiet;
CreateDirectory["samplingInfo"]//Quiet;

(*instantiates some lists*)
allRFs={};
iterationStatus="First";

(*make the first alignment from the three most complete alignments and a certian number of other random loci*)
makeFirstAlignment[lociDirectory, workingDir<>"\\alignments_All", startingSize, stage];
If[errorStatus=="kill", Goto["forceOut"];, Print["first alignment successful. ... proceeding"]];

CopyFile[workingDir<>"\\alignments_All\\"<>ToString[stage]<>"."<>ToString[1]<>".fas", workingDir<>"\\"<>ToString[stage]<>"."<>ToString[1]<>".fas"]; (*makes a temporary copy of the file*)

(*makes an alignment and runs the first iteration of radical on it. at this point, even if the stop criteria are met it will do at least one more iteration*)
SetDirectory[workingDir];
iqTREE[ToString[stage]<>"."<>ToString[1]<>".fas", outGroup,ToString[stage]<>"."<>ToString[1]]; (*previously, this section had the singleRadicalIteration function*)

If[errorStatus=="kill", Goto["forceOut"];, Print["first iteration successful. ... proceeding"]];
(*Print[Directory[]<>ToString[" should be the working directory"]];*)(*this was just here to make sure the direcotyr was right. it doesn't need to be uncommented unless you shange the above code and are unsure.*)
DeleteFile[workingDir<>"\\"<>ToString[stage]<>"."<>ToString[1]<>".fas"];
(*deletes the temporary copy of the alignment*)
iterationStatus="Subsequent";

Table[
Print[iteration];
(*this loop will keep going until the stop criteria is met OR all the loci are sampled.*)
makeNextAlignments[lociDirectory, workingDir<>"\\alignments_All", stepSize, stage, iteration];

CopyFile[workingDir<>"\\alignments_All\\"<>ToString[stage]<>"."<>ToString[iteration]<>".fas", workingDir<>"\\"<>ToString[stage]<>"."<>ToString[iteration]<>".fas"]; (*makes a temporary copy of the file*)

If[errorStatus=="kill",Print["previous alignment file name is misspecified"]; Goto["forceOut"];,Null;];

SetDirectory[workingDir];
iqTREE[ToString[stage]<>"."<>ToString[iteration]<>".fas", outGroup,ToString[stage]<>"."<>ToString[iteration]]; (*previously, this section had the singleRadicalIteration function*)
If[errorStatus=="kill",Print["IQTree exited without evaluating... ending radical."]; Goto["forceOut"];,Null;];
If[sri, Print["Stop criterion met"];Goto["forceOut"], Null;];
DeleteFile[ workingDir<>"\\"<>ToString[stage]<>"."<>ToString[iteration]<>".fas"];(*deletes the temporary copy of the alignment*)
itersTOT=iteration;
, {iteration, 2,((numOfLoci-startingSize)/stepSize)+1 }];

Print["All trees in this stage done, calculating tree comparison metrics.."];
(*EmitSound[Sound[Sound[SoundNote["FFlat",.5,"Violin"]]]];*)(*Decomment to play a sound when a RADICAL stage is finished but befor RF values are calculated.*)
(*now calculcate Robinson-Foulds distances*)
CopyFile[workingDir<>"\\"<>baselineTree, workingDir<>"\\trees_All\\"<>baselineTree];
computeRFAll[baselineTree, workingDir<>"\\trees_All", stage, ((numOfLoci-startingSize)/stepSize)+1];
Export[workingDir<>"\\samplingInfo\\"<>ToString[stage]<>".csv", sampledLoci];

Label["forceOut"];
(*EmitSound[Sound[Sound[SoundNote["A",1,"Violin"]]]];*)
Print["Stage "<>ToString[stage]<>" completed."];
SetDirectory[ParentDirectory[]];
]


(* ::Code::Bold:: *)
makeNextAlignments[lociDirectory_, alignmentDir_, stepSize_Integer, stage_Integer, iteration_Integer]:=Block[{(*sample,*) con, con2},
SetDirectory[lociDirectory];
sample=RandomSample[Complement[allFiles, sampledLoci], stepSize];
Print["choosing some new loci at random"];
con=concatAlign[SortBy[(importAlignment[#])&/@sample, #[[1, 1]]&]];
SetDirectory[alignmentDir];
If[ContainsAny[FileNames[],{ToString[stage]<>"."<>ToString[iteration-1]<>".fas"}], Null;, errorStatus="kill";]; (*throws an error if the alignment we are adding onto doesn't exist. for internal troubleshooting*)
con2=concatAlign[{importAlignment[ToString[stage]<>"."<>ToString[iteration-1]<>".fas"], con//fastaParser}];
Print["adding them to the previous alignment"];
Export[alignmentDir<>"\\"<>ToString[stage]<>"."<>ToString[iteration]<>".fas", con2,"Text"];

sampledLoci=Flatten[Append[sampledLoci, sample]];
{sample, sampledLoci}(*delete this*)
]


(* ::Text:: *)
(*Because IQTREE cannot handle alignments with taxa that are entirely missing data, we need to make sure the first time we run the radical algorithm we have an alignment which has data for at least every taxon. This function makes that alignment.*)


makeFirstAlignment[lociDirectory_, alignmentDir_, startingSize_Integer, stage_Integer]:=Block[{iii,threeMostFull, a, con, sample, limit1, limit2},
If[startingSize<=5,Print["Starting size too low. Increase to 5 or more"];errorStatus="kill";Goto["End"];, Null; ];
SetDirectory[lociDirectory];
allFiles=FileNames[];
limit1=Ceiling[(allFiles//Length)-(startingSize-3)]*3;
limit2=Ceiling[(allFiles//Length)-(startingSize-5)]*4;
(*I am going to start with the most complete alignment...otherwise the script doesn't meet the finishing criteria*)
threeMostFull=(SortBy[({#, deleteEmptySequences[importAlignment[#], 1]//Length}&/@allFiles), #[[2]]&]//Reverse)[[1;;3, 1]];
iii=0;

Label["start"];
iii++;

If[iii==limit1, Print["After "<>ToString[limit1]<>" tries, some taxa are still entirely ambiguous. You might consider increasing the starting size."]; 
threeMostFull=(SortBy[({#, deleteEmptySequences[importAlignment[#], 1]//Length}&/@allFiles), #[[2]]&]//Reverse)[[1;;5, 1]];
, Null;];(*this one will redefine the starting alignment to contain the 5 most complete alignments if there are too many iterations of trying and not getting all taxa into the alignment.*)
If[iii==(limit1+limit2), Print["After "<>ToString[limit1+limit2]<>" tries, some taxa are still entirely ambiguous. You might consider increasing the starting size."]; 
errorStatus="kill";Goto["End"];
, Null];(*this one will kill the script if it keeps trying and there still isn't a useable alignment. I would guess that at this point, if it has gone through this many iterations, it is unlikely that all taxa have data in the alignment*)

sample=If[iii<limit1, {RandomSample[Complement[allFiles, threeMostFull], startingSize-3], threeMostFull}//Flatten,{RandomSample[Complement[allFiles, threeMostFull], startingSize-5], threeMostFull}//Flatten ];

con=concatAlign[SortBy[(a=importAlignment[#])&/@sample, #[[1, 1]]&]];
If[Length[a]==Length[deleteEmptySequences[con//fastaParser]], (*if it has all the taxa, make an alignment file named stage<>iteration*)Export[alignmentDir<>"\\"<>ToString[stage]<>".1.fas", con,"Text"];,
(*otherwise, go back to start*)Print["not all taxa sampled...restarting"]; Goto["start"];];
sampledLoci=Flatten[sample];
Label["End"];
]


(* ::Text:: *)
(*This function uses IQ-TREE to make a tree from the alignment specified.*)


iqTREE[inputAlign_String, outGroup_String, iteration_String]:=Block[{},
(*run the tree. note that TREECOMMANDS go here*) 
(*the switch tells the script how to run IQTREE, either from an NJ starting tree, or using the tree from the previous run as the initial tree.*)
Switch[iterationStatus,
"First",
(*makes a tree starting from a BIONJ tree*)

Module[{startTime},

Print["iqtree.exe -s "<>inputAlign<>" -m GTR+G -fast -nt 2 -st DNA -t BIONJ -ntop 10 -pre "<>iteration];
Print["tree started at "<>(startTime=DateString[])];
Run["iqtree.exe -s "<>inputAlign<>" -m GTR+G -fast -nt 2 -st DNA -t BIONJ -ntop 10 -pre "<>iteration]; 
Print["...tree took "<>ToString[AbsoluteTime[DateString[]]-AbsoluteTime[startTime]]<>" seconds."];
];
,

"Subsequent",

Module[{text, startTime},
Print["tree started at "<>(startTime=DateString[])];Run[text=("iqtree.exe -s "<>inputAlign<>" -m GTR+G -fast -nt 2 -st DNA -t initiate.treefile -ntop 10 -mem 3G -o "<>outGroup<>" -pre "<>iteration)];(*change -t back to initiate.treefile*)
Print[text];
Print["...tree took "<>ToString[AbsoluteTime[DateString[]]-AbsoluteTime[startTime]]<>" seconds."];
];


DeleteFile["initiate.treefile"];
];
CopyFile[iteration<>".treefile", "trees_All\\"<>iteration<>".treefile"];
CopyFile[iteration<>".treefile", "initiate.treefile"]; (*makes a new file that can later be used as a starting tree*)
DeleteFile[iteration<>".treefile"];
If[FileExistsQ[iteration<>".log"], Null;, errorStatus="kill"];
CopyFile[iteration<>".bionj", "iq_intermediateOut\\"<>iteration<>".bionj"];
DeleteFile[iteration<>".bionj"];
CopyFile[iteration<>".ckp.gz", "iq_intermediateOut\\"<>iteration<>".ckp.gz"];
DeleteFile[iteration<>".ckp.gz"];
CopyFile[iteration<>".log", "iq_intermediateOut\\"<>iteration<>".log"];
DeleteFile[iteration<>".log"];
CopyFile[iteration<>".mldist", "iq_intermediateOut\\"<>iteration<>".mldist"];
DeleteFile[iteration<>".mldist"];
CopyFile[iteration<>".iqtree", "iq_intermediateOut\\"<>iteration<>".iqtree"];
DeleteFile[iteration<>".iqtree"];

]


(* ::Text:: *)
(*Imports the info from the .rfdist file. Note this will only work if there is one tree compared againt many, or one other tree. Otherwise, we need to use a different (unwritten) function that will import a table instead of a list.*)


(* ::Code::Plain:: *)
computeRFAll[baselineTree_String, treeDir_, stage_, numIters_]:=Block[{fn},
(*calculate RF metric with iqtree*)
SetDirectory[treeDir];
SetDirectory[ParentDirectory[]];
CopyFile["iqtree.exe", treeDir<>"\\iqtree.exe"];
CopyFile["libiomp5md.dll", treeDir<>"\\libiomp5md.dll"];
SetDirectory[treeDir];
(*fn=DeleteCases[DeleteCases[DeleteCases[FileNames[], baselineTree], "iqtree.exe"],"libiomp5md.dll"];(*should yield a list of JUST the tree file names*)
*)
fn=Table[ToString[stage]<>"."<>ToString[iterations]<>".treefile",{iterations, 1, numIters} ];

allRFs={};

Block[{},Run["iqtree.exe -rf "<>#<>" "<>baselineTree<>" -nt 2"];
(*put the results into an updatable object*)
allRFs=Append[allRFs,readRFSingle[baselineTree<>".rfdist", StringJoin[Riffle[Drop[StringSplit[#, "."], -1], "."]]] ];

(*manage the files*)
CopyFile[baselineTree<>".rfdist", ParentDirectory[]<>"\\rf_intermediateOut\\"<>StringJoin[Riffle[Drop[StringSplit[#, "."], -1], "."]]<>"."<>baselineTree<>".rfdist"];
CopyFile[baselineTree<>".log",  ParentDirectory[]<>"\\rf_intermediateOut\\"<> StringJoin[Riffle[Drop[StringSplit[#, "."], -1], "."]]<>"."<>baselineTree<>".log"];
DeleteFile[baselineTree<>".log"];
DeleteFile[baselineTree<>".rfdist"];
]&/@ fn;
DeleteFile["iqtree.exe"];
DeleteFile["libiomp5md.dll"];
SetDirectory[ParentDirectory[]];
]


(* ::Text:: *)
(*Below is a non-essential function and is not used in the main loop of the software. However, using it afterwards will compute the Robinson-Fouldes distances of all the trees done in a round and compare them to each other. This will give a measurement of how variable the trees are in each set of loci.*)
(**)
(*Input is: *)
(**)
(*	treesDir - A string representing the directory for which all RADICAL trees (or any set of single tree files) is located.*)
(*	iqTREEPath - A string representing thr path to IQTree executable.*)


computeRFAlltoALL[treesDir_, iqTREEPath_]:=Block[{treeSets,treeFiles,comparisonSets},
(*calculate RF metric with iqtree*)

SetDirectory[treesDir];
(*fn=DeleteCases[DeleteCases[DeleteCases[FileNames[], baselineTree], "iqtree.exe"],"libiomp5md.dll"];(*should yield a list of JUST the tree file names*)
*)
treeFiles=FileNames["*.treefile"];

Print["Combining tree files for comparison in IQTREE."];
comparisonSets=StringJoin[Riffle[#, "."]]&/@#&/@GatherBy[StringSplit[#, "."]&/@treeFiles, #[[2]]&];
treesBySet=Export["set."<>StringSplit[#[[ 1]], "."][[2]]<>".trees",StringJoin[
Riffle[StringTrim[Import[#, "String"]]&/@#, "\n"]
], "Text"]&/@comparisonSets;
Print["Computing all-all Robinson-Foulds distances."];

treeSets=FileNames["*.trees"];

allRFs={};

Block[{},Run[iqTREEPath<>" -t "<>#<>" -rf_all -nt 1"];
(*put the results into an updatable object*)
allRFs=Append[allRFs,{#,DeleteCases[LowerTriangularize[(Drop[#, 1]&/@Drop[Import[#<>".rfdist", "Table"], 1])]//Flatten, 0]}//Flatten
]]&/@ treeSets;
Print["Exporting distances."];
Export["treeVarianceRFs.csv",allRFs];
SetDirectory[ParentDirectory[]];
]


(* ::Text:: *)
(*Below is the plotting function for the output of computeRFAlltoALL[ ]. It can make two types of plots given that data.*)
(*Input is:*)
(*	dataSet1File - the string with the exact file name as the first data set you want to plot.*)
(*	dLabel1 - a string with the name for labelling dataSet1File plots*)
(*	dataSet2File - the string with the exact file name as the second data set you want to plot.*)
(*	dLabel2 - a string with the name for labelling dataSet2File plots*)
(*	startingNumLoci - the number of loci you had in all your first steps of RADICAL*)
(*	addLociSteps - how many loci you concatenated at each step*)
(*	plotType - accepts either "DistributionChart" or "ListPlot". See built-in Mathematica functions for details.*)


plotTreeVariance[dataSet1File_,dLabel1_String, dataSet2File_, dLabel2_String, startingNumLoci_Integer, addLociSteps_Integer, plotType_String]:=

Block[{initial, stepSize, dataSet1, dataSet2},
(*import the data*)
dataSet1=Import[dataSet1File];
dataSet2=Import[dataSet2File];
(*set up params*)
initial=startingNumLoci;
stepSize=addLociSteps;
(*Prepare the first data set*)
Block[{data1a, data2a, numLoci},data1a=Sort[{StringSplit[#[[1]], "."][[2]]//ToExpression, #[[2;;]]}&/@dataSet1];
numLoci=initial;
data2a=Table[If[i==1,{data1a[[i, 1]],{numLoci}, data1a[[i, 2]]}, {data1a[[i, 1]],{numLoci=numLoci+stepSize}, data1a[[i, 2]]}], {i, 1, Length[data1a]}];
data3a=Flatten[((Reverse/@Partition[Riffle[#[[ 3]], #[[ 2]]], 2])&/@data2a), 1];];

(*Prepare the second data set*)
Block[{data1b, data2b,numLoci},data1b=Sort[{StringSplit[#[[1]], "."][[2]]//ToExpression, #[[2;;]]}&/@dataSet2];
numLoci=initial;
data2b=Table[If[i==1,{data1b[[i, 1]],{numLoci}, data1b[[i, 2]]}, {data1b[[i, 1]],{numLoci=numLoci+stepSize}, data1b[[i, 2]]}], {i, 1, Length[data1b]}];
data3b=Flatten[((Reverse/@Partition[Riffle[#[[ 3]], #[[ 2]]], 2])&/@data2b), 1];];

Switch[plotType,
"DistributionChart",
Show[
DistributionChart[GatherBy[data3a, First][[All, All, 2]], ChartStyle->Directive[ Opacity[.6],(*color1=RGBColor[.7, 0, .8]*)Black], ChartLegends->{dLabel1}],
DistributionChart[GatherBy[data3b, First][[All, All, 2]], ChartStyle->Directive[Opacity[0.5], (*color2=CMYKColor[0, .1,1, .1 ]*)White
] ,ChartLegends->{dLabel2}], FrameLabel->{"RADICAL step", "R-F distance among trees"}, ImageSize->500], 
"ListPlot1",
data3a=Flatten[Drop[ GatherBy[data3a//Sort, First], 1], 1];
data3b=Flatten[Drop[ GatherBy[data3b//Sort, First], 1], 1];
lmA=LinearModelFit[data3a, x, x];
lmB=LinearModelFit[data3b, x, x];
Print["NOTE that the ListPlot1 method drops the first step of RADICAL."];
Show[ListPlot[{data3a, data3b}, PlotRange->{{1, (*(data[[All, All, 1]]//Max)*1.25*)110}, {0
, (*(data[[All, All, 2]]//Max)*1.25*)200}}, Frame->True, FrameLabel->{"RADICAL step", "R-F distance among trees"}, FrameStyle->Automatic, PlotLegends->{dLabel1, dLabel2},  PlotStyle->{{PointSize[Medium],GrayLevel[.75]}, {PointSize[Medium],GrayLevel[.4]} }(*,PlotTheme\[Rule]{"GrayColor" }*)], Plot[{lmA[x], lmB[x]}, {x, 0, 110}, PlotStyle->{{Thick, GrayLevel[.75]}, {Thick, GrayLevel[.4]}}, PlotLabels->Automatic, PlotLegends->{dLabel1, dLabel2}], ImageSize->400, Background->White]
,
"ListPlot2",
Show[ListPlot[{data3a, data3b}, PlotRange->{{1, (*(data[[All, All, 1]]//Max)*1.25*)110}, {0
, (*(data[[All, All, 2]]//Max)*1.25*)200}}, Frame->True, FrameLabel->{"RADICAL step", "R-F distance among trees"}, FrameStyle->Automatic, PlotLegends->{dLabel1, dLabel2},  PlotStyle->{{PointSize[Medium],GrayLevel[.75]}, {PointSize[Medium],GrayLevel[.4]} }(*,PlotTheme\[Rule]{"GrayColor" }*)],
lmA=LinearModelFit[data3a, 1/x, x];
lmB=LinearModelFit[data3b, 1/x, x];
Plot[{lmA[x], lmB[x]}, {x, 0, 110}, PlotStyle->{{Thick, GrayLevel[.75]}, {Thick, GrayLevel[.4]}}, PlotLabels->Automatic, PlotLegends->{dLabel1, dLabel2}], ImageSize->400, Background->White]

 ]
]


(* ::Text:: *)
(*This function will take the file structure from the RADICAL trees output and use IQTREE to calculate consensus trees for each iteration. I can then extract the average and variance of bootstrap scores for this tree, which will be another way of representing locus deirved tree-variance.*)


(* ::Code::Plain:: *)
computeConsensusTreesRADICAL[treeDir_,totStages_Integer, numIters_Integer]:=Block[{fn},
(*this will compute a consensus tree using IQTree from the radical trees*)

CopyFile["iqtree.exe", treeDir<>"\\iqtree.exe"];
CopyFile["libiomp5md.dll", treeDir<>"\\libiomp5md.dll"];
SetDirectory[treeDir];

Table[Block[{},Run["iqtree.exe -t "<>StringJoin[Riffle[Table[ToString[stag]<>"."<>ToString[iter]<>".treefile", {stag, 1, totStages}], " "]]<>"-con -nt 2"];
(*put the results into an updatable object*)
], {iter, 1, numIters}];

(*manage the files*)
DeleteFile["iqtree.exe"];
DeleteFile["libiomp5md.dll"];
SetDirectory[ParentDirectory[]];
]


(* ::Text:: *)
(*This function determines if the current number of iterations justifies stopping. The criteria it uses is complicated and is detailed below. Simply put, it calculates at what number of iterations will 95% of the points on the radical curve have a mean and variance that doesn't change if more loci are added. How many more loci? That is specified by the parameter checkLength. What do we mean by "doesn't change"? We mean that if the difference of the mean and std.dev. between sets of iterations is less than 95% of the differences in the mean and std.dev. among the treatments. It treats convergence under the criteria that variance between samples should be more than variance among samples. (NOTE: preliminary uses of this function show that it is useless. Since variance between steps tends to be very low at the end of the curve, the convergence criterion is extremely conservative. Either the user should run many more iterations under this convergence criterion, or a different criterion should be defined. Currently, I suggest ignoring the output from this script.*)
(**)
(*Input is: *)
(*	allRFs - a list which is the variable defined in computeRFAll*)
(*	maxIter - an integer giving the maximum number of iterations allowed.*)
(*	checkLength - an integer giving how often you want the software to check for convergence.*)


doWeStop[allRFs_,maxIter_, checkLength_ ]:=
Block[{allRFsNew,d,groupMeans, groupStdds, groupmeanDiff, groupstdDiff, meanCutoff, stddCutoff, resample, allSample, mean, stdDiff, stdd, meanDiff,maxItersMean, maxItersSTDd },
Print["Checking stop criteria."];
allRFsNew=SortBy[Flatten[ToExpression/@{StringSplit[#[[1]], "."], Drop[#, 1]}]&/@allRFs, #[[1]]&];
maxItersMean={};
maxItersSTDd={};
d=N[Mean[Drop[#, 2]]]&/@#&/@(GatherBy[allRFsNew, #[[2]]&]);
(*this is the data*)

groupMeans=Mean/@d;
groupStdds=StandardDeviation/@d;
groupmeanDiff=Table[
Abs[(groupMeans[[i]]-groupMeans[[i+1]])], 
{i, 1, Length[groupMeans]-1}];
groupstdDiff=Table[
Abs[(groupStdds[[i]]-groupStdds[[i+1]])], 
{i, 1, Length[groupStdds]-1}];
meanCutoff=groupmeanDiff//Min;
stddCutoff=groupstdDiff//Min;
(*this defines the cutoff of how many samples we need as the lowest 95% difference of the means (or stddevs) between the test groups (number of loci).*)

Table[

resample={};
allSample=Table[
resample=Flatten[Append[ RandomSample[d[[i]], checkLength], resample], 1]
,{k, 1,11(*this is an arbitrary number of pseudoreplicate concatenations into the future. I chose 11 because we are going to take the differences between them, which will result in a list of differences of length 1 less than this value*)}];

(*this section (above) makes pseudoreplicates from the original sample. It's the equivalent of asking if we sampled 5 more times, what would our values look like? If we sampled 5 more times, up to eleven total times, what would our data look like?*)

mean=Mean/@allSample;
stdd=StandardDeviation/@allSample;
(*this calculates the mean and std dev at each length of sampling. *)
meanDiff=Table[
Abs[(mean[[i]]-mean[[i+1]])], 
{i, 1, Length[mean]-1}];
stdDiff=Table[
Abs[(stdd[[i]]-stdd[[i+1]])], 
{i, 1, Length[mean]-1}];
(*this section calculates the squared-change of the mean and standard deviation over time. if there is no change then we should stop sampling*)

maxItersMean=Flatten[Append[maxItersMean,MapIndexed[If[#1<= meanCutoff, #2*checkLength, maxIter]&, meanDiff]]];
maxItersSTDd=Flatten[Append[maxItersSTDd,MapIndexed[If[#1<= stddCutoff, #2*checkLength, maxIter]&, stdDiff]]];
(*the cutoff should be based on the differences in the means between the groups. If the differences in the means (or std deviations is less than the differences between the groups, then we have sampled enough*)

, {i, 1, Length[d](*change this to the length of the number of currently completed replicates i.e. Length[d]*)}];
Min[Quantile[maxItersSTDd, .95],
Quantile[maxItersMean, .95]]
]
(*this final line says gives the number of iterations that should be done so that 95% of the points along the radical curve have converged at for at least the their mean or standard deviation*)


readRFSingle[rfdist_String, iteration_String]:=Block[{a},
{iteration, (a=Drop[Import[rfdist], 1][[All, 2]])}//Flatten
]


radicalResultsComparison2[listOfRFFiles_, startingSize_, stepSize_]:=Block[{allAllRFsNew,currentSize, data, lms, aalRTF},

allAllRFsNew=Flatten[{ToExpression/@StringSplit[#[[1]]//ToString, "."], Drop[#, 1]}]&/@Import[#]&/@listOfRFFiles;

(*the section below changes all of the incorrectly converted 1.10's. Because mathematica is interpreting these as the number 1.10 it is dropping the last 0, which is causing the gene count to be incorrect. *)

aalRTF=Table[
set=GatherBy[allAllRFsNew[[k]], First];
Flatten[Table[
out=If[(marker=="switch"(*&&set[[j]]\[Equal]1*)),ReplacePart[#[[j]], 2->10], #[[j]]];
If[#[[j, 2]]==9, marker="switch", marker="stay"];
Flatten[out]
, {j, 1, Length[#]}]&/@set, 1], {k, 1, Length[listOfRFFiles]}];


data=Table[(Flatten[{If[#[[2]]==1, currentSize=12,currentSize=currentSize+5], Drop[#, 2]//Mean}]&/@aalRTF[[i]])
, {i, 1 , Length[listOfRFFiles]}];

Show[ListPlot[data, PlotRange->{{1, (*(data[[All, All, 1]]//Max)*1.25*)110}, {1, (*(data[[All, All, 2]]//Max)*1.25*)200}}, Frame->True, FrameLabel->{"# of loci", "Mean RobinsonFoulds distance"},  PlotStyle->{{PointSize[Medium],GrayLevel[.75]}, {PointSize[Medium],GrayLevel[.4]} }(*,PlotTheme\[Rule]{"GrayColor" }*), PlotLegends->listOfRFFiles],
lms=LinearModelFit[#, 1/x, x]&/@data;
Plot[Evaluate[Through[lms[x]]], {x, 0, (data[[All,All, 1]]//Max)*2}, PlotStyle->{{Thick, GrayLevel[.75]}, {Thick, GrayLevel[.4]}}, PlotLabels->Automatic, PlotLegends->listOfRFFiles]]

]


radicalResultsComparisonAll[listOfRFFiles_, startingSize_, stepSize_]:=Block[{allAllRFsNew,currentSize, data, lms, aalRTF},

allAllRFsNew=Flatten[{ToExpression/@StringSplit[#[[1]]//ToString, "."], Drop[#, 1]}]&/@Import[#]&/@listOfRFFiles;

(*the section below changes all of the incorrectly converted 1.10's. Because mathematica is interpreting these as the number 1.10 it is dropping the last 0, which is causing the gene count to be incorrect. *)

aalRTF=Table[
set=GatherBy[allAllRFsNew[[k]], First];
Flatten[Table[
out=If[(marker=="switch"(*&&set[[j]]\[Equal]1*)),ReplacePart[#[[j]], 2->10], #[[j]]];
If[#[[j, 2]]==9, marker="switch", marker="stay"];
Flatten[out]
, {j, 1, Length[#]}]&/@set, 1], {k, 1, Length[listOfRFFiles]}];


data=Table[(Flatten[{If[#[[2]]==1, currentSize=12,currentSize=currentSize+5], Drop[#, 2]//Mean}]&/@aalRTF[[i]])
, {i, 1 , Length[listOfRFFiles]}];

Show[ListPlot[data, PlotRange->{{1, (*(data[[All, All, 1]]//Max)*1.25*)110}, {1, (*(data[[All, All, 2]]//Max)*1.25*)200}}, Frame->True, FrameLabel->{"# of loci", "Mean RobinsonFoulds distance"},  PlotStyle->PointSize[Medium](*,PlotTheme\[Rule]{"GrayColor" }*), PlotLegends->listOfRFFiles],
lms=LinearModelFit[#, 1/x, x]&/@data;
Plot[Evaluate[Through[lms[x]]], {x, 0, (data[[All,All, 1]]//Max)*2}, PlotStyle->{{Dashed, Thick}, {DotDashed, Thick}, {Dotted, Thick}, {Thick}}, PlotLabels->Automatic, PlotLegends->listOfRFFiles]]

]


(* ::Chapter::Closed:: *)
(*Software functions*)


(* ::Subsection::Closed:: *)
(*Import RAXML partition file*)


partitionFileImporter[partitions_, "Loci"]:=Block[{p1},
p1=(StringSplit[#, "="]&/@StringSplit[partitions,"
"]);
ploci=(StringTrim/@StringSplit[#, ","]&/@p1[[All, 1]])[[All, 2]];
ptypes=(StringTrim/@StringSplit[#, ","]&/@p1[[All, 1]])[[All, 1]];
parts=Flatten[StringSplit[#//StringTrim, "-"]&/@StringSplit[#, ","]&/@{#}&/@StringTrim/@p1[[All, 2]], 1]
]



partitionFileImporter[partitions_, "Codons"]:=Block[{p1},
p1=(StringSplit[#, "="]&/@StringSplit[partitions,"
"]);
ploci=(StringTrim/@StringSplit[#, ","]&/@p1[[All, 1]])[[All, 2]];
ptypes=(StringTrim/@StringSplit[#, ","]&/@p1[[All, 1]])[[All, 1]];

parts=Flatten[StringSplit[#//StringTrim, "-"]&/@{StringDrop[#, -3]}&/@{#}&/@StringTrim/@p1[[All, 2]], 2]
]


(* ::Subsection::Closed:: *)
(*Extracting partitionfinder locus blocks from output*)


pFinderSchemesProcess[fileName_String]:=Block[{bestSchemesBlock},
bestSchemesBlock=StringSplit[StringSplit[Import[fileName], "Subset"][[2]], "Scheme"][[1]];

tableSchemes01=(StringTrim/@StringSplit[#, "|"]&/@Drop[StringSplit[bestSchemesBlock, "\n"], 1])[[All, {1,3, 5}]];(*this cuts down the list into specific parts we want*)

tableSchemes02={#[[1]],#[[2]], StringSplit[#[[3]],","]}&/@tableSchemes01; (*this does some block remanagement and counting*)

Export["locus_byPartition.csv"
,SortBy[Flatten[Table[{#[[2, i]]//StringTrim, #[[1]]//ToExpression}, {i, 1, Length[#[[2]] ]}]&/@tableSchemes02[[All, {1, 3}]], 1], First]
];(*exports by locus*)

Export["partitionMetaInfo_byGenes.csv",Prepend[
{ #[[1]]//ToExpression, Length[#[[3]] ], #[[2]]}&/@tableSchemes02

, {"Block", "# of loci", "nuc length of block"}]];(*exports by block*)

]


"F:\\Dropbox\\Projects\\Phylogeny of Blaberoidea\\Alignments\\merged alignment work jan 2018\\partitionFinder\\gene and codon subsets\\gtr and gtr g only and with different max min parameters\\analysis\\analysis"//SetDirectory;


(* ::Subsection::Closed:: *)
(*Matching partitionFinder schemes with a Biosystematica RAXML_part file*)


(* ::Text:: *)
(*Anytime you concatenate an alignment in Biosystematica, you also output a RAXML style partitions file. You can use this to specify blocks in partitionFinder. partitionFinder then lumps them based on it's analysis and you can use their output to partition your analysis.*)
(**)
(*However, when you have a very large alignment, with many partitions, and then you edit the original alignments, your partition file no longer matches the lengths of the actual partititions. This function fixes that.*)
(**)
(*In order for this to work, you need to have the output of the Biosystematica concatenation and the pFinder "best_scheme.txt" output in the working directory. Just invoking the function with no options will run the script assuming the default file names. Specifying the input, you can put renamed files.*)
(**)
(*Input is:*)
(*bioInformaticaRAXMLPart - a string specifying the "RAXMLPart.txt" file from the concatenation output.*)
(*pFinderBestsSchemes - a string specifying the name of the best schemes output from pFinder.*)


matchPartitionFormat[bioInformaticaRAXMLPart_String, pFinderBestsSchemes_String]:=Block[{(*bioInformaticaPartFile,partFinderLocusAssignments,gList, gatheredList*)},
bioInformaticaPartFile=SortBy[
Partition[DeleteCases[StringSplit[
Import[bioInformaticaRAXMLPart]
, {", ","=",";", "
"}], ""], 3][[All, {2, 3}]]
, First];

Export["bioinformatica_partitionNamesANDsplits.csv", bioInformaticaPartFile];

pFinderSchemesProcess[pFinderBestsSchemes];

partFinderLocusAssignments=SortBy[Drop[Import["locus_byPartition.csv"], 0], First];

If[(Complement[bioInformaticaPartFile[[All, 1]], partFinderLocusAssignments[[All, 1]]]//Length)==0, Print["files are compatible...proceeding"];, Print["ERROR: FILES INCOMPATIBLE"]; Goto["End"];];

gList=Flatten[{#, partFinderLocusAssignments[[
Position[partFinderLocusAssignments,#[[1]] ][[1, 1]] , 2
							 ]]}]&/@bioInformaticaPartFile;

gatheredList=GatherBy[gList, #[[3]]&];

Export["fixedPFINDER_blocks_for_RAXML.txt",
"DNA, Subset"<>ToString[#[[1, 3]]]<>" = "<>StringDrop[
StringDrop[
ToString[#[[All, 2]]], 1]
,-1]&/@gatheredList];


Label["End"];
]


matchPartitionFormat[]:=matchPartitionFormat["RAXMLpart.txt", "best_scheme.txt"];


(* ::Subsection::Closed:: *)
(*Processing assemblies of targeted enrichment data*)


(* ::Text:: *)
(*Assembled genomes from Illumina sequencing should yield lots of good DNA, some of which is target-organism genomic or mitchondrial. Yet, if you sequenced libraries that were prepared with probes to target certain loci, then those loci will be of interest to you. *)
(**)
(*Extracting these loci from the assemblies is done primarily through BLAST or other searching algorithm (in my case, VSearch). However, these searches can only identify the loci targeted by your probes, they don't actually pull them out or do any processing. The code below is designed to do that. *)
(**)
(*The code does three things:*)
(*1. Inserts taxon names into tokenized file names*)
(*2. Renames fasta-headers so they have locus names and taxon names.*)
(*3. Removes instances where probes were non-specific in their binding to genes*)
(**)
(*Point 3 is the important issue. We design our probes based on known taxa but we use them for unknown taxa. So any genes that are orthologous in the known taxa might not be orthologous in the unknown taxa. Also, regardless of orthology, junk DNA/pseudogenes could be unintentionally targetted by the probes. These cases will mess up the homology and and we should discard all instances of probed loci (both intentional and unintentional) that are not entirely unique. NOTE that we are not removing contigs that match with more than one probe, but only matching probes that match with more than one contig.*)


(* ::Subsubsection:: *)
(*Dependancy scripts*)


(* ::Text:: *)
(*This function finds probes that match with more than one contig using an input of BLAST style output results (easily output from VSearch).*)


findDangerousLoci[blastO_]:=Block[{badStuff, uniquenessList,  findDangerousLoci},
uniquenessList=Union/@GatherBy[
Table[
{StringReplace[StringSplit[blastO[[i, 1]], {"|", ";"}][[2]], " "->"_"], StringSplit[blastO[[i, 2]], {" ", "|"}][[1]]}
,{i, 1, Length[blastO]}]
, #[[1]]&];

badStuff=uniquenessList[[Position[Length/@uniquenessList, x_/;x>1]//Flatten ]]//Flatten//Union;

dangerousProbes={};
dangerousLoci = {};
Switch[StringTake[#, 2], 
"Zn" (*<- use this for ZNEV probes*), dangerousProbes=Prepend[{#}, dangerousProbes];,
(*"TR" <- use this for assemblues obtained through trinity*)_ (*<- use this for general purpose use*), dangerousLoci=Prepend[{#}, dangerousLoci];
]&/@badStuff;
dangerousProbes=dangerousProbes//Flatten;
dangerousLoci = dangerousLoci//Flatten;

(*just some output strings*)
{{"             There are...", (((dangerousProbes//Length)//ToString)<>"/"<>((StringSplit[blastO[[All, 1]], {"|", ";"}][[All, 2]]//Union//Length)//ToString)), "non-unique hits and dangerous probes.",dangerousLoci, "...should be removed from the dataset."}}//TableForm//Print;
{{"             ",dangerousProbes//Union, "...are culprits and will also be removed."}}//TableForm//Print;
dangerousLoci
]



(* ::Text:: *)
(*This script removes the designated loci from a FASTA-list (input is formed using the fastaParser[] script).*)


destroyLoci[sequences_, dangerousLoci_]:=Block[{trash},
trash=Position[
StringFreeQ[#//StringJoin,dangerousLoci ]&/@sequences[[All, 1]]
, False];
trashSeqs=sequences[[trash//Flatten]];
Delete[sequences,trash ]

]


(* ::Text:: *)
(*This creates a list of new headers to swap for the FASTA headers*)
(*assemblyHeadersToKeep is a list of the positions in the FASTA header of the assembly contigs that you wish to keep. EX for TRINITY assemblies it should be {1, 2, 4}; for the 1KITE transcriptomes it should be {1}.*)


redefineList[taxonName_, blastO_, assemblyHeadersToKeep_]:=Block[{probeLocus, trans, sizes, assembleLocus},
probeLocus=StringReplace[#, " "->"_"]&/@(StringSplit[#, {"|", ";"}]&/@blastO[[All, 1]])[[All, 2]];
trans=StringSplit[#, {" len=", " path=", ";"}]&/@blastO[[All, 2]];
sizes=ConstantArray[ToString[#], #]&/@Length/@SplitBy[trans, First]//Flatten;
assembleLocus=(Riffle[#, {" ; nucLen=", "; proberegions="}]//StringJoin)&/@(Flatten/@Partition[Riffle[trans, sizes ], 2])[[All, assemblyHeadersToKeep]];
Print["             The FASTA sequences to switch names with are..."];
Table[{StringSplit[assembleLocus[[i]], " ; "][[1]], taxonName<>"|"<>probeLocus[[i]]<>"|"<>assembleLocus[[i]]}, {i, 1 , Length[probeLocus]}]
]


(* ::Text:: *)
(*This actually swaps the headers.*)


redefineNames[sequences_, nameSwitches_]:=Block[{tempSeqNamesForFinding, seqs},
seqs=sequences;

tempSeqNamesForFinding=Table[(sequences[[i, 1, 1]]<>"|"<>sequences[[i, 1, 2]]//StringSplit)[[1]], {i, 1, Length[sequences]}];

(*((pear=ReplacePart[pear, {(Position[tempSeqNamesForFinding, #[[1]]]//Flatten)[[1]], 1}-> #[[2]] ])&/@nameSwitches);
*)
Table[((seqs=ReplacePart[seqs, {( 
If[
(p=Position[tempSeqNamesForFinding, nameSwitches[[j, 1]]])=={}, {999999999},p ]//Flatten)[[1]], 1}-> {nameSwitches[[j, 2]] }])), {j, 1, Length[nameSwitches]}];
seqs
]


redefineNames[sequences_, nameSwitches_, option_ (*either "TRINITY" or "1KITE"*)]:=Block[{tempSeqNamesForFinding, seqs},
seqs=sequences;
Switch[option, "TRINITY",
tempSeqNamesForFinding=Table[(sequences[[i, 1, 1]]<>"|"<>sequences[[i, 1, 2]]//StringSplit)[[1]], {i, 1, Length[sequences]}];
,"1KITE",
tempSeqNamesForFinding=Table[(sequences[[i, 1, 1]]//StringSplit)[[1]], {i, 1, Length[sequences]}];
];

(*((pear=ReplacePart[pear, {(Position[tempSeqNamesForFinding, #[[1]]]//Flatten)[[1]], 1}-> #[[2]] ])&/@nameSwitches);
*)
Table[((seqs=ReplacePart[seqs, {( 
If[
(p=Position[tempSeqNamesForFinding, nameSwitches[[j, 1]]])=={}, {999999999},p ]//Flatten)[[1]], 1}-> {Switch[option, "TRINITY",nameSwitches[[j, 2]], "1KITE", nameSwitches[[j, 2]]<>"|geneX" ]}])), {j, 1, Length[nameSwitches]}];
seqs
]


(* ::Text:: *)
(*This function combines all of the above into a single function. The parameters are:*)
(*	-taxonName: the name you want all your FASTA headers and files to lead with*)
(*	-sequences: a FASTAlist input (from fastaParser[]).*)
(*	-blastIn: a BLAST result input file (format obtained from VSearch).*)
(*	-assemblyHeadersToKeep - see above*)


processProbedLoci[taxonName_String, sequences_, blastIn_, assemblyHeadersToKeep_List, assemblyTYPE_String (*either "TRINITY" or "1KITE"*)]:=Block[{blast, newSequences, (*trashSeqs (*this might cause a problem*),*) nameSwitches, renamedSeqs, renamedTrash, renamedTrash2,blastHeader},
Print["Starting taxon..."<>taxonName];
blastHeader={"query","target","alignLength","ID%","# of mismatches","gap opennings","qlo","qhi","tlo","thi","evalue","bit score"};
blast=Drop[Prepend[blastIn, blastHeader], 1];
dangerousLoci=findDangerousLoci[blast];
newSequences=destroyLoci[sequences, dangerousLoci];
nameSwitches=redefineList[taxonName, blast, assemblyHeadersToKeep]//Union;
renamedSeqs=redefineNames[newSequences,nameSwitches, assemblyTYPE ];
renamedTrash=redefineNames[trashSeqs,nameSwitches ];

renamedSeqs=destroyLoci[renamedSeqs, {dangerousLoci, dangerousProbes}//Flatten];
renamedTrash=DeleteCases[Append[renamedTrash,trashSeqs], {}];
renamedTrash={{#[[1]]}, #[[2]]}&/@Partition[renamedTrash//Flatten, 2];(*This line was added later to fix a rare error that I did not try and find the source of. It SHOULD not cause a problem the results*)
trashS=fastaOutput[renamedTrash];
goodSeqs=fastaOutput[renamedSeqs];
]


(* ::Text:: *)
(*With the below code, you MUST ensure that all the lists are in the same order*)


pPL[namesList_, fastaFileList_, blastFileList_, assemblyHeadersToKeep_, assemblyTYPE_String(*either "TRINITY" or "1KITE"*)]:=
Table[
sequences=Import[fastaFileList[[i]], "Text"]//fastaParser;
blastIn=Import[blastFileList[[i]], "TSV"];
processProbedLoci[namesList[[i]], sequences, blastIn,assemblyHeadersToKeep, assemblyTYPE];


Export["t_"<>ToString[i]<>namesList[[i]]<>"_trashSeqs.txt",trashS];
Export[ToString[i]<>namesList[[i]]<>"_AHESeqs.txt",goodSeqs];

,{i, 1, Length[fastaFileList]}]


(* ::Subsection::Closed:: *)
(*Processing GUIDANCE2 outputs*)


(* ::Text:: *)
(*This function takes the ouput folders generated by GUIDANCE2 and renames the output files as appropriate.*)
(**)
(*First YOU MUST set the directory to the parent folder of the GUIDANCE2 outputs and then import the fileNames.*)
(**)


gUIDANCE2OutputParse[directory_]:=Module[{fileName, exportName, folderList},
SetDirectory[Directory[]<>"\\out"];
folderList=FileNames[];
SetDirectory[directory];
Table[

SetDirectory[Directory[]<>"\\out\\"<>folderList[[i]]];
fileName=Riffle[StringSplit[folderList[[i]], "_"][[{4, 5, 6}(*possible change depending upon how you craft the GUIDANCE2 output file*)]], "_" (*same as previous comment*)]//StringJoin;

If[MemberQ[FileNames[], "MSA.MAFFT.Without_low_SP_Col.With_Names"], 
Export[ParentDirectory[ParentDirectory[]]<>"\\fixed\\"<>fileName,
Import[Directory[]<>"\\"<>"MSA.MAFFT.Without_low_SP_Col.With_Names", "String"] ,"String"],
Export[exportName=ParentDirectory[ParentDirectory[]]<>"\\missed\\"<>fileName,
Import[Directory[]<>"\\"<>"Seqs.Orig.fas", "String"] ,"String"]
 ];
SetDirectory[ParentDirectory[ParentDirectory[]]];
, {i, 1, Length[folderList]}];
];


(*SetDirectory["D:\\Data_storage\\Guidance outputs"];
(*gUIDANCE2OutputParse["D:\\Data_storage\\Guidance outputs"]












(* ::Subsection::Closed:: *)
(*Masking alignment based on GUIDANCE2 residues*)


(* ::Text:: *)
(*Guidance2 outputs residual scores for alignment positions that can be used to mask the alignment, rather then masking the alignment itself. This function will take the input alignment and mask the positions.*)
(*	There are two functions below. For most applications you can just use the top one, which will map automatically onto the subfolders of the guidance output folder. It will also generate a spreadsheet with the masking meta-data. *)
(*	The default values for the two parameters are the same as the Guidance2 defaults. However, there is a condition in the script which says that if the first parameter masks too many sites, it will repeat with a less stringent cutoff. *)
(*	Note: My informal sensitivity analysis suggests that the cutoffRow value isn't necessarily a good guide for cutting out taxa. The ones I would cut out are different than the ones it does cut out. Also, this is highly dependant on the alignment shape. As such, I prefer to keep it low (~.5). Similarly, the cutoffNuc parameter doesn't need to be so high. It seems to cut out too much (also dependant on the alignment shape). A lower value (~.65) might be more appropriate. However, the condition of retaining a minimum of sites makes it so that you can keep the default pretty high.*)
(*	Parameters:*)
(*	outputDirectory = the directory which contains the folders that contain the Guidance2 outputs. Each of the subfolders should be named with the alignment name.*)
(*	cutoffNuc = the maximum residue score you will accept for a given nucleotide position. Higher value means more sites will be cut out. Lower value means you conserve more sites. Default = 0.93.*)
(*	cutoffRow = the maximum residue score you will accept for a given taxon. Higher value means more taxa will be cut out. Lower value means you conserve more taxa. Default = 0.6.*)


(*guidance2MaskAlign["F:\\Dropbox\\Projects\\Phylogeny of Blaberoidea\\Alignments\\orthographs + transcriptomes only targetted aligned and ends trimmed dec 2017\\Guidance outputs", .7, .5]*)


guidance2MaskAlign[outputDirectory_, cutoffNuc_, cutoffRow_ ]:=Block[{fn},
SetDirectory[outputDirectory];
fn=FileNames[];
metaData={};
(*{"AlignName", "AlignLength", "# taxa", "% nucs masked", "# nucs masked","% taxa masked", "# taxa masked"}*)
maskFromGuidance[#,cutoffNuc, cutoffRow]&/@fn;
Export["maskingMetaData.csv",Flatten[metaData, 1], "CSV"];
]


maskFromGuidance[outputDirectory_, cutoffNuc_, cutoffRow_]:=Block[{residualSheet, residualsUseful,alignment,newAlignment, rowResidualQuality, rowResidualSheet, residualsQuality,alignL,taxN,alignName,cutOffNuc},
cutOffNuc=cutoffNuc;


residualSheet=Import[Directory[]<>"\\"<>outputDirectory<>"\\MSA.MAFFT.Guidance2_res_pair_res.scr"];

rowResidualSheet=Import[Directory[]<>"\\"<>outputDirectory<>"\\MSA.MAFFT.Guidance2_res_pair_seq.scr"];

rowResidualSheet=rowResidualSheet[[2;;(Length[rowResidualSheet]-1)]];

If[MemberQ[residualSheet, "-nan"], Null;, residualsUseful=residualSheet[[2;;(Length[residualSheet]-1)]];Goto["skip"];];

residualsUseful=Flatten[Drop[
GatherBy[residualSheet[[2;;(Length[residualSheet]-1)]], #[[3]]&],1], 1];

Label["skip"];


(*deletes the columns with -nan*)
alignment=importAlignment[outputDirectory<>"\\MSA.MAFFT.aln.With_Names"];

rowResidualQuality=Extract[rowResidualSheet,Position[rowResidualSheet[[All,2]]/.x_/;x<cutoffRow->"Mask", "Mask"]];
(*above: identifies the rows with residual scores below the cutoff*)

Label["repeat"];
residualsQuality=Extract[residualsUseful,Position[residualsUseful[[All,3]]/.x_/;x<cutOffNuc->"Mask", "Mask"]];
(*identifies and extracts only those data entries with residues beneath the default Guidance2Cutoff score *)

newAlignment=alignment;
(*below: mask nucleotides*)
((newAlignment=ReplacePart[newAlignment,{#[[2]], 2}->StringReplacePart[newAlignment[[#[[2]], 2]], "?",{#[[1]],#[[1]] }]]);&/@residualsQuality);
alignL=newAlignment[[1, 2]]//StringLength;
taxN=newAlignment//Length;

Print[ToString[(((residualsQuality//Length)/(alignL*taxN))//N )*100]<>"% of nucleotides masked. "<> ToString[residualsQuality//Length]<>" total masked."];

(*below: mask species*)

(newAlignment=ReplacePart[newAlignment,{#[[1]], 2}->StringRepeat["?",alignL]];)&/@rowResidualQuality;

Print[ToString[rowResidualQuality//Length]<>" species masked. "<> ToString[taxN]<>" total spp."];
If[(alignL*taxN)-(residualsQuality//Length)<(120*taxN),cutOffNuc=cutOffNuc-.025;Print["...masked too much...repeating"]; Goto["repeat"];, Null;];
(*above: says that we should repeat the masking with a lower cutoff if it takes out too many nucleotides*)


Export[(alignName=Riffle[Drop[StringSplit[outputDirectory, "."],-1], "."]//StringJoin)<>".align", newAlignment//fastaOutput, "Text"];
metaData=Append[metaData, {{alignName, alignL, taxN, (((residualsQuality//Length)/(alignL*taxN))//N )*100, residualsQuality//Length,(((rowResidualQuality//Length)/taxN)//N)*100, rowResidualQuality//Length, cutOffNuc, cutoffRow}}];

];


maskFromGuidance[outputDirectory_]:=maskFromGuidance[outputDirectory, .93, .6];


(* ::Subsection::Closed:: *)
(*Making saturation plots*)


(* ::Subsubsection::Closed:: *)
(*Pairwise saturation plots i.e. 1:1 plots*)


(* ::Text:: *)
(*This function will make a single saturation plot from two genetic distance matricies (from PAUP).*)
(*correctedDistances - PAUP output of the corrected distance matrix*)
(*rawDistances -  PAUP output of the uncorrected distance matrix*)
(*locusName - the name of the locus*)
(*modelCorrection - the name of the model used for the corrected distances (e.g.JC, GTR)*)
(*toDelete - a list of taxon names to be excluded from the distance matrix.*)


saturationPlot[correctedDistances_List, rawDistances_List,locusName_,modelCorrection_String, toDelete_List]:=Block[{aa, bb, cDistances, rDistances,numToDrop},
(*delete rows that are part of the toDelete list of taxa*)
(*cDistances=( 
DeleteCases[
If[ContainsAny[#[[{1, 2}]],toDelete //Flatten], {}, #[[3]]]&/@correctedDistances
, {}]);*)
cDistances=deleteDistances[correctedDistances,toDelete];
rDistances=deleteDistances[rawDistances,toDelete];

(*plot=Show[
ListPlot[{(cDistances),(rDistances)}//Transpose//Rescale, PlotLabel\[Rule]modelCorrection<>" vs uncorrected distances: "<>locusName, PlotTheme\[Rule] "Scientific", Frame\[Rule]True, PlotStyle\[Rule]Orange , FrameLabel\[Rule]{modelCorrection<>" corrected", "Uncorrected"}, LabelStyle\[Rule]{"Corbel"},AspectRatio\[Rule]1, PlotRange\[Rule]{{0., 1.}, {0., 1.}}],
Plot[x, {x, 0, 100},PlotStyle\[Rule]{Dashed,Black}, PlotRange\[Rule]{{0., 1.}, {0., 1.}}]
];*)
plot=satPlot[{{(cDistances),(rDistances)}},modelCorrection, locusName ];
Export[locusName<>modelCorrection<>"_satPlot.PNG",plot,"PNG", ImageResolution->500];
]



(* ::Text:: *)
(*This is mostly a formatting function.*)
(*distancesList - needs to be a list of paired lists of the format:*)
(*	{{corrected distances1, raw distances1},*)
(*	{corrected distances2, raw distances2},*)
(*			...*)
(*	{corrected distancesN, raw distancesN}}*)


satPlot[distancesList_List, modelCorrection_, locusName_]:=Block[{cDistances, rDistances, dist},
dist=(#//Transpose)&/@distancesList;
Show[
ListPlot[dist, PlotLabel->modelCorrection<>" vs uncorrected distances: "<>locusName, PlotTheme-> "Scientific", Frame->True, PlotStyle->Orange , FrameLabel->{modelCorrection<>" corrected", "Uncorrected"}, LabelStyle->{"Corbel"},AspectRatio->1, PlotRange->{{0., 1.}, {0., 1.}}],
Plot[x, {x, 0, 100},PlotStyle->{Dashed,Black}, PlotRange->{{0., 1.}, {0., 1.}}]
]
]


(* ::Text:: *)
(*This code will prepare the data for the saturation plot.*)


prepForSat[distanceDirectory_,corrFileName_,rawFileName_,alignmentDirectory_,alignmentFile_]:=Block[{align,correctedDistances ,rawDistances},
SetDirectory[alignmentDirectory];
align=importAlignment[alignmentFile];
emptyTaxa=Complement[align[[All, 1]], deleteEmptySequences[align, .60][[All, 1]]];

SetDirectory[distanceDirectory];
correctedDistances=Import[corrFileName, "TSV"];
rawDistances=Import[rawFileName, "TSV"];
cDistances={StringReplace[correctedDistances[[All, 1]], " "->"_"], StringReplace[correctedDistances[[All, 2]], " "->"_"], correctedDistances[[All, 3]]}//Transpose;
rDistances= {StringReplace[rawDistances[[All, 1]], " "->"_"], StringReplace[rawDistances[[All, 2]], " "->"_"], rawDistances[[All, 3]]}//Transpose;
{cDistances, rDistances,alignmentFile,corrFileName,  emptyTaxa}
]


prepForSat[distanceDirectory_,corrFileName_,rawFileName_,alignmentDirectory_,alignmentFile_, taxonSpecFile_]:=Block[{align,correctedDistances ,rawDistances},
SetDirectory[alignmentDirectory];
align=importAlignment[alignmentFile];
emptyTaxa=Complement[align[[All, 1]], deleteEmptySequences[align, .60][[All, 1]]];
emptyTaxa2=Complement[align[[All, 1]], Import[taxonSpecFile,"TSV"]];

SetDirectory[distanceDirectory];
correctedDistances=Import[corrFileName, "TSV"];
rawDistances=Import[rawFileName, "TSV"];
cDistances={StringReplace[correctedDistances[[All, 1]], " "->"_"], StringReplace[correctedDistances[[All, 2]], " "->"_"], correctedDistances[[All, 3]]}//Transpose;
rDistances= {StringReplace[rawDistances[[All, 1]], " "->"_"], StringReplace[rawDistances[[All, 2]], " "->"_"], rawDistances[[All, 3]]}//Transpose;
{cDistances, rDistances,alignmentFile,corrFileName,  {emptyTaxa, emptyTaxa2}//Flatten}
]


(* ::Text:: *)
(*This code will delete the distances specified in delete list.*)


deleteDistances[distances_,toDelete_]:=DeleteCases[
ParallelMap[
If[
(MemberQ[toDelete //Flatten,#[[1]] ]||
MemberQ[toDelete //Flatten,#[[2]] ])
, {}, #[[3]]]&,distances]
, {}];


deleteDistances2[distances_,toDelete_]:=DeleteCases[
ParallelMap[
If[
(MemberQ[toDelete //Flatten,#[[1]] ]||
MemberQ[toDelete //Flatten,#[[2]] ])
, {}, #[[{1, 2,3}]]]&,distances]
, {}];
(*this version maintains the names in the list and is implimented in the branch length saturation plots*)


(* ::Subsubsection::Closed:: *)
(*Genetic distance vs. Tree distance plots*)


(* ::Text:: *)
(*The function below will create a saturation plot given two distance matricies and some formatting text.*)
(*geneticDistanceList - a PAUP formatted list of pairwise genetic distances*)
(*treeDistanceMatrix - an R (function cophenetic()) formatted matrix of pairwise tree distances*)
(*locusName - a string containing the name of the locus, this will be shown as the plot title*)
(*model - a string containing the name of the model which will be plotted on an axis*)
(**)
(*NOTE that the plots will end up weird if the genetic distances aren't formatted correctly, so make sure there aren't any invalid distances (resulting from missing data in the original matrix).*)


plotBranchSaturation[geneticDistanceList_, treeDistanceMatrix_, locusName_, model_]:=Block[{genDistA,genDistancesTaxa,genDistTaxaPositions,gDA, geneticDistancesAndPositions,lm},
(*this first part will take names from the genetic distance list and format the spaces as underlines, which is how R will output the names...this might be because of the way they are formatted in the tree file or it might be because of R. Note that trailing spaces in names (forinstance as with Mantoida_sp_) will mess this up so figure out which ones have that and fix them manually*)
(*genDistA={
ParallelMap[StringReplace[#, " "\[Rule]"_"]&,geneticDistanceList[[All, 1]]],
ParallelMap[StringReplace[#, " "\[Rule]"_"]&,geneticDistanceList[[All, 2]]],
geneticDistanceList[[All, 3]]
}//Transpose;*)
genDistA={
StringReplace[#, " "->"_"]&/@geneticDistanceList[[All, 1]],
StringReplace[#, " "->"_"]&/@geneticDistanceList[[All, 2]],
geneticDistanceList[[All, 3]]
}//Parallelize//Transpose;

(*this part extracts the names of all the taxa in the genetic distances list*)
genDistancesTaxa=DeleteCases[genDistA[[All, {1, 2}]]//Flatten//Union, {}];

(*this part makes a replacement list for all the names in the genetic distances list. this is important because we are going to construct the data by replacing the names with the corresponding distances*)
genDistTaxaPositions=ParallelMap[{#->Position[treeDistanceMatrix,# ][[1, 2]]}&,genDistancesTaxa];
(*row numbers of column numbers...they are the same*)
(*this function does the replacing. this will make the genetic distances list have coordinates instead of taxon names*)
gDA=(genDistA/.(genDistTaxaPositions//Flatten));
geneticDistancesAndPositions={#[[{1, 2}]], #[[3]]}&/@gDA;
(*this will put all the relevant tree distances in the x axis and all the relevant genetic distances in the y axis*)
data=ParallelMap[{treeDistanceMatrix[[#[[1, 1]], #[[1, 2]]]], #[[2]]}&,geneticDistancesAndPositions];
lm=LinearModelFit[data, x, x];

plot=Show[
ListPlot[data, PlotLabel->(locusName<>" "<>ToString[Normal[lm]]),
FrameLabel->{"Paired Tree Distance", model<>" genetic distance"},PlotTheme-> "Scientific", Frame->True, PlotStyle->Directive[Black, Opacity[0.1]],
PlotRange->{{0., 10}, {0., 1.}}(*All*)(*i need to include an option to delete outliers and change this to ALL*)],
Plot[lm [x],{x, 0, 100}, PlotStyle->Directive[Red, Thin]]
];
Export[locusName<>model<>"_satPlot.PNG",plot,"PNG", ImageResolution->500]
]


(* ::Subsection::Closed:: *)
(*Calculating rates with TIGER software*)


(* ::Text:: *)
(*The function below will fun TIGER to calculate the rate of all nucleotide positions in an alignment. There are three versions. You can specify a custom directory that the TIGER files are in, or you can use the default setting, which is the directory "C:\\BioSoftware\\dist" (where I have my copy of the TIGER files stored). You can also specify seperate input and output directories, or you can leave everything in one folder (untested).*)


(* ::Text:: *)
(*NOTE: that the output numbers in the .txt file are in order of the positions in the alignment, and that lower numbers indicate a faster evolutionary rate.*)


TIGER[inputDirectory_]:=TIGER[inputDirectory,"C:\\BioSoftware\\dist",inputDirectory]


TIGER[inputDirectory_,outDirectory_]:=TIGER[inputDirectory,"C:\\BioSoftware\\dist",outDirectory]


TIGER[inputDirectory_,runDirectory_,outDirectory_]:=Block[{fn},

SetDirectory[inputDirectory];
fn=FileNames[];
Block[{inputFile,outName},
inputFile=#;
outName=StringSplit[inputFile,"."][[1]];

CopyFile[inputDirectory<>"\\"<>inputFile,runDirectory <>"\\"<>inputFile];

Print[inputFile<>" starting at "<> DateString[]];

SetDirectory[runDirectory];
Run["tiger.exe -in "<>inputFile<>" > "<>outName<>".nex -rl "<>outName<>".txt"];

Print[inputFile<>" ... done"];

CopyFile[runDirectory<>"\\"<>outName<>".nex",outDirectory <>"\\"<>outName<>".nex"];
CopyFile[runDirectory<>"\\"<>outName<>".txt",outDirectory <>"\\"<>outName<>".txt"];

DeleteFile[runDirectory<>"\\"<>inputFile];
DeleteFile[runDirectory<>"\\"<>outName<>".nex"];
DeleteFile[runDirectory<>"\\"<>outName<>".txt"];

SetDirectory[inputDirectory];
]&/@fn

]


(* ::Subsection::Closed:: *)
(*Calculating pairwise distance with PAUP*)


(* ::Text:: *)
(*NOT WORKING 19-Jan-2018*)


(*SetDirectory["F:\\Dropbox\\Projects\\Phylogeny of Blaberoidea\\Alignments\\Ready to merge alignments Jan 2018\\Paup_in"];
fn=FileNames[];*)


(*newFileName=alignmentFileConverter[fn[[2]], 1, "Nexus"]*)


newFileName


(*Run["CALL paup "<>newFileName<>" 
;
DSet distance=GTR;
"]*)
