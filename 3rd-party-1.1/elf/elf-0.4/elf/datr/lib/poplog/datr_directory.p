/* --- Copyright University of Sussex 1994. All rights reserved. ----------
 > File:            $poplocal/local/auto/datr_directory.p
 > Purpose:         definition of root of DATR tree
 > Author:          Roger Evans, Mar 29 1993
 > Related files:   lib datr_subsystem, lib datr_compile
 > RCS data:        $Id: datr_directory.p 1.4 1997/12/22 23:33:22 rpe Exp $
 */

/*  datr_directory is an active variable that shadows the definition of
    the environment variable $DATR.

    This library sets datr_directory both when it is loaded and at runtime
    (which will be different if pop_runtime is false), so that different
    values for $DATR at image build time and runtime are supported.

    If $DATR is not defined, it (and datr_directory) is set to a default
    value established by the 'install_datr' script (q.v.)

    Note: most of the actual references in the code are to $DATR rather than
    datr_directory (since sysfileok does a dynamic translation automatically)
    - the active var is really just a possibly useful spinoff.
*/


compile_mode :pop11 +strict;

section;

include datr;

/*  datr_directory - just a wrapper on systranslate */
define global active datr_directory;
    systranslate(datr_env_name);
enddefine;

define updaterof active datr_directory;
    -> systranslate(datr_env_name);
enddefine;

/*  Set_DATR - utility to initialise datr_directory if necessary */
define lconstant Set_DATR;
    unless datr_directory then

        /*  the following test will succeed only if the definition in
            datr.ph has not been modified by the ____________install_datr script
        */
        if datr_default_dir = 'DATR_DIR_UNDEFINED' then
            mishap(0,'No value for $DATR (install_datr not run?)');
        endif;

        datr_default_dir -> datr_directory;
    endunless;
enddefine;

/*  set datr_directory now, and also at runtime if necessary, since
    env vars don't get saved in saved images etc.
*/
Set_DATR();
unless pop_runtime then
    sys_runtime_apply(Set_DATR);
endunless;

endsection;
