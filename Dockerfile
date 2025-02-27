FROM node:16-alpine as builder

WORKDIR /var/www/cdn/current

COPY package.json package-lock.json ./

# Install dependencies
RUN npm install 

COPY . .

# Build the project
RUN npm run webpack

FROM nginx:alpine

COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf

# Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /var/www/cdn/current/build /usr/share/nginx/html

EXPOSE 8000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]