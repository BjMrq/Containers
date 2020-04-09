# Prod building stage
FROM node:13 as base

# Update container
RUN apt-get update

# Tiny allows to gracefully stop node process
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Set environement to production
ENV NODE_ENV=production

# Create node directory 
WORKDIR /node

# Copy npm dependencies
COPY package*.json ./

# Create app directory to contain the app and set permision for node user
RUN mkdir app && chown -R node:node .

# Change the user to be node
USER node

# Install prod dependencies
RUN npm config list
RUN npm ci \
  && npm cache clean --force

# Add to PATH
ENV PATH /node/node_modules/.bin/:$PATH

# Tiny entrypoint
ENTRYPOINT ["/tini", "--"]

# Start Node
CMD ["node", "./bin/www"]

# Dev building stage
FROM base as dev

# Set environement to devellopment
ENV NODE_ENV=devellopment

# Install dev dependencies
RUN npm config list
RUN npm install --only=dev \
  && npm cache clean --force

CMD [ "yarn", "dev" ]

FROM base as prod

