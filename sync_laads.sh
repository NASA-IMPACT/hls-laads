#!/bin/bash
# Make sure that /var/lasrc_aux is a mountpoint
lasrc_directory="$LASRC_AUX_DIR"
echo "Checking mount status"
mount | grep -q "$lasrc_directory" || exit 1

echo "Aux directory is $LASRC_AUX_DIR"

#Switch to the LASRC_AUX_DIR to check if MSILUT seed data is available.
cd "$lasrc_directory"
if [ ! -d MSILUT ]; then
  echo "MSILUT data not present... fetching from USGS."
  wget --no-http-keep-alive http://edclpdsftp.cr.usgs.gov/downloads/auxiliaries/lasrc_auxiliary/MSILUT.tar.gz
  tar -xvzf MSILUT.tar.gz
  rm MSILUT.tar.gz
fi

if [ -n "$LAADS_BUCKET_BOOTSTRAP" ]; then
  echo "Syncing existing laads data from aws s3 bucket s3://$LAADS_BUCKET_BOOTSTRAP/lasrc_aux/"
  aws s3 sync "s3://$LAADS_BUCKET_BOOTSTRAP/lasrc_aux/" .
fi

echo "running updatelads.py $LAADS_FLAG"
if ! updatelads.py "$LAADS_FLAG"; then
    echo "updatelads.py failed"
    echo "sync current /tmp/lads to s3://hls-debug-output/laads_error to debug"
    aws s3 sync /tmp/lads "s3://hls-debug-output/laads_error/${AWS_BATCH_JOB_ID}/"
    exit 1
fi

# cleanup
rm MSILUT.tar.gz*

if [ -n "$LAADS_BUCKET" ]; then
  echo "Syncing data to s3 bucket s3://$LAADS_BUCKET/lasrc_aux/"
  aws s3 sync "$LASRC_AUX_DIR" "s3://$LAADS_BUCKET/lasrc_aux/"
fi
