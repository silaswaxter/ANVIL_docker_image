#!/bin/bash
#####

#####
# Definitions
#####
SCRIPT_NAME=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "${SCRIPT_NAME}")

SILENT_FLAG=""
VERSION_INPUT=""
VERSION_FORMATTED=""
OUTPUT_DIR="."
NAME_ONLY_FLAG="0"

#####
# Includes
#####
. ${SCRIPT_DIR}/curl_functions.sh
. ${SCRIPT_DIR}/print_functions.sh

#####
# Functions
#####
format_version_string () {
    local version_formatting_posixBRE_regexp="s/[v|V]\?\(7\)\.\?\(62\w*\)/V\1\2/p"  
    VERSION_FORMATTED=$(echo ${VERSION_INPUT} | sed -n ${version_formatting_posixBRE_regexp})
    return 0
}

get_jlink_software_download_url () {
    if [ -n "${VERSION_FORMATTED}" ]
    then
        echo "https://www.segger.com/downloads/jlink/JLink_Linux_${VERSION_FORMATTED}_x86_64.deb"
        return 0
    else
        echo "https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb"
        return 0
    fi
}

get_jlink_software_file_name () {
    if [ -n "${VERSION_FORMATTED}" ]
    then
        echo "${OUTPUT_DIR}/JLink_Linux_${VERSION_FORMATTED}_x86_64.deb"
        return 0
    else
        echo "${OUTPUT_DIR}/JLink_Linux_x86_64.deb"
        return 0
    fi
}


# Parse Passed Flags
while test $# -gt 0; do
	case "$1" in
		-h|--help)
			echo "USAGE:    get_jlink_software_package.sh [OPTIONS]"
			echo "ABOUT:    Downloads SEGGER's JLink software package.  Installs *.deb file"
      		echo " "
      		echo "OPTIONS:"
      		echo "-h, --help            Show help"
			echo "-s,                   Execute silently;  will still print errors."
      		echo "-o, -o <dir>          Output directory for jlink software package; default='./'"
            echo "                      (best to use absolute directory)"
            echo "-v, -v <version>      Select version of jlink software package."
            echo "                          <version> formatting:"
            echo "                          'V762b', 'V7.62b', 'v7.62b', 'v762b', '762b', '7.62b'"
            echo "--name-only           Prints only the filename of the jlink package that would"
            echo "                      be installed had this flag not been passed."
			echo " "
      		exit 0
      		;;
    	-s)
	  		SILENT_FLAG="1"
			shift
      		;;
    	-o)
      		shift
      		if test $# -gt 0; then
        		export OUTPUT_DIR=$1
      		else
        		echo "no output dir specified"
        		exit 1
      		fi
      		shift
      		;;
    	-v)
      		shift
      		if test $# -gt 0; then
        		export VERSION_INPUT=$1
                format_version_string
      		else
        		echo "no version specified"
        		exit 1
      		fi
      		shift
      		;;
    	--name-only)
            #only print filename
	  		SILENT_FLAG="1"

            NAME_ONLY_FLAG="1"

			shift
      		;;
    	*)
      		break
      		;;
	esac
done

# Name-Only Flag Operation
if [ ${NAME_ONLY_FLAG} -eq 1 ]
then
    get_jlink_software_file_name
    exit 0
fi

# Download Package
print_conditionally "Downloading jlink software package..."
download_with_curl "$(get_jlink_software_file_name)" "$(get_jlink_software_download_url)" \
    "-d accept_license_agreement=accepted"
