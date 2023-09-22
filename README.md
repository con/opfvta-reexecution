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

**Note:** *If the `SCRATCH_PATH` variable is not defined for the `make` invocation, all intermediary results (approx. 400GB) will be stored in the `scratch/` directory, which is inside the directory of the repository.
This might go beyond the available space on the respective partition, crashing the workflow and possibly other programs.
It is advisable to check space availability on your partition before full reexecution, and if sufficient space is unavailable specify a `SCRATCH_PATH` on a partition with more available space.*

There are 2 distinct phases of re-running this study, which differ strongly in both time and space requirements.
while they are hierarchically related, the results of the first step are version tracked, meaning that you can choose to only run the latter.

### I. Reexecuting the OPFVTA Article

This is by far the most time consuming and resource-intensive step as it re-computes all work that was required to generate the original article, starting from the bare raw data.
The requirements of this step are therefore the raw data (study data and mouse brain templates), and the article code, which are included in this repository as submodules and whose content can be fetched via a dedicated `make` target:

```console
make submodule-data
```

Once the required content is fetched, you can reexecute the OPFVTA article via either of the following commands, depending on the desired platform:

```console
make analysis-singularity
```

```console
make analysis-oci
```

This produces a PDF article and its associated elements (mainly volumetric binary data, `.nii.gz` files) which will be stored in a datestamped and annotated directory under `outputs/`.
A number of outputs are recorded via `git-annex` and therefore present in this repository, and your output can also be saved and recorded.



### II. Reexecuting the Meta-Article

This uses the aforementioned PDF files in `outputs/` in order to generate dynamic graphical elements, and subsequently compiles them alongside the document text via LaTeX into a novel and fully distinct article PDF.
To avoid confusion, please make sure you understand this is *not* another version of the OPFVTA article but a fully different text.

This phase requires fetching the actual binary content for the myriad PDF outputs of OPFVTA reexecution, and then running the `make article` target:

```console
datalad get outputs/*/article.pdf
make article
```

A finer point here is that the dynamic elements of this article can be cached.
If you are not merely trying to get a PDF to read or working on the human-readable text — but instead working on the figure-generating code — it is advisable to always clean the dynamic elements in between re-making the article via the dedicated target.

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

