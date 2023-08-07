# Opfvta

This is a yoda-style[TODO cite] repository that contains all of the
code, data, configuration, and prose to generate an article replicating
the [TODO original cite].

## How to clone this repository

This repository (and all yoda-style repos) contain submodules/subdatasets, which should be installed alongside the parent repository:

```console
datalad install -r https://github.com/con/opfvta-replication-2023.git
cd opfvta-replication-2023
```

Some of the subdatasets/submodules are git-annex enabled, which means
that we can use datalad to retrieve the files (which are just
references, no "bits").

TMP: Add smaug remote (need access):

SshConfig
```bash
Host smaug smaug.dartmouth.edu
  Hostname smaug.dartmouth.edu
  AddKeysToAgent yes
  port 11110
  user <username>
```

<!-- TODO: should be publicly available  -->
`git remote add smaug smaug:/mnt/btrfs/datasets/incoming/con/opfvta-replication-2023.git`
`datalad get . -s smaug`

`git remote add gin https://gin.g-node.org/TheChymera/mouse-brain-templates`
`datalad get . -s gin`

Run `datalad get .` for each git-annex enabled repository below:
<!--  - /opfvta-replication-2023/ -->
 - /opfvta-replication-2023/code/opfvta
 - /opfvta-replication-2023/inputs/opfvta_bidsdata
<!-- This will eventuall be datalad get -r . but not until the osf remote is -->
<!-- updated. -->
<!--  -->

<!-- ## With datalad  -->
<!-- `pip install datalad-osf` -->
<!-- `datalad clone https://finalpushtoOSF -->

## How to build and use the images

### Analysis image

This container executes all parts of the original work:
    - preprocessing
    - analysis
    - data visualization rendering
    - latex rendering into original article with updated data

Configure the variables at the top of the root level makefile (provided
values are what we used). Then the OCI image can be built with:

`make oci-build`

The OCI container can be run with the following command.
We require the scratch directory to be explicitly specified, as it will end up containing large amounts of data (in excess of 200 GB), and any default might accidentally clutter a difficult to locate directory.

`OPFVTA_SCRATCH_DIR="/your/cache/dir" make oci-run`

The container image can be pushed to a container registry:

`make push`

You may need to build a singularity/apptainer image with the following
command:

`make apptainer-build`

After the apptainer image is built, it will need to be committed and the
new bits pushed to a git annex enabled repository.

### LaTeX builder image

This container renders the LaTeX for the replication paper. The image is
blang/latex with some extra dependencies.

```shell
make build-latex
```

The paper can be rendered into a pdf with:

```shell
cd paper/source/
make article
```
