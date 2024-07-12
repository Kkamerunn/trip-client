FROM node:16-alpine

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia el package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código de la aplicación
COPY . .

# Construye la aplicación
RUN npm run build

# Usa una imagen ligera de servidor web para servir la aplicación
FROM nginx:alpine
COPY --from=0 /app/dist /usr/share/nginx/html

# Expone el puerto de la aplicación
EXPOSE 80

# Comando para iniciar el servidor web
CMD ["nginx", "-g", "daemon off;"]