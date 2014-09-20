#!/bin/bash

SCRIPT=${0##*/}
Usage="$SCRIPT: [-c] [-p] [-t arg1 arg2 arg3] [-x arg] or [-h] for help"

show_help() {
cat << EOF

Downloads and converts data from loggers with Skytrak Venus chipset
to GPX XML files. GPSBabel 1.3 or later is required.

Usage: $Usage
	
	-h     display this help and exit

	-c     get data based on configuration values

	-p     get data while trackpoints are bad ordered, aka:
	       the no panic! mode

	-t     get data based on a time range, example:
	       ./export.sh -t 'the title' 201409190600 201409201800

	-x     get only data from same day, example:
	       ./export.sh -x 'the title'

EOF
}

show_error_msg() {
	echo "Something got wrong, the gpx file was not created."
}

show_success_msg() {
	echo "The gpx file $fname.gpx was created!"
}

if ( ! getopts "cptxh" opt); then
	echo "$Usage";
 	exit $E_OPTERROR;
fi

while getopts ":cpt:x:h" opt
do  sc=0
    case $opt in
    (h)
    	show_help >&2
        exit 0
        ;;
    (c)
        fname="$(date +'%Y%m%d_%H%M%S%2N')"
        if gpsbabel -p 'config.ini' -t -r -w -i skytraq -f /dev/ttyACM0 -x track -x nuketypes,routes -o gpx -F data/"$fname".gpx; then
        	show_success_msg >&2
        else
        	show_error_msg >&2
        fi
        ;;
    (p)
        fname="$(date +'%Y%m%d_%H%M%S%2N')"
        if gpsbabel -p 'config.ini' -r -w -i skytraq -f /dev/ttyACM0 -x nuketypes,routes,waypoints -o gpx -F data/"$fname".gpx; then
        	show_success_msg >&2
        else
        	show_error_msg >&2
        fi
        ;;
    (x)
        fname="$(date +'%Y%m%d_%H%M%S%2N')"
        start="$(date +'%Y%m%d')"0600
        stop="$(date +'%Y%m%d')"2200
        title=$OPTARG
        if gpsbabel -p 'config.ini' -t -r -w -i skytraq -f /dev/ttyACM0 -x track,title="$title",start="$start",stop="$stop" -x nuketypes,routes,waypoints -o gpx -F data/"$fname".gpx; then
        	show_success_msg >&2
        else
        	show_error_msg >&2
        fi
        ;;
    (t)
        if [ $# -lt $((OPTIND + 1)) ]
        then    echo "$IAM: Option -t is missing argument(s): needs 3 arguments" >&2
                echo "$Usage" >&2
                exit 2
        fi
        OPTINDplus1=$((OPTIND + 1))
        eval start=\$$OPTIND
        eval stop=\$$OPTINDplus1
        fname="$(date +'%Y%m%d_%H%M%S%2N')"
        title=$OPTARG
        if gpsbabel -p 'config.ini' -t -r -w -i skytraq -f /dev/ttyACM0 -x track,title="$title",start="$start",stop="$stop" -x nuketypes,routes,waypoints -o gpx -F data/"$fname".gpx; then
        	show_success_msg >&2
        else
        	show_error_msg >&2
        fi
        #
        sc=2
        ;;
    (\?)echo "$IAM: Invalid option: -$OPTARG" >&2
        echo "$Usage" >&2
        ;;
    (:) echo "$IAM: Option -$OPTARG is missing argument(s)" >&2
        echo "$Usage" >&2
        exit 1
        ;;
    esac
    if [ $OPTIND != 1 ]                  
    then    shift $((OPTIND - 1 + sc))
            OPTIND=1
    fi
done