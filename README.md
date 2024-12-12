# 🏮 Sobre

Cesbe Transmission é um projeto que tem a função de ser uma camada externa ao ERP atual, dedicada à Gestão Patrimonial para ativos de Transmissão e Geração do Setor Elétrico. Ele é capaz de realizar todas as funções necessárias para a gestão do ativo imobilizado da companhia, seguindo os preceitos da legislação vigente – Manual de Contabilidade do Setor Elétrico e Manual de Controle Patrimonial do
Setor Elétrico – no que diz respeito a imobilizações, baixas, transferências, controle de vida útil e depreciação e geração de relatórios e informações de gestão.


# 📂 Como instalar o projeto


#### • Ambiente de Desenvolvimento:

```bash
## Certifique-se de copiar e configurar os seguintes arquivos .env
$ cp .env.example .env
$ cp app-client/.env.development-example app-client/.env.development
$ cp api/.env.development api/.env

$ Preencher variável JWT_SECRET do arquivo api-server/.env com um hash valido de no mínimo 55 caracteres 
  - $ nano api-server/.env

$ Preencher váriavel PASSWORD_ENCRYPTION_KEY do arquivo api-server/.env com um hash valido de no mínimo 50 caracteres 
  - nano api-server/.env

$ Preencher váriaveis BULL_BOARD_USERNAME e BULL_BOARD_PASSWORD do arquivo api-server/.env
  - nano api-server/.env

$ chmod +x api/entrypoint-dev.sh
$ chmod +x app-client/entrypoint-dev.sh
$ sudo docker-compose -f docker-compose.dev.yml up

$ npm run migration:run

$ CRIAR AS VIEWS
```

#### • Ambiente de Produção:

```bash
## Certifique-se de copiar e configurar os seguintes arquivos .env
$ cp .env.example .env
$ cp app-client/.env.production-example app-client/.env.production
$ cp api-server/.env.production api-server/.env (NÃO ESQUECER DE ALTERAR CROSS_ORIGN no arquivo .env)

$ Modificar variaveis POSTGRES_USER e POSTGRES_PASSWORD do arquivo .env
  - nano .env

$ Preencher váriavel JWT_SECRET do arquivo api-server/.env com um hash valido de no minimo 55 caracteres 
  - nano api-server/.env

$ Preencher váriavel PASSWORD_ENCRYPTION_KEY do arquivo api-server/.env com um hash valido de no mínimo 50 caracteres 
  - nano api-server/.env

$ Preencher váriaveis BULL_BOARD_USERNAME e BULL_BOARD_PASSWORD do arquivo api-server/.env
  - nano api-server/.env

$ Alterar

$ chmod +x api/entrypoint-prod.sh
$ chmod +x app-client/entrypoint-prod.sh
$ chmod +x docker/nginx-reverse-proxy-server/entrypoint.sh
$ docker-compose -f docker-compose.prod.yml up

# Apos colocar servidor em produção, será necessário acessar o EC2 e rodar o seguinte comando para habilitar o overcommit de memória, comando necessário para o container redis (https://github.com/nextcloud/all-in-one/discussions/1731)
$ sudo sysctl vm.overcommit_memory=1

#### Como configurar Certificado HTTP's Let's Encrypt de um DNS: (https://pentacent.medium.com/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71 e https://www.youtube.com/watch?v=J9jKKeV1XVE)
# Apos todos os container's estiverem sido gerados, conecte-se via ssh no container do nginx e rode os seguintes comandos:
# Rode o comando abaixo para gerar os certificados:
  $ certbot certonly --webroot --webroot-path=/var/www/certbot --email murilo@norven.com.br --agree-tos --no-eff-email -d cesbe.norven.com.br -d www.cesbe.norven.com.br
# Descomente as seguintes linhas no arquivo (/etc/nginx/nginx.conf) dentro do container do nginx (ssh):
  - server_name cesbe.norven.com.br www.cesbe.norven.com.br;
  - return 301 https://$host$request_uri;
  - listen 443 ssl;
  - ssl_certificate /etc/letsencrypt/live/cesbe.norven.com.br/fullchain.pem;
  - ssl_certificate_key /etc/letsencrypt/live/cesbe.norven.com.br/privkey.pem;
# Agora rode o comando (nginx -t) para conferir a sintaxe do arquivo .conf e reinicie o container
  $ nginx -t
# OBS: Existe um cron configurado no nginx-reverse-proxy-server.dockerfile que faz a revonação do certificado diariamente as 00:00, caso essa alteração não funcionar automaticamente, basta reiniciar o container do nginx
```

# 🔧 Como configurar VSCODE (ESLint e Jest Runner)

```bash
$ Instalar extensão ESLint (https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
$ Instalar extensão Jest Runner (https://marketplace.visualstudio.com/items?itemName=firsttris.vscode-jest-runner)
$ Abrir arquivo de configurações do VS CODE e modificar settings.json com os seguintes parâmetros:
  {
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true
    },
    "eslint.format.enable": true,
    "editor.formatOnSave": true,
    "eslint.validate": [
        "javascript",
        "typescript"
    ],
    "jestrunner.codeLensSelector": "**/*.{test,spec,int-spec}.{js,jsx,ts,tsx}",
    "explorer.compactFolders": false
  }
```

#### • Outros Comandos

```bash
## Caso dê o erro "Temporary failure resolving *.ubuntu.com" durante o build da imagem api-server, tente os seguintes comandos:
$ docker build -f docker/api-server/api-server-dev.dockerfile --no-cache --network=host .    ou     $ docker build -f docker/api-server/api-server-dev.dockerfile --no-cache --network=host .
$ docker-compose -f docker-compose.prod.yml up

## Para se conectar via ssh com o container cesbe-transmission-api-server
$ docker exec -it cesbe-transmission-api-server /bin/bash
$ ...
```

### Erro: Cannot find module '/var/www/app/node_modules/bcrypt/lib/binding/napi-v3/bcrypt_lib.node
    ```sh
    # No arquivo `api/entrypoint-dev.sh`, descomente a linha `npm rebuild && `

    #!/bin/bash
    # npm rebuild &&    DESCOMENTAR 
    npm install -y &&
    ## npm run build -y &&
    npm run start:debug
    ``` 
  - Suba os containers novamente  com `docker-compose -f docker-compose.prod.yml up`