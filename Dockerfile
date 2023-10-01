# Stage 1: Build the React app
FROM node:16.17.1-alpine3.16 as build
WORKDIR /app
COPY . /app
RUN npm ci
RUN npm run build

# Stage 2: Set up the Nginx container
FROM nginx:1.23.1-alpine
EXPOSE 80

# Copy the Nginx configuration
COPY ./docker/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Copy the built React app files to the Nginx web root directory
COPY --from=build /app/dist /usr/share/nginx/html

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
