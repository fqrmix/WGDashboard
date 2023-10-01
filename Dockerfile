FROM ubuntu:20.04

RUN apt update
RUN apt install -y apt-utils python3.8 python3-pip gcc libffi-dev python-dev default-libmysqlclient-dev python3-dev net-tools gettext-base iproute2 iptables wireguard

# Install python dependences
COPY ./src/requirements.txt ./requirements.txt
RUN pip install --no-cache --no-cache-dir -r ./requirements.txt

RUN mkdir /home/app
COPY ./env.sh /home/app/env.sh
COPY ./wg0_template.conf /home/app/wg0_template.conf
COPY ./wg-dashboard.ini /home/app/wg-dashboard.ini
