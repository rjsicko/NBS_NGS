#!/bin/bash
# Runs on the host system, reading mails files from a directory
# and piping them to sendmail -t and then deleting them.
#
#adapted from https://serverfault.com/questions/631941/send-mail-from-docker-container-with-hosts-postfix

DIR="/var/www/analysis/watched/nys_nbs/mail"

if [ \! \( -d "$DIR" -a -w "$DIR" \) ]
then
  echo "Invalid directory given: $DIR"
  exit 1
fi

echo "`date`: Starting mailsender on directory $DIR"

cd $DIR

while :
do
  for file in `find . -maxdepth 1 -type f`
  do
    if [[ "$file" == *"warning_or_error"* ]];then
      echo "`date`: Sending $file"
      #sendmail -t < $file
      BODY=$(cat $file)
	  SYS_ADMIN_LIST="robert.sicko@health.ny.gov"
	  #mailx robert.sicko@health.ny.gov < $file
       echo -e "Subject:Archer Analysis Warning or Error\n${BODY}" | sendmail -f "v7Server" -t "${SYS_ADMIN_LIST}"
	  rm $file
    fi
    if [[ "$file" == *"analysis_done"* ]];then
      echo "`date`: Sending $file"
      #sendmail -t < $file
      EMAIL_LIST=$(head -1 "$file")
      BODY=$(tail -1 "$file")
      #echo "$BODY" | mailx -s "Archer Analysis complete" "$EMAIL_LIST"
      echo -e "Subject:Archer Analysis Complete\n${BODY}" | sendmail -f "v7Server" -t "${EMAIL_LIST}"
      rm $file
    fi
  done
  sleep 1
done