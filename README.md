# hls-laads
### HLS processing container for downloading and syncing LAADS auxiliary data.
The hls-laads container's primary purpose is executing a daily cron job to run the `updatelads.py` from [espa-surface-reflectance](https://github.com/NASA-IMPACT/espa-surface-reflectance/blob/eros-collection2-3.1.0/lasrc/landsat_aux/scripts/updatelads.py) which is installed as part of the [hls-base](https://github.com/NASA-IMPACT/hls-base) container.

By default the command is run using the `--today` option in order to synchronize auxiliary data from the current day to the beginning of the year.

The container expects a volume mounted at `/var/lasrc_aux` to use as a storage target.

The container can be configured via environment variables to run several other auxiliary data syncing operations.

```
LAADS_BUCKET_BOOTSTRAP
```
Will use the s3 bucket specified in the environment variable to load an existing store of LAADS auxiliary data from a bucket onto the EFS partition mounted at `/var/lasrc_aux`.

```
LADS/2013
```
```
MSILUT
```
The Lasrc C code requires other baseline auxiliary as described [here](https://github.com/NASA-IMPACT/espa-surface-reflectance/tree/eros-collection2-3.1.0/lasrc#installation). These options will download and extract those files to the EFS mount partition.

```
LAADS_BUCKET
```
This environment will specify the bucket in the stack where auxiliary files should be synchronized after they have been written to the EFS mount partition.

Any error code > 500 reported by the LAADS DAAC servers while downloading data will result in the `sync_laads.sh` script and the container exiting with an exit code of 1 for tracking system level errors.
