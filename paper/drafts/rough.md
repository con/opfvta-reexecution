# Re-analysis of Whole-brain opto-fMRI map of mouse VTA dopaminergic activation reflects structural projections with small but significant deviations

## Abstract

The study of the ascending dopaminergic projections from the Ventral
Tegmental Area (VTA) in mice is crucial to the translational
investigations regarding human motivation, learning, and addiction. 

A prior article produced the first whole-brain opto-fMRI map of the
VTA-originated dopamenergic activation in mice, which the authors
believe will provide valuable reference results, but more importantly,
an example implementation of the workflow to generate them.

In this article, we share the results of an effort to reexecute,
simplify, and preserve the workflow that uses opto-fMRI analysis to
generate a full-brain map.

By leveraging container technology, we have improved the portability,
provenance, and reproducibility of the workflow, and have reduced the
required knowledge of the internal workings of the software to
re-execute. 

We have verified the non-deterministic results of the original article,
and have taken a step toward continually updated reference results by
simplifying the re-execution and separating the code from the input
data.


TODO(Remove reference original abstract)
```
Ascending dopaminergic projections from neurons located in the Ventral
Tegmental Area (VTA) are key to the etiology, dysfunction, and control
of motivation, learning, and addiction. Due to the evolutionary
conservation of this nucleus and the extensive use of mice as disease
models, establishing an assay for VTA dopaminergic signaling in the
mouse brain is crucial for the translational investigation of
motivational control as well as of neuronal function phenotypes for
diseases and interventions. In this article we use optogenetic
stimulation directed at VTA dopaminergic neurons in combination with
functional Magnetic Resonance Imaging (fMRI), a method widely used in
human deep brain imaging. We present a comprehensive assay producing the
first whole-brain opto-fMRI map of dopaminergic activation in the mouse,
and show that VTA dopaminergic system function is consistent with its
structural VTA projections, diverging only in a few key aspects. While
the activation map predominantly highlights target areas according to
their relative projection densities (e.g., strong activation of the
nucleus accumbens and low activation of the hippocampus), it also
includes areas for which a structural connection is not well established
(such as the dorsomedial striatum). We further detail the variability of
the assay with regard to multiple experimental parameters, including
stimulation protocol and implant position, and provide evidence-based
recommendations for assay reuse, publishing both reference results and a
reference analysis workflow implementation. 
```

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
