/*	Java wrapper for ELF, using SWIprolog/Jpl

	Requires env vars as follows:
		set SWI_HOME_DIR=c:\Program Files\swipl
		set PATH=%SWI_HOME_DIR%\bin;%PATH%
		set CLASSPATH=.;%SWI_HOME_DIR%\lib\jpl.jar
		
	Also expects ELFAPP to be set, or assumes current directory
*/

import java.util.Hashtable;
import jpl.*;
import jpl.Query;

public class Stemmer
{
	private static boolean initialized = false;
	public static void initialize() {
		if (! initialized) {
			String[] args = JPL.getDefaultInitArgs();
			String[] newargs = new String[args.length+1];
			newargs[0] = args[0];
			newargs[1] = "-q";
			System.arraycopy(args, 1, newargs, 2, args.length-1);
			JPL.setDefaultInitArgs(newargs);
			JPL.init();
			String elfapp = System.getenv("ELFAPP");
			Compound t1 = new Compound("consult", new Term[] { new Atom("swiprolog.pl") });
			if (elfapp != null) {
				Compound t2 = new Compound("working_directory", new Term[] { 
					new Variable(),
					new Atom(elfapp)
				});
				t1 = new Compound(",", new Term[] { t2, t1});
			}		
			Query q1 = new Query(t1);
			q1.hasSolution();
			
			initialized = true;
		}
	}
	
	public static void
	main( String argv[] )
	{

		Stemmer.initialize();
		
		String[] newargs = new String[argv.length+1];
		newargs[0] = "arglist";
		System.arraycopy(argv, 0, newargs, 1, argv.length);
		Query s = new Query(new Compound("datr_query", new Term[] {
			new Atom("app.MAIN"),
			Util.stringArrayToList(newargs),
			new Variable()
		}));		
		s.hasSolution();
		
	}

}


