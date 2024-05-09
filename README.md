## XRDP Server for GUI in Docker Container

This is a Linux development environment running under Docker that works
on Apple Silicon.

Forked from [satishweb/docker-xrdp](https://github.com/satishweb/docker-xrdp).
Upgraded Ubuntu, added some more basic dev tools, especially for Python.

### Setup
`echo "xfce4-session" > /etc/skel/.Xclients`

### Building

Standard docker build:

`docker build -t chGoodchild/xrdp .`
`docker build --no-cache -t chGoodchild/xrdp .`

On OSX on Apple Silicon, you need to run:

`docker buildx build --platform=linux/amd64 -t chGoodchild/xrdp .`

### How to run the container:

With `/home/guest` bound from the local directory:
`docker run --rm -it -p 3389:3389 -v $(pwd)/home/guest:/home/guest chGoodchild/xrdp`

Without binding `/home/guest`:
`docker run --rm -it -p 3389:3389 chGoodchild/xrdp`


Connect to the container using the remote desktop client on localhost:3389 and login with user guest and password guest

### To free port 3389:

sudo lsof -i :3389