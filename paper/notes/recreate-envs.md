# Known ways to recreate a python environment

Method | description | notes
------------------------------
Gentoo's ebuild `emerge pkg` | build the package and each dependency from source | limited to
Gentoo-only, slow
restore from pip freeze(Original env: `pip freeze > requirements-full.txt` Reproducer env: `pip requirements -r requirements-full.txt`) |
Install pinned requirements identical to the original env. | Only works
when the original researcher creates a pip freeze to document their
entire python env. (Or, this can be run inside of a container image if
available)
pip-timemachine | proxy that sits in front of pypi and filters the
available packages by a date. | This isn't perfect but can provide a
good starting point when dependency versions are not known. 
