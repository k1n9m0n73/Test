# Specify the base image
FROM nginx:latest

# Copy the static files to the container
COPY ./  /usr/share/nginx/html

# Expose the port on which the Nginx server runs
EXPOSE 8080

# Start Nginx server when the container starts
CMD ["nginx", "-g", "daemon off;"]