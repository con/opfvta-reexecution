# We must allow others exactly use our script without modification
# Or its not replicable by others.
#
REGISTRY=docker.io
REPOSITORY=asmacdo

IMAGE_NAME=opfvta
IMAGE_TAG=2.0.0-alpha

FQDN_IMAGE=${REGISTRY}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}

DISTFILE_CACHE_CMD := ""

ifeq ($(DISTFILE_CACHE_PATH),)
    # If not set, don't add it as an option
else
    DISTFILE_CACHE_CMD =-v $(DISTFILE_CACHE_PATH):/var/cache/distfiles
endif

build:
	podman build . $(DISTFILE_CACHE_CMD) \
		-f code/opfvta-images/Containerfile \
		-t ${FQDN_IMAGE}

push:
	podman push ${FQDN_IMAGE}

run:
	# TODO
	ifndef OPFVTA_SCRATCH_DIR
	$(error OPFVTA_SCRATCH_DIR is not set)
	endif
	podman run \
		-it \
		--rm \
		-v inputs/opfvta-bids:/usr/share/opfvta_bidsdata \
		-v inputs/mouse-brain-templates-0.5.3:/usr/share/mouse_brain_atlases \
		-v ${OPFVTA_SCRATCH_DIR}:/root/.scratch
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
