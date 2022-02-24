FROM node:14-alpine3.12
RUN apk add --no-cache nodejs npm

WORKDIR /apis

ARG DB_URL
ARG PROD_DB_URL
ENV PATH /apis/node_modules/.bin:$PATH
ENV DB_URL=${DB_URL}
ENV PROD_DB_URL=${PROD_DB_URL}

COPY package.json ./apis
COPY package-lock.json ./apis

RUN npm install

COPY . ./

EXPOSE 8081

CMD npm start

