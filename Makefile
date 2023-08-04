# We must allow others exactly use our script without modification
# Or its not replicable by others.
#
REGISTRY=docker.io
REPOSITORY=asmacdo

LATEX_IMAGE_NAME=latex-biber
LATEX_TAG=0.0.1-alpha

IMAGE_NAME=opfvta
IMAGE_TAG=2.0.0-alpha

FQDN_IMAGE=${REGISTRY}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}
FQDN_LATEX_IMAGE=${REGISTRY}/${REPOSITORY}/${LATEX_IMAGE_NAME}:${LATEX_TAG}

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
	@echo "analysis, run  make oci-run  or make apptainer-run.  Please check "
	@echo "README.md for more information."
	$(MAKE) article

.PHONY: article
article:
	$(MAKE) -C paper/source

oci-build:
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

reproman-run-apptainer:
	reproman run -r discovery --sub slurm --orc datalad-no-remote \
		--jp num_processes=16 \
		--jp num_nodes=1 \
		--jp walltime=120:00:00 \
		make sing-run

apptainer-run:
	singularity run \
		-B ${PWD}/inputs/opfvta_bidsdata:/usr/share/opfvta_bidsdata \
		-B ${PWD}/inputs/mouse-brain-templates/mouse-brain-templates:/usr/share/mouse_brain_atlases \
		-B ${PWD}/outputs/:/outputs \
		-B /dartfs-hpc/scratch/f006rq8:/scratch \
		-B ${PWD}/code/:/opt/src/ \
		--pwd /opt/src/ \
		code/images/opfvta-singularity/opfvta.sing \
		./produce-analysis.sh

apptainer-build:
	singularity build opfvta.sing docker://${FQDN_IMAGE}

populate-data:
	datalad get inputs/mouse-brain-templates/mouse-brain-templates/abi2dsurqec_40micron_annotation.nii inputs/mouse-brain-templates/mouse-brain-templates/abi2dsurqec_40micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/abi_40micron_annotation.nii inputs/mouse-brain-templates/mouse-brain-templates/abi_40micron_average.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_40micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_40micron.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_40micron_labels.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_40micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_40micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_40micron.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_40micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_40micron.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_40micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_40micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/abi_200micron_average.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_200micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_200micron.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc_200micron_roi-dr.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_200micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_200micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_200micron.nii inputs/mouse-brain-templates/mouse-brain-templates/dsurqec_200micron_roi-dr.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_200micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_200micron.nii inputs/mouse-brain-templates/mouse-brain-templates/lambmc_200micron_roi-dr.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_200micron_masked.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_200micron_mask.nii inputs/mouse-brain-templates/mouse-brain-templates/ldsurqec_200micron_roi-dr.nii inputs/mouse-brain-templates/mouse-brain-templates/ambmc2dsurqec_15micron_masked.obj
	datalad get inputs/opfvta_bidsdata
	datalad get code/images/opfvta-singularity

oci-run:
	docker run \
		-it \
		--rm \
		-v ${PWD}/inputs/opfvta_bidsdata:/usr/share/opfvta_bidsdata \
		-v ${PWD}/inputs/mouse-brain-templates/mouse-brain-templates:/usr/share/mouse_brain_atlases \
		-v ${PWD}/outputs/:/outputs \
		-v ${OPFVTA_SCRATCH_DIR}:/root/.scratch \
		-v ${PWD}/code/:/opt/src/ \
		${FQDN_IMAGE} \
		./produce-analysis.sh
