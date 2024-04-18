FROM node:14-alpine

WORKDIR /terraform_brainscale

COPY . /terraform_brainscale

RUN npm install

EXPOSE 3000

ENV NAME brainscale-simple-app

CMD ["npm", "start"]