
# Stage: 1
FROM node:22-alpine AS builder

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN npm install -g pnpm@latest && pnpm install --frozen-lockfile

COPY . .

RUN pnpm exec nx run angular-nx-docker-template:build --configuration=production

# Stage: 2
FROM nginx:stable-alpine

COPY default.conf /etc/nginx/conf.d

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /app/dist/angular-nx-docker-template/browser ./

EXPOSE 80