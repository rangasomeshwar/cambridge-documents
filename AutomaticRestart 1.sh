#for content server restart
USERNAME=dmadmin
PASSWORD=PiAbgm9pA3D9

file1=/home/dmadmin/ContentHost
today=(date +"%Y-%m-%d")
oneHourAgo=$(date +%Y-%m-%dT%H: -d '1 hour ago')
RestartText=""

echo  "Checking content server status on $ContentHost..."
for ContentHost in $(cat $file1)
do
if ! ssh -qn $ContentHost ./dctmContentServer status | grep -q "Content Server is active"
then
>/home/dmadmin/logs/dc10.log
  while read log
  do
    echo "dc10-$ContentHost $log" >> /home/dmadmin/logs/dc10.log
    ssh -qn $ContentHost grep ERROR "$log" | egrep "$oneHourAgo" >> /home/dmadmin/logs/dc10.log 2>&1
  done < /home/dmadmin/RestartPath
   echo "The content server $ContentHost is NOT running. Will restart."
   RestartText="${RestartText}     content server $ContentHost\n"
   echo "First we will kill any orphaned Documentum processes..."
   ssh -qn $ContentHost ps -fudmadmin | sed '1d' | egrep 'documentum|docbase' | awk '{ print $2 }' | xargs -r kill -9
   echo "Now clearing the Documentum cache folder..."
   ssh -qn $ContentHost 'rm -rf /opt/documentum/cache/*'
   echo "Starting Documentum services..."
   ssh -qn $ContentHost timeout 3m ./dctmContentServer start || echo ERROR - Command timed out.
  
fi
done
if ! ./dctmContentServer status | grep -q "Content Server is active"
then
>/home/dmadmin/logs/dc10-410.log
while read log
  do
    echo "dc10-uqscrap410 $log" >> /home/dmadmin/logs/dc10-410.log
     grep ERROR "$log" | egrep "$oneHourAgo" >> /home/dmadmin/logs/dc10-410.log 2>&1
  done < /home/dmadmin/RestartPath
  echo "The content server uqscrap410 is NOT running. Will restart."
    RestartText="${RestartText}     content server uqscrap410\n"
    echo "First we will kill any orphaned Documentum processes..."
    ps -fudmadmin | sed '1d' | egrep 'documentum|docbase' | awk '{ print $2 }' | xargs -r kill -9
   echo "Now clearing the Documentum cache folder..."
   rm -rf /opt/documentum/cache/*
   echo "Starting Documentum services..."
   timeout 3m ./dctmContentServer start || echo ERROR - Command timed out.
  
fi



#mail -s "Automatic Restart of lower environment OMR."-a /home/dmadmin/logs/omr.log saipriya.tingirkar@cambridge.org someshwar.ranga@cambridge.org < /home/dmadmin/logs/restart.log 
if [ -z "$RestartText" ]
then
   echo "All good - no restarts were done."
else
   printf "Services were found to be down on the following servers. All were restarted.\n\n${RestartText}" |\
   mail -s "The Scanning lower environments check found some stopped services and restarted them." \
 -a /home/dmadmin/logs/dc10.log \
 -a /home/dmadmin/logs/dc10-410.log \
  saipriya.tingirkar@cambridge.org someshwar.ranga@cambridge.org gowri.jaya@cambridge.org Preethika.Dhanabal@cambridge.org chagantipati.s@cambridgeassessment.org.uk shubham.saurabh@cambridge.org tharaka.chemakurthi@cambridge.org senthilkumar.a@cambridgeassessment.org.uk avdhesh.kumar2@cambridge.org
 
fi
rm -rf /home/dmadmin/logs/dc10.log
rm -rf /home/dmadmin/logs/dc10-410.log 
