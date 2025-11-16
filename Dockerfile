# Stage 1: Build Next.js app
FROM node:22-alpine AS build

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build Next.js production bundle
RUN npm run build

# Stage 2: Run Next.js app
FROM node:22-alpine

WORKDIR /app

# Copy only necessary files from build stage
COPY --from=build /app/package*.json ./
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "start"]
