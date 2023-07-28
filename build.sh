docker build -t bandi13/gui-docker:latest -f Dockerfile .
docker build -t bandi13/gui-docker:firefox -f Dockerfile.firefox .
docker build -t bandi13/gui-docker:chrome -f Dockerfile.chrome .
