# README

This project is mainly used to demonstrate how to use privatized deployment (Self-Hosted).

Since the current official image that incorporates [Generic OAuth2 Authentication](https://github.com/outline/outline/pull/2388/files) has not yet been provided, I temporarily constructed a temporary image, which can be directly switched to the official image after the official launch of `0.58.3`.

## Project Dependency

- Traefik: `traefik:v2.5`
    - Used as a service gateway for various applications, providing service discovery, domain name binding and other functions.
- Outline Server: `soulteary/outline:0.58.3`
    - Before the official version is updated, temporarily customized outline service.
- S3 Server: `minio/minio:RELEASE.2021-09-03T03-56-13Z`
    - Provide object storage capabilities.
- SSO Server: `soulteary/sso-server:1.1.5`
    - Make it possible for the outline to log in locally.
- Database: `postgres:13.3`
    - Store all document related data.
- Redis: `redis:6.2.4`
    - Cache service to make your application run faster.
- Attachment: `andreimarcu/linx-server:version-2.3.8`
    - Outline currently does not support attachments, this small tool can be used as a supplement.

### Usage

0. Make a copy of the default configuration `.env.example` and save the file name as `.env`. Modify the content in  according to your needs, such as domain name, various "user names" and "passwords".

```bash
cp .env.example .env
```

1. According to your actual situation, create a virtual network card to provide in-container and external services.

```bash
docker network create traefik
docker network create outline
```

2. Use docker-compose to start the service. Wait for the status of all services to become `healthy`.

```bash
docker-compose -f docker-compose.postgres.yml -f docker-compose.redis.yml -f docker-compose.minio.yml -f docker-compose.attachment.yml -f docker-compose.sso.yml -f docker-compose.outline.yml up -d
Creating outline_minio    ... done
Creating outline-postgres ... done
Creating outline-redis    ... done
Creating linx-server      ... done
Creating outline          ... done
Creating sso-server       ... done
```

3.  Use docker-compose to check if the service is ready.


```bash
docker-compose -f docker-compose.postgres.yml -f docker-compose.redis.yml -f docker-compose.minio.yml -f docker-compose.attachment.yml -f docker-compose.sso.yml -f docker-compose.outline.yml ps   
      Name                    Command                  State        Ports  
---------------------------------------------------------------------------
linx-server        /usr/local/bin/linx-server ...   Up (healthy)   8080/tcp
outline            docker-entrypoint.sh sh -c ...   Up (healthy)   3000/tcp
outline-postgres   docker-entrypoint.sh postgres    Up (healthy)   5432/tcp
outline-redis      docker-entrypoint.sh redis ...   Up (healthy)   6379/tcp
outline_minio      /usr/bin/docker-entrypoint ...   Up (healthy)   9000/tcp
sso-server         docker-entrypoint.sh ./main      Up (healthy)   80/tcp   
```

4. Open the browser and enjoy.

