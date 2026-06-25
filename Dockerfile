
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install --force
COPY ..
COPY /var/www/html/index.html
EXPOSE 3000
CMD ["npm", "start"]
