# We must allow others exactly use our script without modification
# Or its not replicable by others.
#
REGISTRY=docker.io
REPOSITORY=asmacdo

IMAGE_NAME=opfvta
IMAGE_TAG=2.0.0-alpha

INPUT_NAME=opfvta_bidsdata
INPUT_TAG=2.1.0-alpha

REFERENCE_NAME=mouse_templates_atlases
REFERENCE_TAG=1.0.0-alpha

FQDN_IMAGE=${REGISTRY}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}
FQDN_INPUT_DATA=${REGISTRY}/${REPOSITORY}/${INPUT_NAME}:${INPUT_TAG}
FQDN_REFERENCE_DATA=${REGISTRY}/${REPOSITORY}/${REFERENCE_NAME}:${REFERENCE_TAG}
# Build and push to both?
# APPTAINER_REGISTRY=""

build-fresh:
		# -v ${DISTFILE_CACHE_PATH}:/var/cache/distfiles
	podman build . \
		--no-cache \
		-f containerization/Containerfile \
		-t ${FQDN_IMAGE}

build-base:
		# -v ${DISTFILE_CACHE_PATH}:/var/cache/distfiles
	podman build . \
		-f containerization/Containerfile.base \
		-t opfvta-base

build:
		# -v ${DISTFILE_CACHE_PATH}:/var/cache/distfiles
	podman build . \
		-f containerization/Containerfile \
		-t ${FQDN_IMAGE}

# build-opfvta-bidsdata:
# 	podman build . \
# 		-f ../input_data/Containerfile \
# 		-t ${FQDN_INPUT_DATA}

# build-mouse-templates-atlases:
# 	podman build . \
# 		-f ../reference_data/Containerfile \
# 		-t ${FQDN_REFERENCE_DATA}



# TODO RM
# push-dev-only:
# 	podman push ${FQDN_IMAGE}
# 	podman push ${FQDN_INPUT_DATA}
# 	podman push ${FQDN_REFERENCE_DATA}

push:
	podman push ${FQDN_IMAGE}

# mouse-volume: build-mouse-templates-atlases
# 	podman volume rm input_data -f
# 	# IDK if this hack actually works
# 	podman volume create input_data
# 	# Its annoying I have to run a container for this? Can i endit?
# 	podman run \
# 		-d \
# 		-it \
# 		--rm \
# 		-v input_data:/input_volume \
# 		${FQDN_INPUT_DATA} \
# 		/bin/sh
#
# scatch:
# 	podman volume create output

# Notice this doesnt drop you into a shell and the container is deleted after use
run:
	podman run \
		-it \
		--rm \
		-v ../input_data/opfvta-bids:/usr/share/opfvta_bidsdata \
		-v ../reference_data/mouse-brain-templates-0.5.3:/usr/share/mouse_brain_atlases \
		-v ../top_level_data/:/root/.scratch
		${FQDN_IMAGE}

# Use this to run a shell
handtest:
	podman run \
		-it \
		-v input_data:/usr/share/opfvta_bidsdata \
		-v reference_data:/TODOWHEREDOESTHISGO \
		-v output:/root/.scratch \
		${FQDN_IMAGE} \
		/bin/bash
