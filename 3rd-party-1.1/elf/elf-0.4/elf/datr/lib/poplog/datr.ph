/* --- Copyright University of Sussex 1994. All rights reserved. ----------
 > File:            $poplocal/local/include/datr.ph
 > Purpose:         Header file for DATR subsystem
 > Author:          Roger Evans, Mar 29 1994
 > Documentation:   HELP datr
 > Related Files:   lib datr_compile, $DATR/...
 > RCS data:        $Id: datr.ph 1.7 1997/11/23 21:01:15 rpe Exp $
 */

#_TERMIN_IF DEF DATR_INCLUDED   /* don't reload if alread loaded */


/*  datr_default_dir - default directory for DATR code.
    the correct value of this constant is edited into this file
    when the ____________install_datr script is run */
iconstant
    datr_default_dir    = 'DATR_DIR_UNDEFINED';


iconstant
    datr_env_name       = 'DATR',         /* name of env var for DATR system */
    datr_file_type      = '.dtr',                   /* suffix for DATR files */
    datr_prompt         = '== ',               /* prompt for interactive use */
    datr_reset_string   = '\nDATR reset\n\n',            /* message on reset */
;

iconstant DATR_INCLUDED = true;
