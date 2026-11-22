FROM node:22-alpine
WORKDIR /app
COPY server.mjs ./
COPY lib ./lib
COPY public ./public
# Optional: present only in builds that bake the credential (never committed).
COPY secrets.en[v] ./
ENV PORT=8080 NODE_ENV=production
USER node
EXPOSE 8080
CMD ["node", "server.mjs"]
