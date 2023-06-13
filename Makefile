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

push-latex:
	podman push ${FQDN_LATEX_IMAGE}

reproman-run:
	reproman run -r local --sub slurm --datalad no-remote \
		--bp sub=TODO \
		--jp num_processes=TODO \
		--jp num_nodes=TODO \
		--jp walltime=TODO \
		--jp queue=TODO \
		--jp launcher=true \
		--jp job_name=TODO \
		--jp mail_type=END \
		--jp mail_user="austin@dartmouth.edu" \
		--jp "container=TODO" \
		--jp killjob_factors="TODO" \
		?sourcedata/raw \
		?scratchpath \
		participant --participant-label ?? \
		-w TODOworkdir \
		thecommand

build-singularity:
	singularity build opfvta.sing docker://${FQDN_IMAGE}

populate-data:
	datalad get inputs/mouse-brain-templates/mouse-brain-templates/abi2dsurqec_40micron_annotation.nii inputs/mouse-brain-templates/mouse-brain-templates/abi2dsurqec_40micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/abi_40micron_annotation.nii inputs/mouse-brain-templates/mouse-brain-templates/abi_40micron_average.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_40micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_40micron.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_40micron_labels.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_40micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_40micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_40micron.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_40micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_40micron.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_40micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_40micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/abi_200micron_average.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_200micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_200micron.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_200micron_roi-dr.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_200micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_200micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_200micron.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_200micron_roi-dr.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_200micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_200micron.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_200micron_roi-dr.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_200micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_200micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_200micron_roi-dr.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc2dsurqec_15micron_masked.obj
	datalad get inputs/opfvta_bidsdata
run:
	$(call check_defined, OPFVTA_SCRATCH_DIR)
	podman run \
		-it \
		--rm \
		-v ${PWD}/inputs/opfvta_bidsdata:/usr/share/opfvta_bidsdata \
		-v ${PWD}/inputs/mouse-brain-templates/mouse-brain-templates:/usr/share/mouse_brain_atlases \
		-v ${PWD}/outputs/:/outputs \
		-v ${OPFVTA_SCRATCH_DIR}:/root/.scratch \
		-v ${PWD}/code/:/opt/src/ \
		${FQDN_IMAGE} \
		/bin/bash


		# /opt/src/produce-analysis.sh
