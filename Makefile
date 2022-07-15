# NO WARRANTY. THIS DEFENSE INNOVATION UNIT MATERIAL MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING,
# BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE
# OF THE MATERIAL. THE DEFENSE INNOVATION UNIT DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM
# PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.

# Globals
SHELL:=/bin/bash
CURRENT_DIR_ABS_PATH:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

# TODO: Environment including middleware invocation from .env(s)
ENV_FILENAME:=.env
ENV_MAKE_FILENAME:=.env.make
ENV_ABS_PATH:=$(CURRENT_DIR_ABS_PATH)/infrastructure
ENV_MIDDLEWARE_SCRIPT_ABS_PATH:=$(CURRENT_DIR_ABS_PATH)/resources/scripts/make/env.make.sh
ENV_MIDDLEWARE_SOURCE_ABS_PATH:=$(ENV_ABS_PATH)/$(ENV_FILENAME)
ENV_MIDDLEWARE_TARGET_ABS_PATH:=$(ENV_ABS_PATH)/$(ENV_MAKE_FILENAME)
IGNORE:=$(shell /bin/bash $(ENV_MIDDLEWARE_SCRIPT_ABS_PATH) $(ENV_MIDDLEWARE_SOURCE_ABS_PATH) $(ENV_MIDDLEWARE_TARGET_ABS_PATH))
include $(ENV_MIDDLEWARE_TARGET_ABS_PATH)

# - Colors
COLOR_RED   :=$(shell printf '\033[0;31m')
COLOR_BLUE  :=$(shell printf '\033[0;34m')
COLOR_GREEN :=$(shell printf '\033[0;32m')
COLOR_NONE  :=$(shell printf '\033[0m')

# - Docker Composition State; Development Override
DOCKER_COMPOSE_DEVELOPMENT_OVERRIDE:=$(shell /bin/bash -c "if [ \"${DEPLOY_DEVELOPMENT}\" = true ]; then /bin/echo '-f ./docker-compose.dev.yml'; fi")

# ----------------------------------------------------------- #

# TODO: All (default); add test
.PHONY: all
all: \
	initialize \
	build \
	clean \
	deploy

# Docker Clean
.PHONY: clean
clean: \
	docker-image-prune \
	make-prune
docker-image-prune:
	@echo "y" | /bin/docker image prune
	@echo -e "${COLOR_BLUE}[make]:${COLOR_NONE} Docker images pruned."
make-prune:
	/bin/rm $(ENV_MIDDLEWARE_TARGET_ABS_PATH)


# Repository and Docker Initialize
initialize:
	/bin/mkdir -p ./.cache && /bin/chmod 775 ./.cache
	cd ./data; /bin/unzip -u \*.zip
	@echo -e "${COLOR_BLUE}[make]:${COLOR_NONE} Repository checkout initialized."


# Docker Build
.PHONY: build
build: \
	build-ammo \
	docker-image-prune
# - Base Image
IMAGE_NAME:=$(shell echo "${IMAGE_PREFIX}/${IMAGE_NAMESPACE}")
build-ammo:
	cd infrastructure; COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f ./docker-compose.yml ${DOCKER_COMPOSE_DEVELOPMENT_OVERRIDE} -p "diu_ammo" --profile "server" build \
		--compress --progress=plain \
		--build-arg BASE_IMAGE=${UPSTREAM_IMAGE_NAME}:${UPSTREAM_IMAGE_TAG} \
		--build-arg BASE_USER=${BUILD_USER} \
		--build-arg ROOT_USER=${ROOT_USER} \
		--build-arg BASE_DIR="../.."
	@echo -e "${COLOR_BLUE}[make]:${COLOR_NONE} Built DIU AMMO image."


# Docker Deploy
.PHONY: deploy
deploy: deploy-server
deploy-server:
	cd infrastructure; docker-compose -f ./docker-compose.yml ${DOCKER_COMPOSE_DEVELOPMENT_OVERRIDE} -p "diu_ammo" --profile "server" up -d
	@echo -e "${COLOR_BLUE}[make]:${COLOR_NONE} Deployed DIU AMMO Server container(s)."

# Docker Destroy
destroy: destroy-server
destroy-server:
	cd infrastructure; docker-compose -f ./docker-compose.yml ${DOCKER_COMPOSE_DEVELOPMENT_OVERRIDE} -p "diu_ammo" --profile "server" down --remove-orphans
	@echo -e "${COLOR_BLUE}[make]:${COLOR_NONE} Destroyed DIU AMMO Server container(s)."
