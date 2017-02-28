FROM ubuntu:xenial
ENV LANG C.UTF-8
RUN apt-get update &&\
  apt-get install -y python-pip libxml2-dev libxslt-dev wget automake autoconf gcc g++ make &&\
  pip install --upgrade pip &&\
  pip install -U Sphinx

RUN apt-get install -y lbzip2 libreadline6-dev zlib1g-dev libssl-dev &&\
  wget https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.bz2 &&\
  tar -xf postgresql-9.6.2.tar.bz2 &&\
  rm -f postgresql-9.6.2.tar.bz2 &&\
  cd /postgresql-9.6.2 &&\
  ./configure --with-openssl &&\
  make && make install &&\
  rm -rf /postgresql-9.6.2

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH${LD_LIBRARY_PATH:+:}/usr/local/lib:/usr/local/pgsql/lib
RUN apt-get install -y libgtk2.0-dev &&\
  wget https://github.com/wxWidgets/wxWidgets/releases/download/v2.8.12/wxGTK-2.8.12.tar.gz &&\
  tar -xf wxGTK-2.8.12.tar.gz &&\
  rm -f wxGTK-2.8.12.tar.gz &&\
  wget https://ftp.postgresql.org/pub/pgadmin3/release/v1.22.2/src/pgadmin3-1.22.2.tar.gz &&\
  tar -xf pgadmin3-1.22.2.tar.gz &&\
  rm -f pgadmin3-1.22.2.tar.gz &&\
  cd /pgadmin3-1.22.2/xtra/wx-build &&\
  sh build-wxgtk /wxGTK-2.8.12 &&\
  cd /pgadmin3-1.22.2 &&\
  ./configure &&\
  cd /pgadmin3-1.22.2 &&\
  make && make install &&\
  rm -rf /pgadmin3-1.22.2 &&\
  rm -rf /wxGTK-2.8.12

RUN useradd -m pgadmin3
USER pgadmin3
CMD /usr/local/pgadmin3/bin/pgadmin3

## HOW TO RUN 
#docker run --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix:0 registry.angstrom.co.th:8443/pgadmin3:1.22.2