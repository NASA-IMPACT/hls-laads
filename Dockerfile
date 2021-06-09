FROM 018923174646.dkr.ecr.us-west-2.amazonaws.com/hls-base
RUN yum install -y openssl-devel &&\
  wget https://curl.haxx.se/download/curl-7.67.0.tar.gz &&\
  gunzip -c curl-7.67.0.tar.gz | tar xvf - &&\
  cd curl-7.67.0 &&\
  ./configure --with-ssl &&\
  make &&\
  make install

COPY sync_laads.sh ./usr/local/sync_laads.sh

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["./usr/local/sync_laads.sh"]
