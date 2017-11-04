FROM resin/raspberrypi3-node

RUN apt-get update && apt-get install -yq \
    libraspberrypi-bin \
    network-manager \
    iptables

WORKDIR usr/src/app

COPY package.json ./
RUN JOBS=MAX npm i --production

COPY . ./

CMD ["bash", "start.sh"]