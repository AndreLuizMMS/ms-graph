## https://hub.docker.com/_/ubuntu
FROM ubuntu:22.04

## Configuração do Timezone
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

## Instala os pacotes do Linux relevantes para a aplicação
RUN apt-get update
RUN apt-get install -y nano vim htop zip git wget curl postgresql-client postgis nginx

# Instale o Node JS Versão 20.x
RUN apt-get update && apt-get install -y ca-certificates curl gnupg
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
ENV NODE_MAJOR=20
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs
RUN npm i npm@latest -g
RUN npm i -g @nestjs/cli

## Cria um usuário no Linux
ENV USER_DOCKER=docker_manager_user
RUN useradd -m $USER_DOCKER

## Define o diretório de trabalho
WORKDIR /var/www/app

## Porta HTTP do container liberada
EXPOSE 8089