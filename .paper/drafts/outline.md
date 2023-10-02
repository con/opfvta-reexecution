## Goals of the project:

  The opfvta analysis was designed with replication in mind
    - it preserved provenance
    - declared dependencies
    - used portage (the gentoo package manager)
    - heavily scripted, "just press the button"
- Deliver a "time capsule" container image that needs only be executed to replicate
    - Frozen code versions
    - Pinned version of upstream reference data
    - Pinned version of data collected for opfvta analysis
- Create "re-execution" pattern for ReproMan
- Design the container image so it is:
    - rebuildable (allows updates to dependencies)
    - built container image is guaranteed to run

### Just for me (not in paper)

- Explore the benefits of YODA layout
- Practice datalad

## Dataset layout, YODA, and reproducible execution

Explanation of nested dataset layout

For each subdataset: what it is, why it is a subdataset.

## Building Container Images, and reproducible builds

Reproducible builds:

- Containerfile should be distributed with research
- use fully qualified images FROM docker.io/gentoo/stage3 not
    gentoo/stage3
- Pin dependencies in package manager for "releases" (to produce the
    image used for final analysis)
- Pin base images for reproducible builds FROM docker.io/gentoo/stage3:20230424
- Record the hash of the final image
- mirror/cache dependencies for guaranteed reproducible builds

Distribution:

- bitbucket (no-annex)
- github (no-annex)
- OSF (annex, Sing image)
- dockerhub (OCI image)
- quay (OCI image redundant)

## Development Story

1. The Gentoo Ecosystem, rolling release
1. Slow iterations require improving the container build speed, cache, layers, 
1. Difficulties with reproducible builds, published container images are
   critical.
1. Separation of Concerns: 
    - Creating a "distribution" of version controlled components via
        subdatasets
    - Moving opinion to top level
    - Reduce/remove user-required domain-specific knowledge 
1. Storing the container image
    Contribute Containerfile to original opfvta
    OCI vs Singularity, push to OCI, use datalad for Sing
1. TODO: Connect to ReproMan

TODO: New feature: datalad-osf "publish"

We need to whitelist what will be displayed "in-tree" somehow on
OSF. This step can be done by hand?

From writers guide:

    The associated OSF project should centralise all supplementary material,
    raw txt/tex/docx/odf/etc files, and rendered PDF files, as well as links
    to online repositories hosting the material not on OSF; e.g. source
    code, curated repositories. Once accepted for publication, a submission
    will be copy-edited and relevant links added to the finalised PDF
    article, before indexation.
    
    A README document should contain a description of the structure of the
    OSF project.


## Discussion of Results

Horea says its remarkable how well the data held up. This isn't a
bitwise comparison, the analysis proceeds using randomly generated
values.

## Procedure for re-execution

(Render from README.md?)

- Installation:
    - datalad, datalad-osf, podman/docker
    - memory requirements > 16gb (Test 32)
- datalad install
- make build
- make run -> outputs
- how to run analysis

## Toward "Continually Verifiable Results"

- replicable design
- time-machine container images
- reproducible container image builds
- limiting required knowledge of the reproducer
