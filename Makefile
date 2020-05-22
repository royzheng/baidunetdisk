IMAGE_NAME=baidunetdisk
CONTAINER_NAME=bd
build:
		sudo docker build -t ${IMAGE_NAME} .
start:
		sudo docker run -d --name ${CONTAINER_NAME} -p 5901:5901 -p 6901:6901 ${IMAGE_NAME}

stop:
		sudo docker stop ${CONTAINER_NAME} | true
		sudo docker rm -f ${CONTAINER_NAME} | true

restart: stop start

