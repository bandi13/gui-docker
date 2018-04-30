docker build -t vnc-webclient . && \
docker run --shm-size=256m -it -p 5900:5900 -p 5901:5901 -p 5902:5902 vnc-webclient
