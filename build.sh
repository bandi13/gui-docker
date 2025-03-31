CUR_DATE=$(date -u +%F)

docker build -t bandi13/gui-docker:${CUR_DATE} -f Dockerfile . && docker tag bandi13/gui-docker:${CUR_DATE} bandi13/gui-docker:latest && \
    docker build -t bandi13/gui-docker:firefox_${CUR_DATE} -f Dockerfile.firefox . && docker tag bandi13/gui-docker:firefox_${CUR_DATE} bandi13/gui-docker:firefox && \
    docker build -t bandi13/gui-docker:chrome_${CUR_DATE} -f Dockerfile.chrome . && docker tag bandi13/gui-docker:chrome_${CUR_DATE} bandi13/gui-docker:chrome

if [ $? -eq 0 ]; then
    echo "Push containers to DockerHub [y/N]? "
    read val
    if [ "$val" = "y" ]; then
        docker push bandi13/gui-docker:${CUR_DATE} && docker push bandi13/gui-docker:latest && \
        docker push bandi13/gui-docker:firefox_${CUR_DATE} && docker push bandi13/gui-docker:firefox && \
        docker push bandi13/gui-docker:chrome_${CUR_DATE} && docker push bandi13/gui-docker:chrome
    fi
fi
