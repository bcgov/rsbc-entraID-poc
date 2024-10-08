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
FROM artifacts.developer.gov.bc.ca/dbe7-images/ubi8-nginx120:1.0
#FROM nginx AS final

#RUN chmod -R 770 /var/cache/nginx /var/run /var/log/nginx
# Copy the built React app to the Nginx HTML directory
COPY nginx.conf /app/nginx.conf
COPY --from=build /app/build /app/build

# Expose port 80
EXPOSE 8080

# Start Nginx server
CMD ["nginx", "-c", "/app/nginx.conf",  "-g", "daemon off;"]
