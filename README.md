# hls-laads
### HLS processing container for downloading and syncing LAADS auxiliary data.
The hls-laads container's primary purpose is executing a daily cron job to run the `updatelads.py` from [espa-surface-reflectance](https://github.com/NASA-IMPACT/espa-surface-reflectance/blob/eros-collection2-3.5.1/lasrc/landsat_aux/scripts/updatelads.py) which is installed as part of the [hls-base](https://github.com/NASA-IMPACT/hls-base) container.

In order to support the use of LAADS DAAC token as an environment variable, the `updatelads.py` and `generate_monthly_climatology.py` scripts has been copied here and modified.

The container's default `CMD` is `sync_laads.sh`.  It requires the following environment variables to be set

```
LAADS_TOKEN
```
A current LAADS DAAC authorization token.

```
LASRC_AUX_DIR
```
The target directory for writing the auxiliary data which in the production system should be the EFS mount. Our systems use `/var/lasrc_aux` for this.

```
LAADS_FLAG
```
The time argument passed to `updatelads.py` in almost all cases this should be set to `--today` in order to process all LAADS data through the current year.  The `updatelads.py` script will check for existing data and only download and process the most recent data necessary to complete the year. 

`sync_laads.sh` also supports the following optional environment variables

```
LAADS_BUCKET
```
The S3 bucket where auxiliary files should be synchronized for backup storage after they have been written to the EFS mount partition.

```
LAADS_BUCKET_BOOTSTRAP
```
Will use the S3 bucket specified in the environment variable to load an existing store of LAADS auxiliary data from a bucket onto the EFS partition mounted at `/var/lasrc_aux` prior to running `updatelads.py` 
```

Any error code > 500 reported by the LAADS DAAC servers while downloading data will result in the `sync_laads.sh` script and the container exiting with an exit code of 1 for tracking system level errors.


The container also has a secondary executable script called `climatologies.sh`. With the release of LASRC 3.5.1 and the move to VIIRS auxiliary data, [this documentation](https://github.com/NASA-IMPACT/espa-surface-reflectance/tree/eros-collection2-3.5.1/lasrc#auxiliary-data-updates) from the LASRC 3.5.1 codebase outlines the need for monthly climatology data to perform VIIRS gap filling. The `climatologies.sh` script provides a wrapper around the LASRC [generate_monthly_climatology.py](https://github.com/NASA-IMPACT/espa-surface-reflectance/blob/eros-collection2-3.5.1/lasrc/landsat_aux/scripts/generate_monthly_climatology.py) script. It should be run nightly the first 5 days of each month.  It requires the following variables to be set

```
LAADS_TOKEN
```
A current LAADS DAAC authorization token.

```
LASRC_AUX_DIR
```
The target directory for writing the auxiliary data which in the production system should be the EFS mount. Our systems use `/var/lasrc_aux` for this.

```
CLIM_YEAR
```
The target year to generate the climatology for.  If the environment variable `CLIM_MONTH` is included the climatology will be generated for only that month.  If it is not included the climatology will be generated for every month of the `CLIM_YEAR`.

`climatologies.sh` also supports the following optional environment variables

```
LAADS_BUCKET
```
The S3 bucket where auxiliary files should be synchronized for backup storage after they have been written to the EFS mount partition.
