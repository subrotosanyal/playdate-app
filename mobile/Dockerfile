# Use a more up-to-date Flutter image for the web
FROM ghcr.io/cirruslabs/flutter:3.24.3

# Set the working directory
WORKDIR /app

# Copy all files from the host machine to the container
COPY . .

# Install Node.js and npm (required to run http-server)
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g http-server

# Install dependencies
RUN flutter pub get

# Build the Flutter web project
RUN flutter build web

# Expose the port the app will run on (change to 3000)
EXPOSE 3000

# Serve the Flutter web app on port 3000
CMD ["http-server", "build/web", "-p", "3000"]
