## It will use node:19-alpine3.16 as the parent image for building the Docker image
# FROM node:19-alpine3.16
FROM node:21.6-alpine3.19
## It will create a working directory for Docker. The Docker image will be created in this working directory.
WORKDIR /react-app
## Copy the React.js application dependencies from the package.json to the react-app working directory.
COPY package.json .
COPY package-lock.json .
## Install all the React.js application dependencies
RUN npm i
## Run test(s)
RUN npm test src/App.test.js
## Copy the remaining React.js application folders and files from the `jenkins-kubernetes-deployment` local folder to the Docker react-app working directory
COPY . .
## Expose the React.js application container on port 3000
EXPOSE 3000
## The command to start the React.js application container
CMD ["npm", "start"]

#===========================================================================
# # Use Jenkins base imag
# FROM jenkins/jenkins:lts
# USER root
# # Install kubectl
# RUN curl -LO "https://dl.k8s.io/release/v1.28.3/bin/linux/amd64/kubectl" \
# 		&& chmod +x kubectl \
# 		&& mv kubectl /usr/local/bin/
# # Install Helm
# ARG HELM_VER=v3.14.0
# ARG HELM_DIST=helm-$HELM_VER-linux-amd64.tar.gz
# RUN curl -LO "https://get.helm.sh/${HELM_DIST}" \
#     && tar -zxvf ${HELM_DIST} \
# 		&& mv linux-amd64/helm /usr/local/bin \
# 		&& rm -rf ${HELM_DIST}

