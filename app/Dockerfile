FROM node:16-alpine

ENV CI=true

#RUN groupadd -r zscore && useradd -r -g zscore user
#USER user

WORKDIR /app

COPY package.json ./

RUN npm install

COPY ./ ./

#add bash
RUN apk add --no-cache bash

#install R and packages
#RUN apt update
#RUN apt-get install -y r-base
RUN apk add --no-cache R

#remove windows line endings
#RUN apt-get install -y dos2unix

RUN apk add --no-cache dos2unix
RUN dos2unix pipeline_scripts/Zscore_calculation.sh
RUN chmod 775 pipeline_scripts/Zscore_calculation.sh

RUN npm run build

CMD [ "npm", "run", "start:prod" ]
