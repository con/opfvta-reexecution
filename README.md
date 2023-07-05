# Opfvta

This is a yoda-style[TODO cite] repository that contains all of the
code, data, configuration, and prose to generate an article replicating
the [TODO original cite].

## How to clone this repository

This repository (and all yoda-style repos) contain.
submodules/subdatasets.

`datalad install -r https://github.com/con/opfvta-replication-2023.git`
`cd opfvta-replication-2023`

Some of the subdatasets/submodules are git-annex enabled, which means
that we can use datalad to retrieve the files (which are just
references, no "bits").

Run `datalad get .` for each git-annex enabled repository below:
<!--  - /opfvta-replication-2023/ -->
 - /opfvta-replication-2023/code/opfvta
 - /opfvta-replication-2023/inputs/mouse-brain-templates
 - /opfvta-replication-2023/inputs/opfvta_bidsdata
 - TMP: opfvta-replication  use `datalad get . -s smaug`
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
values are what we used). Then the image can be built with:

```shell
make build
```

The container can be run with the following command.
We require the scratch directory to be explicitly specified, as it will end up containing large amounts of data (in excess of 200 GB), and any default might accidentally clutter a difficult to locate directory.

```shell
OPFVTA_SCRATCH_DIR="/your/cache/dir" make run
```

The container image can be pushed to a container registry:

```shell
make push
```

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
