The original goal of this project was primarily as an excercise for me
to understand the real-life workflows of researchers, experience those
problems first hand, to practice using open source scientific tools, and
to notice novel ways to apply commonly used tools from the enterprise
area.

We chose `opfvta` for a few reasons:
 - a colleague was a primary author willing to devote considerable time
     to helping me
 - Gentoo's source-based rolling release package management takes a
   radically different approach than I have used
        1. Big open repositories like pypi
        2. Curated distribution-type repositories like EPEL
        3. self-contained black box like containers
 - opfvta was designed specifically to be reproducible.


However, upon beginning the project, there were numerous problems, some
of which are typical, and others which were unique to this project.

    - opfvta was designed as a "super monolith"
        - The data was "installed" by the ebuild
        - The reference data was "installed" by the ebuild
        - Once installed, the preprocessing, analysis, the data
        - visualization, and even the latex pdf generation
          were all wrapped by a single command

### Failed Approach: alpine or ubi-8

Our first approach was to determine the dependencies based on the ebuild
files, and install into a container using a standard base image like
debian/alpine/ubi8. My procedure was to install dependencies in the
order listed until there was a conflict, adjusting previous versions
until it worked. This approach has O(2^n) [check this], and being done
by a human quickly showed that it would take a long time. We abanondoned
this effort when the opfvta source code depended on a version of pandas that
was incompatible with the version of Python I was attempting to use.

Of note 2 alternative approaches might have worked for this stage.
- Note: This approach might have worked with pip-timemachine (date
    based)
- Note: This approach might have worked if the original had included a
    pip-freeze (or reproman retrace) to show what dependencies were
    used.

Unfortunately either of these approaches would have been used a brittle
dependency tree. Later on in the work, we discovered and fixed bugs and
therefore needed to bump some dependencies, which would likely have
caused similar dependency hell.

## Successful Approach: Gentoo

The next approach we used was to ensure that the installation worked
correctly on gentoo first, then proceed to build a gentoo-based container image.
This would be non-trivial for someone who is unfamiliar with gentoo package
management, or the original code. Significant time was invested to
partially overcome that initial learning curve.

The biggest downside to this approach was an extremely slow build, which
led to very long development cycles. Once the initial boilerplate was in
place, each iteration took multiple hours of build time. This quickly
became frustrating, especially when the causes of the errors was
unclear. An entire day could easily be spent to diagnose and fix a minor
syntax error.

TODO "Masked packages"

Costly mistakes:
    - Given that the original code repository was designed as a
        monolith, the entire repo needed to be copied into the container
        image. We originally put the Containerfile into the opfvta
        repository, which exacerbated the slow build time. Essentially,
        every change to the Containerfile made a change to one of the
        earliest stages of the build, rendering the build-cache almost
        useless. We worked around this problem by moving the
        Containerfile to the top-level replication-repository, but
        ideally this would be solved by structuring the original
        repository more modularly. 
    - Since latex rendering was included in the monolith, we also had to
        ensure that there were not conflicting dependencies between the
        analysis code and latex rendering (ie matplotlib). 
    - Gentoo base images *start* at 1.5 GB, and grew quickly. With the
        data included, the images were 25-30 GB, which felt like an abuse
        of free image-hosting sites like Dockerhub and Quay. 

Eventually the build succeeded, and we could begin the analysis.
Unfortunately, we then began to encounter various runtime problems.
There were some minor bugs, more version discrepancies, etc. At this
point, the build took 5-6 hours to complete, plus however many hours
into the analysis we got before the failure. This meant that we were
restricted to fixing ~1 issue per day maximum.

We modified the Containerfile to skip the installation of data, and
YODAfied the top-level repository, and used datalad to move the data
around. This brought the image size down to ~20 GB which is still
significantly more than I suspect is needed.

The final problem preparing the container was a bug relating to dotfiles
and datalad. This was a minor bugfix, but again required nearly a week
to rebuild and rerun. 

## Part 2 Reproman



## Part 3 Next steps

Restructure opfvta:
    - preprocessing image
    - analysis image
    - latex and datavis image
