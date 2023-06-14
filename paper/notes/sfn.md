The value of experimental research articles is inextricably contingent on data analysis results which substantiate their natural language claims.
However, the intricacy of data analysis procedures, alongside their high reliance on extrinsic tools, makes them fragile with respect to re-use and may endanger their value as a repository of procedural knowledge.
It is therefore of crucial importance for all constituent instructions to be not only recorded and accessible, but also to represent the encapsulated domain and operational knowledge as automatically executable code, in order to reliably support re-execution.
In this study, we examine a peer-reviewed neuroimaging experiment, which already publishes automated data analysis instructions, in light of its reexecution reliability.
We document a number of prominent difficulties with de novo article generation, arising from the rapid evolution of extrinsic tools, and from nondeterministic data analysis procedures.
To compensate for these difficulties, we formulate a novel reexecution standard which leverages mutable-state dependency management, environment isolation, as well as emerging technologies for provenance tracking.
This novel standard consists in a general purpose resource topology with well-defined entry points, and is illustrated by a reference implementation which can fully re-execute the original article.
We further leverage this technological advancement to produce a fine-grained reproducibility assessment at the article level.
This assessment encompasses inline statistical summaries (e.g. F and p values), figures, as well as the relationship between these values and the qualitative statements they underpin.
The reproducibility analysis demonstrates that article reexecution in our novel standard showcases high accuracy (coherence in statistical summaries between our regenerated article and the original article reexecution process, Fig.1), and very high precision (coherence in statistical summaries between multiple de novo reproductions).


--- keep scraps for reuse
Data analysis procedures encapsulate both computational and domain expertise, and therefore their codification constitutes a cornerstone element of scientific work.

In order to assure the robustness of data analysis, it is therefore of crucial importance for all constituent instructions to be not only recorded and accessible, but also formatted in such a way as to reliably support reexecution.
