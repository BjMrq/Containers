#-----------------------------------------
# Prod building stage
#-----------------------------------------
FROM node:13-slim as base

# Set environement to production
ENV NODE_ENV=production

# Create node directory 
WORKDIR /node

# Copy npm dependencies
COPY package*.json yarn.lock* ./

# Create app directory to contain the app and set permision for node user
RUN mkdir app && chown -R node:node .

# Change the user to be node
# USER node

# Install prod dependencies
RUN npm config list
RUN npm ci \
  && npm cache clean --force

# Add to PATH
ENV PATH /node/node_modules/.bin/:$PATH

# Change for app directory
WORKDIR /node/app

# Start Node
CMD ["node", "./bin/www"]

#-----------------------------------------
# Dev building stage
#-----------------------------------------
FROM base as dev

# Set environnement to development
ENV NODE_ENV=development

# Add dependencies
USER root
RUN apt-get update -qq && apt-get install -qy \ 
  ca-certificates \
  bzip2 \
  curl \
  libfontconfig \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*


# Install dev dependencies
RUN npm config list
RUN npm install --only=dev \
  && npm cache clean --force

# Create app directory to contain the app and set permission for node user
RUN mkdir app && chown -R node:node .

# Change for app directory
WORKDIR /node/app

USER node

CMD [ "npm", "run", "dev" ]

#-----------------------------------------
# Test building stage
#-----------------------------------------
FROM dev as test

# Copy the app
COPY --chown=node:node . .

# Audit dependencies
RUN npm audit

# Scan for 
ARG MICROSCANNER_TOKEN
ADD https://get.aquasec.com/microscanner /

USER root
RUN chmod +x /microscanner
RUN /microscanner $MICROSCANNER_TOKEN --continue-on-failure

#-----------------------------------------
# Clean-up building stage
#-----------------------------------------
FROM test as clean-up

# remove thing you don't want in your production image
RUN rm -rf ./tests && rm -rf ./node_modules


#-----------------------------------------
# Clean-up building stage
#-----------------------------------------
FROM base as prod

# Copy the app from the clean-up stage
COPY --from=clean-up /app /app

# Healthcheck of the app
HEALTHCHECK CMD curl http://127.0.0.1/ || exit 1

USER node

