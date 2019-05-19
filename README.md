docker-maven-alpine
===

Minimal alpine container, with maven, docker(cli binary only) and ssh/scp support, used for continuous build and remote deployment within [jenkins' pipeline](https://jenkins.io/doc/book/pipeline/docker).

Base on the official 
[maven](https://hub.docker.com/_/maven):[jdk-8-alpine](https://github.com/carlossg/docker-maven/tree/master/jdk-8-alpine) container.
 - `docker version` : `18.09.6`
 - `maven version` : `3.6.1`

## How to use (running docker instructions)
Since this image only contains the docker cli binary, it needs to work with the host docker engine, you need to mount the `/var/run/docker.sock` to it:
```
# start container
docker run -it \
  -v /var/run/docker.sock:/var/run/docker.sock \  # mapping host's docker communitation socket
  -v $HOME/.m2:/root/.m2 \                        # storing maven dependencies in host machine and reuse it
  -v $HOME/.ssh/:/root/.ssh \                     # mapping host's ssh secrets for ssh/scp without password
  backflow/maven-alpine
```

    
| **ENTRYPOINT** | **CMD** |
|:---:|:---:|
| `/usr/local/bin/mvn-entrypoint.sh` | `mvn` |

## Using another docker version
Example building a new image with another docker/maven version :

    docker build --build-arg DOCKER_VERSION="18.09.6" --build-arg MAVEN_VERSION="3.6.1" -t IMAGE:TAG .
    docker run IMAGE:TAG
