#!/bin/bash
# Make sure that /var/lasrc_aux is a mountpoint
echo "Checking mount status"
mount | grep -q /var/lasrc_aux || exit 1
cd /var/lasrc_aux/ || exit 1
ls 
df -h
if [ -n "$LAADS_BUCKET_BOOTSTRAP" ]; then
  echo "Syncing existing laads data from aws s3 bucket s3://$LAADS_BUCKET_BOOTSTRAP/lasrc_aux/"
  aws s3 sync "s3://$LAADS_BUCKET_BOOTSTRAP/lasrc_aux/" .
fi

if [ ! -d LADS/2013 ]; then
  echo "Archived data not here... fetching 2013-2017 data from USGS."
  wget --no-http-keep-alive http://edclpdsftp.cr.usgs.gov/downloads/auxiliaries/lasrc_auxiliary/lasrc_aux.2013-2017.tar.gz
  tar -xvzf lasrc_aux.2013-2017.tar.gz
  rm lasrc_aux.2013-2017.tar.gz
fi

if [ ! -d MSILUT ]; then
  echo "MSILUT data not present... fetching from USGS."
  wget --no-http-keep-alive http://edclpdsftp.cr.usgs.gov/downloads/auxiliaries/lasrc_auxiliary/MSILUT.tar.gz
  tar -xvzf MSILUT.tar.gz
  rm MSILUT.tar.gz
fi

LADSFLAG='--today'
if [ -n "$LAADS_REPROCESS" ]; then
  LADSFLAG='--quarterly'
fi

echo "running updatelads.py $LADSFLAG"
if ! updatelads.py $LADSFLAG; then
    echo "updatelads.py failed"
    echo "sync current /tmp/lads to s3://hls-debug-output/laads_error to debug"
    aws s3 sync /tmp/lads "s3://hls-debug-output/laads_error/${AWS_BATCH_JOB_ID}/"
    exit $?  # exit the bash script with the same status
fi

echo "Contents of /tmp/lads/2021"
ls /tmp/lads/2021 


echo "Creating listing of dates available."
find . | grep -oP "L8ANC([0-9][0-9][0-9][0-9][0-9][0-9])\.hdf_fused$" > laadsavailable.txt

# cleanup
rm MSILUT.tar.gz*
rm lasrc_aux.2013-2017.tar.gz*

if [ -n "$LAADS_BUCKET" ]; then
  echo "Syncing data to s3 bucket s3://$LAADS_BUCKET/lasrc_aux/"
  aws s3 sync . "s3://$LAADS_BUCKET/lasrc_aux/"
fi
