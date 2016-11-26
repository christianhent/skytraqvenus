#!/bin/bash

SCRIPT=${0##*/}
Usage="$(tput setaf 2)$SCRIPT: [-b] [-c] [-d] [-t arg1 arg2 arg3] [-v] [-x arg] or [-h] for help$(tput sgr 0)"
Version="1.2.1"

show_help() {
cat << EOF

Skytraq GPX manager downloads and converts data from loggers
with Skytrak Venus chipset. Also able to remove data.

$(tput setaf 2)GPSBabel 1.3 or later is required.$(tput sgr 0)

Usage: $Usage

	$(tput setaf 2)-b$(tput sgr 0)     get data while trackpoints are bad ordered

	$(tput setaf 2)-c$(tput sgr 0)     get data based on configuration values

	$(tput setaf 2)-d$(tput sgr 0)     delete all logged data

	$(tput setaf 2)-t$(tput sgr 0)     get data based on a time range, example:
	       $(tput setaf 2)./skytraq.sh -t 'the title' 201409190600 201409201800$(tput sgr 0)

	$(tput setaf 2)-v$(tput sgr 0)     show version of this script

	$(tput setaf 2)-x$(tput sgr 0)     get only data from same day, example:
	       $(tput setaf 2)./skytraq.sh -x 'the title'$(tput sgr 0)

	$(tput setaf 2)-h$(tput sgr 0)     display this help

EOF
}

show_version(){
    echo "Skytraq GPX manager $Version"
}

show_export_error_msg() {
    echo "$(tput setaf 1)Something got wrong, the gpx file was not created.$(tput sgr 0)"
}

show_export_success_msg() {
	echo "$(tput setaf 2)The gpx file $fname.gpx was created!$(tput sgr 0)"

}

show_delete_success_msg() {
    echo "$(tput setaf 2)All logged data was deleted.$(tput sgr 0)"
}

show_delete_error_msg() {
    echo "$(tput setaf 1)Something got wrong, the logged data was not deleted.$(tput sgr 0)"
}

if ( ! getopts "cbtxdhv" opt); then
	echo "$Usage";
 	exit $E_OPTERROR;
fi

while getopts ":cbdvt:x:h" opt
do  sc=0
    case $opt in
    (h)
    	show_help >&2
        exit 0
        ;;
    (v)
        show_version >&2
        exit 0
        ;;
    (c)
        fname="$(date +'%Y%m%d_%H%M%S%2N')"
        if gpsbabel -p 'config.ini' -t -r -w -i skytraq -f /dev/skytraq -x track -x nuketypes,routes -o gpx -F data/"$fname".gpx; then
        	show_export_success_msg >&2
        else
        	show_export_error_msg >&2
        fi
        ;;
    (b)
        fname="$(date +'%Y%m%d_%H%M%S%2N')"
        if gpsbabel -p 'config.ini' -w -i skytraq -f /dev/skytraq -o gpx -F data/"$fname".gpx; then
        	show_export_success_msg >&2
        else
        	show_export_error_msg >&2
        fi
        ;;
    (d)

        if gpsbabel -i skytraq,erase,no-output -f /dev/skytraq; then
            show_delete_success_msg >&2
        else
            show_delete_error_msg >&2
        fi
        ;;
    (x)
        fname="$(date +'%Y%m%d_%H%M%S%2N')"
        start="$(date +'%Y%m%d')"0600
        stop="$(date +'%Y%m%d')"2200
        title=$OPTARG
        if gpsbabel -p 'config.ini' -t -r -w -i skytraq -f /dev/skytraq -x track,title="$title",start="$start",stop="$stop" -x nuketypes,routes -o gpx -F data/"$fname".gpx; then
        	show_export_success_msg >&2
        else
        	show_export_error_msg >&2
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
        if gpsbabel -p 'config.ini' -t -r -w -i skytraq -f /dev/skytraq -x track,title="$title",start="$start",stop="$stop" -x nuketypes,routes,waypoints -o gpx -F data/"$fname".gpx; then
        	show_export_success_msg >&2
        else
        	show_export_error_msg >&2
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
