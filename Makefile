# We must allow others exactly use our script without modification
# Or its not replicable by others.
#
REGISTRY=docker.io
REPOSITORY=centerforopenneuroscience

LATEX_IMAGE_NAME=latex-biber
LATEX_TAG=0.0.1-beta

IMAGE_NAME=opfvta
IMAGE_TAG=2.0.0-alpha

FQDN_IMAGE=${REGISTRY}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}
FQDN_LATEX_IMAGE=${REGISTRY}/${REPOSITORY}/${LATEX_IMAGE_NAME}:${LATEX_TAG}

# PATH for scratch directory storing intermidiate results etc;
# By default -- all data including intermediate results are under this folder (YODA!)
ifeq ($(SCRATCH_PATH),)
	SCRATCH_PATH = $(PWD)/scratch
endif

OCI_BINARY?=docker
SING_BINARY?=singularity

DISTFILE_CACHE_CMD :=

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


.PHONY: all
all:
	@echo "Invoking default rule, which will just attempt to build the paper "
	@echo "without redoing the analysis.  If you would like to redo the entire "
	@echo "analysis, run  make analysis-oci or some other analysis-* flavor (check Makefile). "
	@echo "See README.md for more information."
	$(MAKE) article

#
# Data analysis
#
analysis-reproman:
	reproman run \
		-r discovery --sub slurm --orc datalad-no-remote \
		--jp num_processes=16 \
		--jp num_nodes=1 \
		--jp walltime=120:00:00 \
		make analysis-singularity

# These don't work:
#SCRATCH_PATH?=/dartfs-hpc/scratch/$(USER)
#$(eval if [[ -z "$SCRATCH_PATH" ]]; then SCRATCH_PATH="/home/user/$(USER)/.scratch"; fi)
#$(eval SCRATCH_PATH?="/home/user/$(USER)/.scratch")
#$(eval SCRATCH_PATH ?= "/home/user/$(USER)/.scratch")
#SCRATCH_PATH ?= "/home/user/$(USER)/.scratch"
#SCRATCH_PATH = $(if $(SCRATCH_PATH),$(SCRATCH_PATH),"/home/user/$(USER)/.scratch")

analysis-singularity:
	set -eu
	$(if $(USER),,$(error USER is not defined and currently required for the SCRATCH_PATH variable))
	@echo "Selected \`SCRATCH_PATH\` $(SCRATCH_PATH). You may want to customize this by setting it on the command line, after the make command, i.e. \`make SCRATCH_PATH=... target\`."
	mkdir -p $(SCRATCH_PATH)
	$(SING_BINARY) run \
		-e --no-home \
		-B ${PWD}:/opt \
		-B ${PWD}/inputs/opfvta_bidsdata:/usr/share/opfvta_bidsdata \
		-B ${PWD}/inputs/mouse-brain-templates/mouse-brain-templates:/usr/share/mouse_brain_atlases \
		-B $(SCRATCH_PATH):$(HOME)/.scratch/ \
		-B ${PWD}/code/empty:/opfvta/ \
		--pwd /opt/code \
		code/images/opfvta-singularity/opfvta.sing \
		./produce-analysis.sh singularity

analysis-oci:
	$(OCI_BINARY) run \
		-it \
		--rm \
		-v ${PWD}:/opt \
		-v ${PWD}/inputs/opfvta_bidsdata:/usr/share/opfvta_bidsdata \
		-v ${PWD}/inputs/mouse-brain-templates/mouse-brain-templates:/usr/share/mouse_brain_atlases \
		-v ${SCRATCH_PATH}:/root/.scratch \
		-v ${PWD}/code/empty:/opfvta/ \
		--workdir /opt/code \
		${FQDN_IMAGE} \
		./produce-analysis.sh ${OCI_BINARY}

analysis-oci-interactive:
	$(OCI_BINARY) run \
		-it \
		--rm \
		-v ${PWD}:/opt \
		-v ${PWD}/inputs/opfvta_bidsdata:/usr/share/opfvta_bidsdata \
		-v ${PWD}/inputs/mouse-brain-templates/mouse-brain-templates:/usr/share/mouse_brain_atlases \
		-v ${SCRATCH_PATH}:/root/.scratch \
		-v ${PWD}/code/empty:/opfvta/ \
		--workdir /opt/code \
		${FQDN_IMAGE} \
		/bin/bash

#
# Paper build
#
.PHONY: container-article
container-article:
	$(MAKE) container-article -C article/

.PHONY: article
article:
	$(MAKE) -C article/

.PHONY: article-clean
article-clean:
	$(MAKE) article-clean -C article/

.PHONY: article-upload
article-upload:
	$(MAKE) upload -C article/


#
# Containers management. oci- for Open Container Initiative
#
# Build data analysis container
analysis-oci-image:
	$(OCI_BINARY) build . $(DISTFILE_CACHE_CMD) \
		-f code/images/Containerfile \
		-t ${FQDN_IMAGE}

analysis-singularity-image:
	datalad install code/images/opfvta-singularity
	rm code/images/opfvta-singularity/opfvta.sing
	$(SING_BINARY) build code/images/opfvta-singularity/opfvta.sing docker://${FQDN_IMAGE}

# Build latex environment container
latex-oci-image:
	$(OCI_BINARY) build . $(DISTFILE_CACHE_CMD) \
		-f code/images/Containerfile.latex \
		-t ${FQDN_LATEX_IMAGE}

# Push containers
analysis-oci-push:
	$(OCI_BINARY) push ${FQDN_IMAGE}

latex-oci-push:
	$(OCI_BINARY) push ${FQDN_LATEX_IMAGE}


#
# Aux rules
#
# Fix and test this
submodule-data:
	cat inputs.txt | xargs datalad get
	datalad get inputs/opfvta_bidsdata/*
	datalad get code/images/opfvta-singularity/*
	datalad get code/opfvta/*


