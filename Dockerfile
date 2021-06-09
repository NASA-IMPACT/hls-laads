FROM 018923174646.dkr.ecr.us-west-2.amazonaws.com/hls-base
RUN ln -fs /usr/bin/python2 /usr/bin/python &&\
  yum install -y openssl-devel &&\
  ln -fs /usr/bin/python3 /usr/bin/python &&\
  wget https://curl.haxx.se/download/curl-7.67.0.tar.gz &&\
  gunzip -c curl-7.67.0.tar.gz | tar xvf - &&\
  cd curl-7.67.0 &&\
  ./configure --with-ssl &&\
  make &&\
  make install

COPY sync_laads.sh ./usr/local/sync_laads.sh

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["./usr/local/sync_laads.sh"]
