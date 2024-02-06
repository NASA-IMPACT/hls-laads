FROM 018923174646.dkr.ecr.us-west-2.amazonaws.com/hls-base-3.3.0
RUN ln -fs /usr/bin/python2 /usr/bin/python &&\
  yum install -y openssl-devel &&\
  yum install -y ca-certificates &&\
  ln -fs /usr/bin/python3 /usr/bin/python

COPY sync_laads.sh ./usr/local/sync_laads.sh
COPY climatologies.sh ./usr/local/climatologies.sh
COPY updatelads.py  ./usr/local/bin/updatelads.py
COPY generate_monthly_climatology.py ./usr/local/bin/generate_monthly_climatology.py


CMD ["./usr/local/sync_laads.sh"]
