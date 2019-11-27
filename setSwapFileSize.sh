#!/bin/bash
# Copyright (c) 2019 Jetsonhacks 
# MIT License
# Set the zram swap file size on Jetson Nano
# Default is 2GB 


function usage
{
    echo " usage: ./setSwapFileSize [ [-g #gigabytes ] | [ -m #megabytes ] | [ -h ]"
    echo "   -g #gigabytes - #gigabytes total to use for swap area"
    echo "   -m #megabytes - #megabytes total to use for swap area"
    echo "   -h | --help  This message"
}

# Iterate through command line inputs
if [ "$#" -gt 2 ] || [ "$#" == 0 ]  ; then
   usage
   exit 1
fi
MEGABYTES=""
while [ "$1" != "" ]; do
    case $1 in
        -g  )      
				MEGABYTES=1000
                                ;;
        -m )       
                                MEGABYTES=1
                                ;;

         ( *[!0-9]* | *[0-9] )
                                MEGABYTES=$((MEGABYTES*$1))
                                if [ $MEGABYTES == 0 ] ; then
                                   echo "Please specify a number > 0"
                                   usage
                                   exit 1
				fi
				;;

        -h | --help )           usage
                                exit
                                ;;
      
        * )                     echo "test"
				usage
                                exit 1
                                ;;
    esac
   shift
done
REQUESTED_BYTES=$(($MEGABYTES/4*1024))
# The configuration file is here:
CONFIG_FILE=/etc/systemd/nvzramconfig.sh

if [ -f $CONFIG_FILE ] ; then
  # we replace the memory request with the desired outcome
  sudo sed '/^mem=/c\mem='"$REQUESTED_BYTES"'' $CONFIG_FILE
  echo "Please reboot for changes to take effect."
else
  echo "The swap configuration file does not exist."
  echo "Unable to configure swap memory"
fi

