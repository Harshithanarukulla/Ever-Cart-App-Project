FROM node: 18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
ENV MONGODB_URI=mongodb://localhost:27017/evercart
ENV ADMIN_KEY=EVERCART_ADMIN_2025
ENV BCRYPT_SALT_ROUNDS=12
CMD ["npm", "start"]