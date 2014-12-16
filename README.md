# nimrodel

Roger Evans, University of Brighton<br/>
version 0.2  15 December 2014

nimrodel is a historical charter analysis engine based around the
DATR [ELF framework][elf].  It is derived from celeborn, the NLP
component of the ChartEx project Runs under Windows (tested with Windows
7) and Linux (tested with Ubuntu 11), and MacOS (tested with 10.9).

Output is in JSON format, as a flat list of dictionaries.

## Dependencies

* SWI-prolog version 6.6.1
* Java - a recent version (we use 1.7.0)

Either 32 or 64 bit versions will work, but you should use the same for
both.

## Installation

1.    Unpack the nimrodel zip file in a convenient place. For simplest
      installation in Linux or MacOS X, unpack it in ~/nimrodel

2.    Go to directory nimrodel-0.1/nimrodel/bin and look at the script
      local-example (linux) or local-example.bat (windows). The files
      show you the key variables nimrodel needs, along with their
      default settings. If the default settings are right, nimrodel
      should just run. If they are not right, copy the file to local (or
      local.bat) uncomment lines that need changing and edit them to the
      right values.

3.    Simple test by running 

          nimrodel/bin/nimrodel -help

4.    And the tool at work on an example input

          nimrodel/bin/nimrodel "Robert son of Thomas"

5.    Try batch mode out (substitute `/tmp` with `C:/Temp` on Windows)

          nimrodel/bin/nimrodel nimrodel/example /tmp/nimrodel-example

## Usage

The script `nimrodel/bin/nimrodel` (nimrodel.bat under Windows) is a
free-standing script for one-shot execution. It takes a single document
as a command line string, or reads from standard input, and produces
BRAT annotation output of the analysis

The script `nimrodel/bin/nimrodel-on-dir` (nimrodel-on-dir.bat)
likewise runs nimrodel on all the files nested at arbitrary depth
within a directory. The results are saved in the output directory with
filename and directory structure matching that of the input directory.

The script `nimrodel/bin/env` (env.bat) sets up the
environment for running nimrodel.  Under Linux/Mac you need to source
this script, not execute it (ie with the command 'source
nimrodel/bin/env').  Under Windows you can just execute it.
After you have run it, the other nimrodel commands will become directly
available (ie 'nimrodel' will just work), and you will be able to run
nimrodel directly from swi-prolog.

### Interactive mode

You can run nimrodel interactively with the following steps:

1. source the 'env' file as described above
2. start up swi-prolog (eg with the command `swipl`)
3. compile the prolog file '$NIMRODEL/nimrodel.pl'
4. use one of these prolog commands to run the system:

   * `nimrodel(String).`           % process String as a document
   * `nimrodel(Model, String).`    % process String using the named Model
   * `nimrodel([...]).`            % run nimrodel as if you had given these command line arguments

Interactive use is good for development, because there is a big delay the first time you run nimrodel 
(as it loads the openNLP resources), but subsequent runs are much quicker.

The main application source files are in $NIMRODEL/src

[elf]: https://github.com/datr-project/elf
