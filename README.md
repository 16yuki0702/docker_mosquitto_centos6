## Description
  This is my development environment for hack mosquitto on CentOS6. 
  It includes websocket, and mosquitto_pyauth.  
  If you want to know about websockt please read below link. It use libwebsockets.  
  https://libwebsockets.org/  
  And If yout want to know about mosquitto_pyauth, please read below link.  
  https://github.com/mbachry/mosquitto_pyauth  

## Requirement
  You need docker environment. please install from below.  
  mac : https://docs.docker.com/docker-for-mac/install/  
  windows : https://docs.docker.com/docker-for-windows/install/

## Usage
  First of all, clone project.
```bash
$ git clone this url
```

  And change your current directory to this project exists.  
```bash
$ cd /path/to/project
```

  Build docker image. below is example. please change image name and tag according to your preferences.  
```bash
docker build -t dev:latest .
```

  Run container. expose ports for http, mqtt and websockets.  
```bash
$ docker run -it -p 80:80 -p 1883:1883 -p8080:8080 --rm --name dev dev:latest
```

  In the container, you can run mosquitto as service. command is below.
```bash
$ service mosquitto start
```

that's all.
enjoy.