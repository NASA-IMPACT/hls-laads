#!/bin/bash
# Make sure that /var/lasrc_aux is a mountpoint
lasrc_directory="$LASRC_AUX_DIR"
echo "Checking mount status"
mount | grep -q "$lasrc_directory" || exit 1
cd "$lasrc_directory" || exit 1
mkdir -p viirs
cd viirs || exit 1
ls 
df -h

echo "running generate_monthly_climatology.py"
generate_monthly_climatology.py -y 2021

if [ -n "$LAADS_BUCKET" ]; then
  echo "Syncing data to s3 bucket s3://$LAADS_BUCKET/lasrc_aux/viirs/"
  aws s3 sync . "s3://$LAADS_BUCKET/lasrc_aux/viirs/"
fi
