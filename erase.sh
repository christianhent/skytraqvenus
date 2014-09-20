#!/bin/bash
clear         
echo "Hi, $USER"
echo "."
echo "GPX logger erase script starts now"
echo "."

if gpsbabel -i skytraq,erase,baud=0,no-output -f /dev/ttyACM0; then
    echo "The usb logger was erased"
else
    echo "Something got wrong"
fi

echo "."
echo "GPX logger erase script ends now"
echo "."
echo "Bye"