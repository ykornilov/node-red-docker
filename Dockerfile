ARG OS=ubuntu:bionic

#### Stage BASE ########################################################################################################
FROM ${OS} AS base

# Install tools, create Node-RED app and data dir, add user and set rights
RUN mkdir -p /usr/src/node-red /data && \
    chmod -R g+rwX /data && \ 
    chmod -R g+rwX /usr/src/node-red

RUN apt-get update
RUN apt-get install nodejs -y
RUN apt-get install npm -y

# Set work directory
WORKDIR /usr/src/node-red

# package.json contains Node-RED NPM module and node dependencies
COPY package.json .

#### Stage BUILD #######################################################################################################
FROM base AS build

# Install Build tools
RUN npm install --unsafe-perm --no-update-notifier --no-fund --only=production && \
    cp -R node_modules prod_node_modules

#### Stage RELEASE #####################################################################################################
FROM base AS RELEASE

ARG NODE_RED_VERSION

COPY --from=build /usr/src/node-red/prod_node_modules ./node_modules

# Env variables
ENV NODE_RED_VERSION=$NODE_RED_VERSION \
    NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules \
    FLOWS=flows.json

# ENV NODE_RED_ENABLE_SAFE_MODE=true    # Uncomment to enable safe start mode (flows not running)
# ENV NODE_RED_ENABLE_PROJECTS=true     # Uncomment to enable projects option

COPY ./settings /data
RUN cd /data && npm install
RUN cd /usr/src/node-red

# User configuration directory volume
# VOLUME ["/data"]

# Expose the listening port of node-red
EXPOSE 1880

# Add a healthcheck (default every 30 secs)
# HEALTHCHECK CMD curl http://localhost:1880/ || exit 1

ENTRYPOINT ["npm", "start", "--cache", "/data/.npm", "--", "--userDir", "/data"]
