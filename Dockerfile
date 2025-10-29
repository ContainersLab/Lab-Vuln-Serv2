####
# BUILD
####

# Dockerfile
FROM node:20@sha256:cba1d7bb8433bb920725193cd7d95d09688fb110b170406f7d4de948562f9850 AS builder

# Patch 9️⃣ Ping (POST /ping) :
RUN adduser --disabled-password --gecos "" mynode_user
USER mynode_user

WORKDIR /usr/src/app

# copy package files first to use cache
COPY package.json package-lock.json* ./

# install deps (allow dev deps for lab)
RUN npm ci --production=false

# copy app sources
COPY . .

# create uploads directory (app expects it)
RUN mkdir -p /usr/src/app/uploads

EXPOSE 3000

# default command is a simple node start (docker-compose will call it)
CMD ["node", "server.js"]


#####
# BUILD
#####
FROM node:20-slim@sha256:cba1d7bb8433bb920725193cd7d95d09688fb110b170406f7d4de948562f9850 AS runtime

# Patch 9️⃣ Ping (POST /ping) :
RUN adduser --disabled-password --gecos "" mynode_user
USER mynode_user

WORKDIR /usr/src/app

# copy package files first to use cache
COPY package.json package-lock.json* ./

# install deps (allow dev deps for lab)
RUN npm ci --production=false

# copy app sources
COPY . .

# create uploads directory (app expects it)
RUN mkdir -p /usr/src/app/uploads

EXPOSE 3000

# default command is a simple node start (docker-compose will call it)
CMD ["node", "server.js"]