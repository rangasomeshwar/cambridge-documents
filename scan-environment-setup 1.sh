#!/bin/bash
################################################################################
#
#  Program:  scan-environment-setup.sh
#  Function: Find all servers for a given Scanning environment.
#            This script will be called from the scanning admin scripts to
#            find all the servers for a given environment.
#
#            The script should be called with:
#                arg1 = Scanning type, i.e. ICR, RM or OMR.
#                arg2 = Environment (PRD, PP1, PP2, QA1, QA2 or DEV)
#
#            The script should be called with the dot (.) command to ensure
#            that the variables set here will be in scope in the source script.
#
#            N.B. The definitions in this script should be kept up-to-date
#            in order for the other scripts to function correctly.
#
#-------------------------------------------------------------------------------
# MODIFICATION HISTORY
#
#  When        Who             Why
# ------------------------------------------------------------------------------
#  2022-03-03  E. Duffy        Original version.
#  2022-03-04  E. Duffy        Add details for ICR Scanning environment.
#  2022-03-09  E. Duffy        Change string lists to arrays;
#                              Add location (i.e. datacentre) of servers
#                              (for DR purposes).
#  2022-03-11  E. Duffy        Add code for dealing with datacentre
#                              (for the DR scripts).
#
################################################################################

type=$1; env=$2; datacentre=$3

# Prompt for arguments if not supplied.
while [ -z "$type" ]
do
    echo -n "Type of Scanning environment (OMR, RM or ICR): "
    read type
done

while [ -z "$env" ]
do
    echo -n "Environment (PRD, PP1, PP2, QA1, QA2, DEV): "
    read env
done

if [ "$DR" = "Y" ]
then
    while [ -z "$datacentre" ]
    do
        echo -n "Datacentre (SP or WC): "
        read datacentre
    done
    datacentre=$(echo $datacentre | tr [:lower:] [:upper:])
fi

scanning_environment=$(echo $type-$env | tr [:lower:] [:upper:])
printf "\nEnvironment $scanning_environment selected.\n"
if [ "$DR" = "Y" ]; then echo "Datacentre $datacentre selected."; fi
echo

case $scanning_environment in

# Production servers
RM-PRD)
  app_servers=(upscrap030 upscrap031 upscrap032 upscrap033 upscrap034)
  app_server_locations=(sp sp wc wc sp)
  content_servers=(upscrap010 upscrap011 upscrap012 upscrap013 upscrap014 upscrap015)
  content_server_locations=(sp wc sp wc sp wc)
  ;;

OMR-PRD)
  app_servers=(upscoap030 upscoap031 upscoap032 upscoap033)
  app_server_locations=(sp sp wc wc)
  content_servers=(upscoap010 upscoap011 upscoap012 upscoap013)
  content_server_locations=(sp wc sp wc)
  ;;

ICR-PRD)
  app_servers=(upicrap030 upicrap031 upicrap032 upicrap033)
  app_server_locations=(sp sp wc wc)
  content_servers=(upicrap010 upicrap011 upicrap012 upicrap013)
  content_server_locations=(sp wc sp wc)
  ;;

DC10-PRD)
  app_servers=(upscnap030 upscnap031 upscnap032 upscnap033 upscnap034)
  app_server_locations=(sp sp sp sp wc)
  content_servers=(upscnap010 upscnap011 upscnap012)
  content_server_locations=(sp sp sp sp wc)
  ;;


# PP2 servers
RM-PP2 | RM-UAT)
  app_servers=(urscrap730 urscrap731 urscrap732 urscrap733)
  app_server_locations=(sp sp wc wc)
  content_servers=(urscrap710 urscrap711 urscrap712 urscrap713 urscrap714)
  content_server_locations=(sp sp sp wc sp)
  ;;

OMR-PP2 | OMR-UAT)
#  app_servers=(urscoap730 urscoap731 urscoap732 urscoap733)
  app_servers=(urscoap730 urscoap731)
# app_server_locations=(sp wc sp wc)
  app_server_locations=(sp wc)
  content_servers=(urscoap710 urscoap711 urscoap712 urscoap713)
  content_server_locations=(sp wc sp wc)
  ;;

ICR-PP2)
  app_servers=(uricrap730 uricrap731 uricrap732 uricrap733)
  app_server_locations=(sp sp sp sp)
  content_servers=(uricrap710 uricrap711 uricrap712 uricrap713)
  content_server_locations=(sp sp sp wc)
  ;;

#DC10-PP2 | DC10-UAT)
#  app_servers=(urscnap73?)
#  app_server_locations=()
#  content_servers=(urscnap71?)
#  content_server_locations=()
#  ;;


# PP1 servers
RM-PP1)
  app_servers=(urscrap430 urscrap431)
  app_server_locations=(sp wc)
  content_servers=(urscrap410 urscrap411)
  content_server_locations=(sp wc)
  ;;

OMR-PP1)
  app_servers=(urscoap430 urscoap431)
  app_server_locations=(sp wc)
  content_servers=(urscoap410 urscoap411)
  content_server_locations=(sp wc)
  ;;

#ICR-PP1)
#  app_servers=(uricrap43?)
#  app_server_locations=()
#  content_servers=(uricrap41?)
#  content_server_locations=()
#  ;;

#DC10-PP1)
#  app_servers=(urscnap43?)
#  app_server_locations=()
#  content_servers=(urscnap41?)
#  content_server_locations=()
#  ;;


# QA2 servers
RM-QA2)
  app_servers=(uqscrap730 uqscrap731)
  app_server_locations=(sp wc)
  content_servers=(uqscrap710 uqscrap711 uqscrap712 uqscrap713)
  content_server_locations=(sp wc sp sp)
  ;;

OMR-QA2)
  app_servers=(uqscoap730 uqscoap731)
  app_server_locations=(sp wc)
# content_servers=(uqscoap710 uqscoap711 uqscoap712)
  content_servers=(uqscoap710 uqscoap711)
# content_server_locations=(sp wc sp)
  content_server_locations=(sp wc)
  ;;

#ICR-QA2)
#  app_servers=(uqicrap73?)
#  app_server_locations=()
#  content_servers=(uqicrap71?)
#  content_server_locations=()
#  ;;

#DC10-QA2)
#  app_servers=(uqscnap73?)
#  app_server_locations=()
#  content_servers=(uqscnap71?)
#  content_server_locations=()
#  ;;


# QA1 servers
RM-QA1)
  app_servers=(uqscrap430 uqscrap431)
  app_server_locations=(sp wc)
  content_servers=(uqscrap410 uqscrap411 uqscrap412 uqscrap413)
  content_server_locations=(sp wc sp wc)
  ;;

OMR-QA1)
  app_servers=(uqscoap430 uqscoap431)
  app_server_locations=(sp sp)
  content_servers=(uqscoap410 uqscoap411 uqscoap412 uqscoap413)
  content_server_locations=(sp sp sp wc)
  ;;

ICR-QA1)
  app_servers=(uqicrap430 uqicrap431 uqicrap432 uqicrap433)
  app_server_locations=(sp wc sp wc)
  content_servers=(uqicrap410 uqicrap411 uqicrap412 uqicrap413)
  content_server_locations=(sp wc sp sp)
  ;;

#DC10-QA1)
#  app_servers=(uqscnap43?)
#  app_server_locations=()
#  content_servers=(uqscnap41?)
#  content_server_locations=()
#  ;;


# Development servers
RM-DEV)
  app_servers=(udscrap030 udscrap031)
  app_server_locations=(sp sp)
  content_servers=(udscrap010 udscrap011 udscrap012)
  content_server_locations=(wc sp wc)
  ;;

#OMR-DEV)
#  app_servers=(udscoap03?)
#  app_server_locations=()
#  content_servers=(udscoap01?)
#  content_server_locations=()
#  ;;

ICR-DEV)
  app_servers=(udicrap030 udicrap031)
  app_server_locations=(sp wc)
  content_servers=(udicrap010 udicrap011)
  content_server_locations=(sp wc)
  ;;

DC10-DEV)
  app_servers=(udscnap030 udscnap031)
  app_server_locations=(sp wc)
  content_servers=(udscnap011 udscnap012)
  content_server_locations=(sp sp)
  ;;


*)
  echo "Invalid Environment or type. Aborted."
  exit 1
  ;;

esac
