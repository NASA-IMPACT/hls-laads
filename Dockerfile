FROM 018923174646.dkr.ecr.us-west-2.amazonaws.com/hls-base-3.1.0
COPY sync_laads.sh ./usr/local/sync_laads.sh
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["./usr/local/sync_laads.sh"]
