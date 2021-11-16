FROM ubuntu:20.04
RUN apt-get update
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential libssl-dev libffi-dev python3-dev python3-pip libsasl2-dev libldap2-dev libpq-dev git cmake wget ca-certificates lsb-release
RUN wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
run apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt update
RUN apt-get install -y libarrow-dev=1.0.1-1 libarrow-python-dev=1.0.1-1
RUN pip3 install --upgrade setuptools pip
RUN PYARROW_CMAKE_OPTIONS="-DARROW_ARMV8_ARCH=armv8-a" pip3 install apache-superset
RUN superset db upgrade
ENV FLASK_APP=superset
RUN superset fab create-admin \
    --username admin \
    --firstname admin \
    --lastname admin \
    --email admin@admin.com \
    --password admin
RUN superset load_examples
RUN superset init
CMD superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger
