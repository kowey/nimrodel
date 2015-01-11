# nimrodel

Roger Evans, University of Brighton<br/>
version 0.3  11 January 2015

Nimrodel is a historical charter analysis engine based around the
DATR [ELF framework][elf].  It is derived from celeborn, the NLP
component of the ChartEx project. 

Nimrodel runs under Windows (tested with Windows 7), Linux 
(tested with Ubuntu 11) and MacOS (tested with 10.9). References 
to Linux below also apply to MacOS.

Note: command line support for Windows vs Linux are out of sync.
The Linux version (with saved state management for faster startup, and
support for multi-core batch processing) is the most up to date, and 
is recommended. The Windows support will be brought in line in a future 
release. (The underlying nimrodel system itself is platform independent.)

Default output is in JSON format, as a flat list of dictionaries, one
per person entity found. 

## Dependencies

* SWI-prolog version 6.6.4 or later (we use 6.6.6) (NB: make sure your 
  SWI-prolog comes with the JPL package installed - on Linux we recommend 
  building from source)
* Java - a recent version (we use 1.7.0)

Either 32 or 64 bit versions will work, but you should use the same for
both packages.

## Installation from zip file

1.    Unpack the nimrodel zip file in a convenient place. For simplest
      installation in Linux or MacOS X, unpack it in ~/nimrodel

2.    Skip to "Installation common"


## Installation from Git

1.    Clone this repository

2.    Fetch the elf submodule

          cd nimrodel
          git submodule update --init

3.    Skip to "Installation common"


## Installation common

1.    Go to directory to the `bin` directory in nimrodel
      and look at the script local-example (linux) or local-example.bat
      (windows). The files show you the key variables nimrodel needs, 
	  along with their default settings. If the default settings are right, 
	  nimrodel should just run. If they are not right, copy the file to 
	  local (or local.bat) uncomment lines that need changing and edit them 
	  to the right values.

2.    If `JAVA_HOME` is not in your environment, copy
      `bin/local-example` to `bin/local` and set it there.

3.    Simple test by running

          bin/nimrodel -help
		  
	  (under Linux, on first run, this will rebuild the nimrodel saved state.)

4.    Test the tool at work on an example input

          (Linux)       bin/nimrodel string "Robert"
          (Windows)     bin\nimrodel "Robert"
	
	  which will return:
	  
			[ {
			 "id":"T1",
			 "origOccurrence":"Robert",
			 "forename":"robert",
			 "gender":"male",
			 "number":"sing",
			} ]

## Usage

### Linux

The script `nimrodel/bin/nimrodel` is a free-standing script which 
provides several modes for using nimrodel. Typing `nimrodel -help`
gives the following usage description:

	Usage:
		nimrodel string [-model <model>] [-language <lang>] [-title <title>] [-format <format>] [<doc>]
			Process document from standard input or string argument <doc>.
			<model> is processing model, <lang> is the document language,
			<title> is document title string (if omitted, use document first line)
			<format> is the output format - default is json, but brat (brat annotation)
			and dump (internal semantic format) are also possible
			Default model, language and format can be set in ./nimrodel-params.dtr file.

		nimrodel dir [<flags>] <input-dir> <output-dir>
			Process files nested in the input directory (arbitrary depth), and
			results to equivalent path in the output dir
			<flags> are as above

		nimrodel parallel-dir [<flags>] <jobs> <input-dir> <output-dir>
			Like dir, but assume input-dir is divided into subdirectories, and process
			them in parallel. (Linux/Mac only, needs GNU parallel)

		nimrodel selftest
			Run a self unit test suite

		nimrodel -version         print system version
		nimrodel -help            print this message

The script `nimrodel/bin/env` sets up the environment for running nimrodel.  
Under Linux  you need to source this script, not execute it (ie with the 
command `. nimrodel/bin/env`).  Under Windows you can just execute it.
After you have run it, the other nimrodel commands will become directly
available (ie `nimrodel` will just work), and you will be able to run
nimrodel directly from swi-prolog.

### Windows

(This is the old interface and will be replaced with the linux version in 
future releases.)

* `nimrodel/bin/env` - set up environment for running nimrodel (in Windows
   you run this as a commnad, rather than sourcing it)
* `nimrodel/bin/nimrodel "<string>"`  - run nimrodel on the given string
* `nimrodel/bin/nimrodel < <file> - run nimrodel on document provided in 
  <file> (or standard input if no file provided)
* `nimrodel/bin/nimrodel-all` - run nimrodel on all the *.txt files in the
  current folder, producing *.ann files for each text file.
  
The command-line flags (-model, -language, -format, -title) can also be used 
with these commands (see above).

### Interactive mode

You can run nimrodel interactively with the following steps:

1. source the 'env' file as described above
2. start up swi-prolog (eg with the command `swipl`)
3. compile the prolog file '$ELFAPP/nimrodel.pl'
4. use one of these prolog commands to run the system:

   * `nimrodel(String).`           % process String as a document
   * `nimrodel(Model, String).`    % process String using the named Model
   * `nimrodel([...]).`            % run nimrodel as if you had given these command line arguments

Interactive use is good for development, because there is a big delay the first time you run nimrodel 
(as it loads the openNLP resources), but subsequent runs are much quicker.

The main application source files are in $NIMRODEL/src

### Postprocessing

The script `nimrodel\bin\postprocess` takes a single directory name argument (usually the `output` 
directory of a dataset) and collects up all the output files within it (recursively) into a single json
file (on standard output), sorted in order of the appearanceDate property.


[elf]: https://github.com/datr-project/elf
