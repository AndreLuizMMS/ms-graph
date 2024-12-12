#!/bin/bash

echo "Iniciando o script entrypoint-dev.sh"

# Instala as dependências do Node.js usando npm
echo "Instalando dependências do Node.js..."
npm install

# Inicia o servidor de desenvolvimento
echo "Iniciando servidor HTTP de desenvolvimento..."
npm run dev