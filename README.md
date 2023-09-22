# OPFVTA Reexecution Study
[![PDF document](https://badgen.net/badge/PDF/manual%20record/yellow)](https://articles.chymera.eu/fraaef.pdf)

This repository contains code, data, and prose as required to:
* re-execute the OPFVTA article in a container environment.
* generate a meta-article, detailing the reexecution environment and including a reference example of how to inspect reproducibility across reexecutions.

## How to clone this repository

This repository contains submodules/subdatasets, which should be installed alongside the parent repository:

```console
datalad install -r https://gin.g-node.org/TheChymera/opfvta-replication-2023.git
cd opfvta-replication-2023
```


## How to re-run

<<<<<<< HEAD
**Note:** *If the `SCRATCH_PATH` variable is not defined for the `make` invocation, all intermediary results (approx. 400GB) will be stored in the `scratch/` directory, which is inside the directory of the repository.
This might go beyond the available space on the respective partition, crashing the workflow and possibly other programs.
It is advisable to check space availability on your partition before full reexecution, and if sufficient space is unavailable specify a `SCRATCH_PATH` on a partition with more available space.*

There are 2 distinct phases of executing this study, which differ strongly in both time and space requirements.
While they are hierarchically related, the results of the first step are version tracked, meaning that you can choose to only run the latter.

### I. Reexecuting the OPFVTA Article

This is by far the most time consuming and resource-intensive step as it re-computes all work that was required to generate the original OPFVTA article, starting from the bare raw data.
The requirements of this step are therefore the raw data (study data and mouse brain templates), and the article code, which are included in this repository as submodules and whose content can be fetched via a dedicated `make` target:
=======
### Prerequisites

1. We estimate that the analysis required more than 500GB, 400GB of which will be stored in a scratch directory, which is `./scratch/` by default and can be configured with the `SCRATCH_PATH` variable.
1. The analysis self-limits RAM to run on less powerful systems

### I. Reexecuting the OPFVTA Article

::: warning
Reexecuting the computation as well as the article is time consuming and resource-intensive.
It is recommended to use a tool such as `tmux` or `screen` to preserve
long running processes.
:::


First, retrieve the data and other large files:
>>>>>>> 1434c85 (Clarify and simplify README)

```console
make submodule-data
```

Once the required content is fetched, you can reexecute the OPFVTA article via `singularity` or `oci` containers.
This step generates intermediate results in the scratch directory and are not preserved by default, as configured in `scratch/.gitignore`.
The final result is a PDF article and its associated elements (mainly volumetric binary data, `.nii.gz` files) which will be stored in a datestamped and annotated directory under `outputs/`.
Most large files, including the results are stored and versioned via `git-annex` and therefore present in this repository, and your output can also be saved and recorded.

For apptainer/singularity:

```console
make analysis-singularity
```
_or_

For OCI containers you can run with docker (default) or podman by setting the environment variable `OCI_BINARY=podman`

```console
make analysis-oci
```


### II. Reexecuting the Meta-Article

To avoid confusion, we use the term 'article' to refer to a version of the OPFVTA article, and 'meta-article' to refer to the paper regarding the reexecution process and findings.

Generation of the meta-article uses files generated by the OPFVTA analysis which are expected to be in the `outputs/` directory.
`outputs/` can be populated either by [Running the analysis](#I. Reexecuting the OPFVTA Article) or by fetching previously generated results.

To fetch the OPFVTA analysis outputs:

```console
datalad get outputs/*/article.pdf
```

Finally we generate new graphical elements and compile the text via LaTeX into a novel and fully distinct article PDF.

```console
make article
```

#### Cleaning up between runs

The steps are designed to be idempotent, and some dynamically generated components will not be regenerated for subsequent runs.
If you are not merely trying to get a PDF to read or working on the human-readable text — but instead working on the figure-generating code — it is advisable to always deep-clean the dynamic elements in between re-making the article.

```console
make article-clean && make article
```

## Internal

We openly share all code and data via the Gin repository referenced above.
This open infrastructure is however slow, which may be particularly inconvenient for prolonged development work.
Trusted collaborators may instead prefer to use the `smaug.dartmouth.edu` remote.

To use this remote you should:

1. Make sure you have SSH access to `smaug.dartmouth.edu`, and have configured the host via your config file; you can do so by running:

```console
cat >> ~/.ssh/config<< EOF
Host smaug
	Hostname smaug.dartmouth.edu
	AddKeysToAgent yes
	port 11110
	user <your_username_for_which_smaug_has_your_SSH_public_key>
EOF
```

2. Add the remote to the Git repository, and make sure you are synced up:

```console
cd path/to/your/repo
git remote add smaug smaug:/mnt/btrfs/datasets/incoming/con/opfvta-replication-2023.git
datalad get . -s smaug
```

