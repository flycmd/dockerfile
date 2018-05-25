# dockerfile php7 nginx

## 环境容器配置
ubuntu:16.04
PHP:7.0.21

### 扩展
安装redis和mongo需要先添加源

```bash
add-apt-repository ppa:ondrej/php
```

- PHP-FPM `apt-get install php7.0-fpm -y`
- Redis `apt-get install -y php-redis`
- mongo `apt-get install -y php-mongodb`
- mysql
- curl
- gd `apt-get install -y php-gd`

## 构建镜像
```bash
docker build -t 52cx/php7-nginx-tp5:stable .
```

## 运营容器命令
```bash
docker run -d --name=myphp72 --restart=always -p 100:80 -v /Users/flycmd/Documents/Docker/www:/var/www {name:version}
```

```bash
docker run -d --name={容器名称} --restart=always -p {主机端口号}:{容器端口号} -v {主机的目录}:{容器的目录} {镜像名字}
```

## ssh到容器

```bash
docker exec -it {id} /bin/bash
```

