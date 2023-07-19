# Use a lightweight Node.js image for building
FROM node:14-alpine as build

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the frontend code
COPY . .

# Build the frontend code
RUN npm run build

# Use a lightweight Node.js image for running the app
FROM node:14-alpine

# Set the working directory
WORKDIR /service/frontend/

# Copy the built frontend code from the previous stage
COPY --from=build /usr/src/app/build ./build

# Install serve package to run the static files
RUN npm install -g serve

# Set the command to start the frontend server
CMD [ "serve", "-s", "build", "-l", "3000" ]
