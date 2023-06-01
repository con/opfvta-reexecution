# We must allow others exactly use our script without modification
# Or its not replicable by others.
#
REGISTRY=docker.io
REPOSITORY=asmacdo

LATEX_IMAGE_NAME=latex-biber
LATEX_TAG=0.0.0-alpha

IMAGE_NAME=opfvta
IMAGE_TAG=2.0.0-alpha

FQDN_IMAGE=${REGISTRY}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}
FQDN_LATEX_IMAGE=${REGISTRY}/${REPOSITORY}/${LATEX_IMAGE_NAME}:${LATEX_TAG}

DISTFILE_CACHE_CMD :=
OPFVTA_SCRATCH_DIR :=

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

ifeq ($(DISTFILE_CACHE_PATH),)
    # If not set, don't add it as an option
else
    DISTFILE_CACHE_CMD =-v $(DISTFILE_CACHE_PATH):/var/cache/distfiles 
endif

build:
	podman build . $(DISTFILE_CACHE_CMD) \
		-f code/images/Containerfile \
		-t ${FQDN_IMAGE}

build-latex:
	podman build . $(DISTFILE_CACHE_CMD) \
		-f code/images/Containerfile.latex \
		-t ${FQDN_LATEX_IMAGE}

push:
	podman push ${FQDN_IMAGE}

run:
	$(call check_defined, OPFVTA_SCRATCH_DIR)
	podman run \
		-it \
		--rm \
		-v ${PWD}/inputs/opfvta_bidsdata:/usr/share/opfvta_bidsdata \
		-v ${PWD}/inputs/mouse-brain-templates:/usr/share/mouse_brain_atlases \
		-v ${PWD}/outputs/:/outputs \
		-v ${OPFVTA_SCRATCH_DIR}:/root/.scratch \
		-v ${PWD}/code/:/opt/src/ \
		${FQDN_IMAGE} \
		/bin/bash


		# /opt/src/produce-analysis.sh
