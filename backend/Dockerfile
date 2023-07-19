# Specify the base image
FROM node:14-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code to the container
COPY . .

# Expose the port on which your Node.js app runs
EXPOSE 3000

# Specify the command to run your Node.js app
CMD ["node", "index.js"]