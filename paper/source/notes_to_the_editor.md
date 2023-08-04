Dear Editor,

Thank you for providing a quality LaTeX template with a reliable build system for submitting authors to use.
This makes work on manuscripts with your journal far easier and faster than e.g. WYSIWYG-editors — as well as making the resulting article easier to integrate with automated data processing.

We would like to recommend a few improvements in your template which we feel would make work on manuscripts with you even cleaner, and the output prettier:

1. Consider importing the `siunitx` package by default. Inlining measurement units in text mode provides inadequate spacing and can lead to chaotic unit assignments withing (and perhaps of greater concern for you) between articles.
2. Consider providing an `article.tex` file which simply includes other `*.tex` files for respective sections. This allows authors to more easily compartmentalize their work, and also allows you to better encourage authors to use predefined sections.
99. For points not otherwise mentioned, please inspect the sections in `rescience.cls` and `header/common.tex` labelled “Chymeric”.
