# Prod building stage
FROM node:13 as prod

# Update container
RUN apt-get update

# Tiny allows to gracefully stop node process
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Set environement to production
ENV NODE_ENV=production

RUN apt-get update

# Create node directory 
WORKDIR /home/node

# Copy npm dependencies
COPY package*.json yarn.lock* ./

# Create app directory to contain the app and set permision for node user
RUN mkdir app && chown -R node:node .

# Change the user to be node
USER node

# Install prod dependencies
RUN npm install --only=production && npm cache clean force

# Change for app directory
WORKDIR /home/node/app

# Copy existing local files into container, and set permission to node user
COPY --chown=node:node  . .

# Tiny entrypoint
ENTRYPOINT ["/tini", "--"]

# Start Node
CMD ["node", "./bin/www"]

# Dev building stage
FROM prod as dev

# Set environement to devellopment
ENV NODE_ENV=devellopment

# Install prod dependencies
RUN npm install --only=devellopment

CMD [ "yarn", "dev" ]