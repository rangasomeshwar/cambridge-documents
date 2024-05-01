
#for tomcat server restart
file2=/home/tomcat/TomcatHost
oneHourAgo=$(date +%Y-%m-%dT%H: -d '1 hour ago')
RestartText=""

for TomcatHost in $(cat $file2)
do
echo "Checking tomcat status on $TomcatHost..."
if ! ssh -qn $TomcatHost sudo systemctl status tomcat | grep 'Active: active'
then
>/home/tomcat/logs/errors.log

  while read log
  do
    echo "appserver-$TomcatHost $log" >> /home/tomcat/logs/errors.log
    ssh -qn $TomcatHost grep ERROR "$log" | egrep "$oneHourAgo" >> /home/tomcat/logs/errors.log 2>&1
  done < /home/tomcat/logPathRes

  echo "Tomcat is NOT running. Will restart."
  RestartText="${RestartText}     app server $TomcatHost\n"
  echo "First we will kill any orphaned Tomcat processes..."
  ssh -qn $TomcatHost "ps -futomcat | sed '1d' | egrep 'jsvc' | awk '{ print $2 }' | xargs -r kill -9"
  echo "Now clearing the Tomcat cache folders..."
  ssh -qn $TomcatHost "rm -rf /opt/tomcat/work/* /opt/tomcat/temp/* /opt/tomcat/bin/documentum/cache/* /opt/documentum/cache/*"
  echo "Starting Tomcat service..."
  ssh -qn $TomcatHost "timeout 3m sudo systemctl start tomcat || echo ERROR - Command timed out"
fi
done
echo "check status of uqscrap430"
if ! systemctl status tomcat | grep 'Active: active'
then
>/home/tomcat/logs/errors2.log

  while read log
  do
    echo "appserver-uqscrap430 $log" >> /home/tomcat/logs/errors2.log
    grep ERROR "$log" | egrep "$oneHourAgo" >> /home/tomcat/logs/errors2.log 2>&1
  done < /home/tomcat/logPathRes
  echo "Tomcat is NOT running in uqscrap430. Will restart."
  RestartText="${RestartText}     app server uqscrap430\n"
  echo "First we will kill any orphaned Tomcat processes..."
  ps -futomcat | sed '1d' | egrep 'jsvc' | awk '{ print $2 }' | xargs -r kill -9
  echo "Now clearing the Tomcat cache folders..."
  rm -rf /opt/tomcat/work/* /opt/tomcat/temp/* /opt/tomcat/bin/documentum/cache/* /opt/documentum/cache/*
  echo "Starting Tomcat service..."
  timeout 3m sudo systemctl start tomcat || echo ERROR - Command timed out
fi

if [ -z "$RestartText" ]
then
   echo "All good - no restarts were done."
else
#  Restarts were performed. Mail details about what was restarted to the appropriate people.
   printf "Services were found to be down on the following servers. All were restarted.\n\n${RestartText}" |\
   mail -s "The Scanning lower environments check found some stopped services and restarted them." \
 -a /home/tomcat/logs/errors.log \
 -a /home/tomcat/logs/errors2.log \
  saipriya.tingirkar@cambridge.org someshwar.ranga@cambridge.org gowri.jaya@cambridge.org Preethika.Dhanabal@cambridge.org chagantipati.s@cambridgeassessment.org.uk shubham.saurabh@cambridge.org tharaka.chemakurthi@cambridge.org senthilkumar.a@cambridgeassessment.org.uk avdhesh.kumar2@cambridge.org
fi
rm -rf /home/tomcat/logs/errors.log
rm -rf /home/tomcat/logs/errors2.log 


