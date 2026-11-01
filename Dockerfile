FROM node:22-bookworm-slim AS build
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build && npm prune --omit=dev
FROM node:22-bookworm-slim
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/ && useradd --system --uid 10001 muslit
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./package.json
RUN mkdir -p /app/.data && chown -R muslit:muslit /app
USER muslit
ENV HOST=0.0.0.0 PORT=8787 MUSLIT_DATA_DIR=/app/.data DATABASE_PATH=/app/.data/muslit.sqlite
EXPOSE 8787
VOLUME ["/app/.data"]
CMD ["node","dist/server.js"]
