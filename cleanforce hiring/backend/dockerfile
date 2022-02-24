FROM node
# ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install

COPY . .

# ENTRYPOINT [ "/bin/sh" ]

CMD [ "node", "index.js" ]
