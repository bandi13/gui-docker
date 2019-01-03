docker build -t gui-docker . && docker run --shm-size=256m -it -p 5900:5900 -p 5901:5901 gui-docker
