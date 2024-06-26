DOCKER_CHECK := $(shell which docker >/dev/null 2>&1; echo $$?)
ARCHISO_CHECK := $(shell which archiso >/dev/null 2>&1; echo $$?)

build_container: 
ifeq ($(DOCKER_CHECK), 0)
	@echo "Docker is installed, building image..."
	docker build -t openjl:latest ./
	docker run --rm --mount type=bind,source=./,target=/archiso --cap-add=SYS_ADMIN openjl:latest
	docker rmi openjl:latest
else
	$(error "Docker is not installed. Please install Docker and try again.")
endif
	
build:
ifeq ($(ARCHISO_CHECK), 0)
	@echo "archiso is installed, building iso file..."
	mkarchiso -v -w ./work -o ./out ./
else
	$(error "Archiso is not installed. Please install Archiso and try again, or try building it in using the container if you are not using Arch Linux or derivatives.")
endif

clean:
ifeq ($(shell id -u), 0)
	@echo "Removing work and out"
	rm -rf ./work
	rm -rf ./out
else
	$(error "You must be root to perform this action. Run 'sudo make clean' instead.")
endif