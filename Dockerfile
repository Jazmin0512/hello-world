# FROM node:16.13.2-buster
FROM ubuntu:20.04

RUN apt-get update  -y \
    && apt-get upgrade -y \ 
    && apt-get install -y \
    ssh \
    sshpass \
    sudo \
    software-properties-common

RUN add-apt-repository --yes --update ppa:ansible/ansible \
    && apt-get install -y ansible

WORKDIR /home/ansible_controller

COPY ./ansible_base/startup.sh .

RUN useradd -rm -d /home/ansible_controller -s /bin/bash -g root -G sudo -u 1001 ansible_controller
RUN echo ansible_controller:12345 | chpasswd
RUN echo "ansible_controller ALL=(ALL:ALL) NOPASSWD: ALL" |  EDITOR="tee -a"  visudo


RUN mkdir -p /home/ansible_controller/.ssh

COPY package.json package.json
COPY package-lock.json package-lock.json
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash -
RUN apt-get -y install nodejs
RUN npm install

# RUN npm ci --production

# # Copying all files in the local working directory to the VM working directory.
COPY . .
# RUN npm run build

# #nginx Web Server

# FROM nginx:1.20.2-alpine as prod
# COPY --from=build /app/build /usr/share/nginx/html
# EXPOSE 80

# CMD ["nginx", "-g", "daemon off;", "/bin/bash", "/home/ansible_controller/startup.sh" ]
CMD ["/bin/bash", "/home/ansible_controller/startup.sh"]
