# Use Node.js base image
FROM node:20-alpine

# Install http-server globally
RUN npm install -g http-server

# Set working directory
WORKDIR /app

# Copy build files to container
COPY build/ .

# Expose port 3000 (or any you like)
EXPOSE 3000

# Start http-server on container startup
CMD ["http-server", "-p", "3000"]
