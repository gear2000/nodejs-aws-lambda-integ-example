FROM node:14

# Create app directory
WORKDIR /usr/src/app

COPY src/ .

RUN npm install

EXPOSE 3000

#CMD [ "npm", "start" ]
CMD [ "node", "index.js" ]
