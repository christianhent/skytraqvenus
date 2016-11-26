#Skytraq GPX Manager#

Skytraq GPX manager downloads and converts data from loggers
with Skytrak Venus chipset. Also able to remove data. [GPSBabel](http://www.gpsbabel.org) 1.3 or later is required.

![Screenshot](https://github.com/christianhent/skytraqvenus/blob/master/skytraq.png?raw=true)

##Usage##

   ./skytraq.sh [-b] [-c] [-d] [-t arg1 arg2 arg3] [-v] [-x arg] or [-h] for help

##Options and Arguments##

__-b__

get data while trackpoints are bad ordered

 ./skytraq.sh -b

__-c__

get data based on configuration values

 ./skytraq.sh -c

 __-d__

 delete all logged data from the logger

  ./skytraq.sh -d

__-t__

get data based on a time range

 ./skytraq.sh -t 'the title' 201409190600 201409201800

_requires three arguments_ : `string` `datetime` `datetime`

__-v__

show version of this script

 ./skytraq.sh -v

__-x__

get only data from same day

 ./skytraq.sh -x 'the title'

_requires one argument_ : `string`

##Configuration##

GPSBabel will look for a file named _config.ini_ containing preferences. The format of the file is identical to the inifile-format often seen on Windows. To learn more about the config options, read the [GPSBabel documentation](http://www.gpsbabel.org/htmldoc-development/all_options.html).

##GPX files##

The used GPX specification is version __1.1__. If needed, edit the `config.ini` file to change this preference for using version 1.0 of the specification. The names of the generated `.gpx` files are unique and based on timestamps. Output tested with follow sports trackers and gpx tools: endomondo.com - strava.com - [leaflet.gpx plugin](https://github.com/mpetazzoni/leaflet-gpx) - [zatracks Joomla plugin](https://github.com/christianhent/plg_content_zatracks).
