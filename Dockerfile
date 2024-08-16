# Use an official Node.js image as the base image
#FROM artifacts.developer.gov.bc.ca/dbe7-images/node20:1.0 AS build
FROM node:20 AS build

#USER root
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN ls -a

RUN npm run build
RUN ls -l

# Use an official Nginx image to serve the built files
#FROM artifacts.developer.gov.bc.ca/dbe7-images/ubi8-nginx120:1.0
FROM nginx:alpine AS final

RUN  touch /var/run/nginx.pid && \
     chown -R nginx:nginx /var/cache/nginx /var/run/nginx.pid
USER nginx

# Copy the built React app to the Nginx HTML directory
COPY nginx.conf /app/nginx.conf
COPY --from=build /app/build /app/build
#COPY --from=build /app/build /usr/share/nginx/html

#COPY --chown=nginx:nginx --from=build /app/build /usr/share/nginx/html
#COPY --chown=nginx:nginx nginx.conf /app/nginx.conf

# Expose port 80
EXPOSE 80

# Run Nginx as the nginx user
USER nginx

# Start Nginx server
CMD ["nginx", "-c", "/app/nginx.conf",  "-g", "daemon off;"]
