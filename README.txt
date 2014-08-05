nimrodel 0.1 README
Roger Evans, University of Brighton
version 0.1  4 August 2014

nimrodel is a historical charter analysis engine based around the DATR ELF framework
It is dervied from celeborn, the NLP component of the ChartEx project 
Runs under Windows (tested with Windows 7) and linux (tested with Ubuntu 11)
Output is in the form of BRAT annotation data

Dependencies
	SWI-prolog version 6.6.1, 32 bit
	Java - a recent version (we use 1.7.0), 32 bit
	
	(NB: 64 bit versions work too but you have to make sure everything is 64 bit)
	
Installation
	Unpack the nimrodel zip file in a convenient place. For simplest installation in linux, 
	unpack it in ~/nimrodel
	
	Go to directory nimrodel-0.1/nimrodel/bin and look at the script local-example (linux) or 
	local-example.bat (windows). The files show you the key variables nimrodel needs, along with 
	their default settings. If the default settings are right, nimrodel should just run. If they 
	are not right, copy the file to local (or local.bat) uncomment lines that need changing
	and edit them to the right values.
	
	Simple test by running 
		nimrodel-0.1/nimrodel/bin/nimrodel -help

Usage
	The script nimrodel-0.1/nimrodel/bin/nimrodel (nimrodel.bat under windows) is a free-standing 
	script for one-shot execution. It takes a single document as a command line string, or reads from 
	standard input, and produces BRAT annotation output of the analysis
	
	The script nimrodel-0.1/nimrodel/bin/env (env.bat) sets up the environment for running nimrodel.
	Under linux you need to source this script, not execute it (ie with the command 
	'. nimrodel-0.4/nimrodel/bin/env'). Under windows you can just execute it. After you have run it, 
	the other nimrodel commands will become directly available (ie 'nimrodel' will just work), and 
	you will be able to run nimrodel directly from swi-prolog.
	
	The script nimrodel-all runs nimrodel on all the files given as arguments, or all the files matching
	'*.txt' in the current directory if no arguments are given. Filenames should end in '.txt', and output
	will be created in corresponding BRAT annotaition files, ending '.ann'.
	
	You can run nimrodel interactively with the following steps:
		source the 'env' file as described above
		start up swi-prolog (eg with the command 'swipl')
		compile the prolog file '$NIMRODEL/nimrodel.pl'
		use one of these prolog commands to run the system:
			nimrodel(String).			% process String as a document
			nimrodel(Model, String).	% process String using the named Model
			nimrodel([...]).			% run nimrodel as if you had given these command line arguments
	Interactive use is good for development, because there is a big delay the first time you run nimrodel 
	(as it loads the openNLP resources), but subsequent runs are much quicker.
	
	The main application source files are in $NIMRODEL/src 
	
Change log

nimrodel 0.1	4/8/14
	Base version of nimrodel - this is in fact just celeborn 0.8 with a global substitute 
	celeborn -> nimrodel
