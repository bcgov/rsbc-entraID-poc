# Use an official Node.js image as the base image
#FROM artifacts.developer.gov.bc.ca/dbe7-images/node20:1.0 AS build
FROM artifacts.developer.gov.bc.ca/dbe7-images/node20:1.0 AS build

USER root
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

COPY nginx.conf /app/nginx.conf
WORKDIR /app
COPY --from=build /app/build /app/build

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-c", "/app/nginx.conf",  "-g", "daemon off;"]
