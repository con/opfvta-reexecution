# Re-analysis of Whole-brain opto-fMRI map of mouse VTA dopaminergic activation reflects structural projections with small but significant deviations
# Full Reexecution of Article Analyzing effective functional VTA connectivity

## Abstract

The study of ascending dopaminergic Ventral Tegmental Area (VTA) projections in mice is crucial to translational research investigating human motivation, learning, and addiction. 
A prior article produced the first whole-brain opto-fMRI map of VTA-originating dopamenergic activation in mice, which constitutes a key reference map.
Further, the authors argue that the article has significant value as an example implementation of a deep brain stumilation analysis workflow, and that the article is written with full reproducibility in mind.
Herein, we share the results of an effort to reexecute, further standardize, and preserve their workflow, and compre the reexecution results to ascertain analyis reproducibility.
By leveraging container technology and related best practices, we have improved the portability, provenance tracking, and ease of reexecution of the workflow. 
We further ascertain the reproducibility of the original findings, in light of common non-deterministic data processing steps.
Lastly, we update the instruction set to minimize non-deterministic behaviour, and therefore provide an even more reliable reference workflow suitable for derivation and reuse. 


## Introduction

- Explanation of reference data
- Re-execution using containers


## Methods

### Data Acquisition

No new data was recorded, we have reused the data collected for [the
original paper][horea-paper].

TODO(Review of data collection in original paper)

### Repository Structure

The [opfvta-replication-2023 repository][base-repo] is a [Datalad
Dataset][datalad] that is structured according to [YODA principals][TODO
CITE]. In short, it has a nested structure, with [datalad
subdatasets][subdatasets] for each of the following:

[Opfvta code repository][opfvta] is the software used to perform the analysis end-to-end.
[Opfvta data][opfvta_bidsdata] is the data collected for the original
paper.
[Mouse Brain Templates][mouse-brain-templates] are used as reference
data by the [SAMRI][samri] tool. 

### Preprocessing

```
Data conversion from the proprietary ParaVision format was performed via
the Bruker-to-BIDS repositing pipeline [26] of the SAMRI package
(version 0.4 [27]). Following conversion, data were dummy-scan
corrected, registered, and subject to controlled smoothing via the SAMRI

Generic registration workflow [20]. As part of this processing, the
first 10 volumes were discarded (automatically accounting for volumes
excluded by the scanner software). Registration was performed using the
standard SAMRI mouse-brain-optimized parameter set for ANTs [28]
(version 2.3.1). Data were transformed to a stereotactically oriented
standard space (the DSURQEC template space, as distributed in the Mouse
Brain Atlases Package [29], version 0.5.3), which is based on a
high-resolution T2 -weighted atlas [30]. Controlled spatial smoothing
was applied in the coronal plane up to 250 µm via the AFNI package [31]
(version 19.1.05).

The registered time course data were frequency filtered depending on the
analysis workflow. For stimulus-evoked activity, the data was low-pass
filtered at a period threshold of 225 s, and for seed-based functional
connectivity, the data were band-pass filtered within a period range of
2–225 s.
```

In our replication, we have used a more recent release of the SAMRI
package [version 0.5.4][samri]. We have fixed several issues that
allowed us to upgrade of some dependencies, including `numpy` and
`pandas`, and [now works with datalad datasets][dotfilefilter].


### Packaging

The original analysis was performed on a [Gentoo linux][gentoo] system,
which builds and installs packages from source code. However, due to the 
Gentoo philosophy of rolling releases, it is difficult to ensure that
the software and all dependencies will correctly install in the future.
To address this problem, we have chosen to package the entire analysis
apparatus as an [OCI container image][oci]. This has the benefit of
preserving the work done as a part of this re-analysis, which can be
re-run without any knowledge of Gentoo, Python packaging, or the inner
workings of the code.

TODO(anything from pipfreeze.txt in here?)

## Discussion

### What was easy

The original paper made a significant effort to encapsulate all
components of the analysis as code, including the generation of images
and the rendering of the final pdf. Once properly installed, the
replication required little knowledge of the implementation details.

### What was difficult

Installation was challenging primarily because the process of installing
software on Gentoo is very slow. Building the container image took
about five hours, which lead to a slow development cycle where mistakes
were expensive.

### Future Work

- Automation of reference results 
- Separation of components for re-use

## Acknowledgements & Funding

## Authoring

## References

[horea-paper][https://www.nature.com/articles/s41398-022-01812-5]
[samri][https://github.com/IBT-FMI/SAMRI/tree/0.5.4]
[base-repo][https://github.com/con/opfvta-replication-2023]
[datalad][https://www.datalad.org/]
[subdatasets][https://handbook.datalad.org/en/latest/basics/101-106-nesting.html]
[opfvta][https://bitbucket.org/TheChymera/opfvta]
[opfvta_bidsdata][https://bitbucket.org/TheChymera/opfvta_bidsdata/src/master/]
[mouse-brain-templates][https://github.com/IBT-FMI/mouse-brain-templates]
[gentoo][https://www.gentoo.org/]
[oci][https://opencontainers.org/]
