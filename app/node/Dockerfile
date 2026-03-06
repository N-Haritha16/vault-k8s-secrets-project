FROM node:20-slim AS build

WORKDIR /usr/src/app

# install curl for Docker healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install

COPY src ./src

EXPOSE 3000
CMD ["npm", "start"]
