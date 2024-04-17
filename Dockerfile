FROM node:14-alpine

WORKDIR /brainscale-simple-app

COPY . /brainscale-simple-app

RUN npm install

EXPOSE 3000

ENV NAME brainscale-simple-app

CMD ["npm", "start"]