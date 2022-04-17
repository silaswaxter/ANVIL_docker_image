#!/bin/bash
##########
# DESC:
#       Contains print functions(s) for conditionally printing output to command line based on
#       global SILENT_FLAG variable.
# NOTES:
# AUTHOR:   Silas Waxter (silaswaxter@gmail.com)
# DATE:		04/14/2022
##########
if [ -z "${PRINT_FUNCTIONS_INCLUDED}" ]
then
    PRINT_FUNCTIONS_INCLUDED="true"

    # FUNCTION:	Print output of message if and only if SILENT_FLAG=0 (false)
    # ARG1:		message
    print_conditionally () {
        SILENT_FLAG=${SILENT_FLAG:=0}
        if [ ${SILENT_FLAG} -eq 0 ]
        then
            echo -e $1
        fi
    }

# header guard: PRINT_FUNCTIONS_INCLUDED
fi
