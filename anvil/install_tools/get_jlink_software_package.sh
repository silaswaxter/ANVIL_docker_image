#!/bin/bash
#####

#####
# Definitions
#####
SCRIPT_NAME=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "${SCRIPT_NAME}")

SILENT_FLAG=""

JLINK_SOFTWARE_FILENAME="JLink_Linux_x86_64.tgz"
JLINK_SOFTWARE_DOWNLOAD_URL="https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.tgz"

#####
# Includes (source other scripts)
#####
. ${SCRIPT_DIR}/curl_functions.sh
. ${SCRIPT_DIR}/print_functions.sh

#####
# Parse Passed Flags
#####
while test $# -gt 0; do
	case "$1" in
		-h|--help)
			echo "USAGE:    get_latest_gcc-arm-none-eabi.sh [OPTIONS]"
			echo "ABOUT:    tool for downloading toolchain from ARM official downloads and"
	  		echo "          retrieving latest version"
      		echo " "
      		echo "OPTIONS:"
      		echo "-h, --help            Show help"
			echo "-s,                   Execute silently;  will still print errors."
			echo " "
      		exit 0
      		;;
    	-s)
	  		SILENT_FLAG="true"
			shift
      		;;
    	*)
      		break
      		;;
	esac
done

#####
# Download Package
#####
print_conditionally "downloading latest jlink software..."
download_with_curl "${JLINK_SOFTWARE_FILENAME}" "${JLINK_SOFTWARE_DOWNLOAD_URL}" \
    "-d accept_license_agreement=accepted"
