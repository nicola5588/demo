FROM node:16
# Above, we set the base image for this first stage as a light weigh node

WORKDIR './app'
# Above we set the build environment as a folder called /app in the docker container to prevent clashes

COPY package*.json ./
# To prevent repeated npm installs anytime we make any change, we'd copy over the package.json and install things first

RUN npm install
# Install dependencies

COPY ./ ./
# Copy the rest of the project over to the /app folder in the container

#RUN npm run build

EXPOSE 8080

CMD ["npm", "start"]
# command to run when the container is created


