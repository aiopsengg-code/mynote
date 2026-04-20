# Use the official Nginx image as a base
FROM nginx:alpine

# Copy the static files into the Nginx HTML folder
COPY . /usr/share/nginx/html

# Expose port 80 for the Nginx server
EXPOSE 80