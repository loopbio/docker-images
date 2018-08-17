# See https://docs.docker.com/docker-cloud/builds/push-images/
# Password: you should have it, otherwise ask me (Santi)
export DOCKER_ID_USER="loopbio"
docker login -u loopbio
docker push ${DOCKER_ID_USER}/linux-anvil-cudnn
