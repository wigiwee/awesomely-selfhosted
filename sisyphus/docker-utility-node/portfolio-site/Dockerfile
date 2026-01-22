FROM node:20-alpine

WORKDIR /app

# Install git
RUN apk add --no-cache git

# Clone your repository
RUN git clone https://github.com/wigiwee/portfolio-site.git .

# Install dependencies
RUN npm ci

# Build the Vite app
RUN npm run build

# Install minimal static server
RUN npm install -g serve

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]

