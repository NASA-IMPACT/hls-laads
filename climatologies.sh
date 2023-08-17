#!/bin/bash
# Make sure that /var/lasrc_aux is a mountpoint
lasrc_directory="$LASRC_AUX_DIR"
year="$CLIM_YEAR"
month="$CLIM_MONTH"

echo "Checking mount status"
mount | grep -q "$lasrc_directory" || exit 1
cd "$lasrc_directory" || exit 1
mkdir -p "$lasrc_directory/viirs"

export LASRC_AUX_DIR="$lasrc_directory/viirs"
echo "Aux directory is $LASRC_AUX_DIR"

if [ -z "$CLIM_MONTH" ]; then
  for i in 1 2 3 4 5 6 7 8 9 10 11 12
  do
    echo "running generate_monthly_climatology.py for $year month $i"
    generate_monthly_climatology.py -y "$year" -m "$i"
  done
else
  echo "running generate_monthly_climatology.py for $year and month $month"
  generate_monthly_climatology.py -y "$year" -m "$month"
fi


if [ -n "$LAADS_BUCKET" ]; then
  echo "Syncing data to s3 bucket s3://$LAADS_BUCKET/lasrc_aux/viirs/monthly_avgs" 
  aws s3 sync "$LASRC_AUX_DIR/monthly_avgs/" "s3://$LAADS_BUCKET/lasrc_aux/viirs/monthly_avgs/"
fi
