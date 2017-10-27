FROM resin/raspberrypi-node

RUN apt-get update && apt-get install -yq \
    libraspberrypi-bin \
    network-manager

WORKDIR usr/src/app

COPY package.json ./
RUN JOBS=MAX npm i --production

COPY . ./

CMD npm start
