## Goals of the project:
    - replicate the "replicable"
        The opfvta analysis was designed with replication in mind
            - it preserved provinence
            - declared dependencies
            - used portage (the gentoo package manager)
    - Deliver a "time capsule" container image that needs only be executed to replicate
            - Frozen code versions
            - Pinned version of upstream reference data
            - Pinned version of data collected for opfvta analysis
    - Explore the benefits of YODA layout
    - Practice datalad
    - Create "re-execution" pattern for ReproMan
    - Design the container image so it is:
        - rebuildable (allows updates to dependencies)
        - built container is guaranteed to run
    - open the door to "continually verified results"


## Summary of original paper

## Dataset layout, YODA, and reproducibile execution

## Building Container Images, and reproducible builds

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
1. Connecting to ReproMan


## Procedure for re-execution

## Toward "Continually Verified Results"








        package manager) to
