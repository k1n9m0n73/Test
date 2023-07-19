# Use a lightweight Node.js image
FROM node:14-alpine

# Set the working directory
WORKDIR usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the backend code
COPY . .

# Set the command to start the backend server
CMD [ "npm", "start" ]
