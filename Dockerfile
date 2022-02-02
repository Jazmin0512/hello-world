# FROM node:16.13.2-buster
FROM node:16.13.2-buster as build

WORKDIR /app

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

# RUN npm install
RUN npm ci --production

# Copying all files in the local working directory to the VM working directory.
COPY . .

# CMD ["npm", "run", "start"]
RUN npm run build

#nginx Web Server

FROM nginx:1.20.2-alpine as prod

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]