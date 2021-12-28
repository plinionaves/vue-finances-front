FROM node:14.18.2-alpine3.14 AS dev-stage

WORKDIR /usr/app

COPY package*.json ./

RUN npm i

COPY --chown=node:node . .


FROM dev-stage AS build-stage

RUN npm run build


FROM nginx:alpine AS prod-stage

COPY --from=build-stage /usr/app/dist /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx/default.conf /etc/nginx/conf.d

CMD [ "nginx", "-g", "daemon off;" ]