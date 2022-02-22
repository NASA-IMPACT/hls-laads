FROM 018923174646.dkr.ecr.us-west-2.amazonaws.com/hls-base-3.2.0
RUN ln -fs /usr/bin/python2 /usr/bin/python &&\
  yum install -y openssl-devel &&\
  yum install -y ca-certificates &&\
  ln -fs /usr/bin/python3 /usr/bin/python

COPY sync_laads.sh ./usr/local/sync_laads.sh

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["./usr/local/sync_laads.sh"]
