FROM node:13-slim

# Update container
# RUN apt-get update && \
#   apt-get install --no-install-recommends -y && \
#   rm -rf /var/lib/apt/lists/*

# Set environnement to development
ENV NODE_ENV=development

# Create node directory 
WORKDIR /node/app

# Copy npm dependencies
COPY package*.json webpack.mix.js yarn.lock* ./

# Create app directory to contain the app and set permission for node user
RUN chown -R node:node .

# Change the user to be node
USER node

# Install dependencies
RUN yarn install && yarn cache clean

# Add to PATH
RUN npm config set scripts-prepend-node-path true


# Copy existing local files into container, and set permission to node user
COPY --chown=node:node  . ./


CMD [ "yarn", "watchl" ]

