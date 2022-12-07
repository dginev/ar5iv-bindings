# ar5iv-bindings

Extended LaTeXML bindings for converting the older sources of arXiv.org

Sourced from:
https://arxiv.org/help/macro_list

Excluded files that are:
 - already supported by the mainline LaTeXML distribution
 - available under texlive 2021
 
 The initial work in this repository went as far as to tease away the Fatal status of a report over 100 arXiv documents.
 Just dipping our toes in...

### 🚧 High Velocity

For all intents and purposes, the bindings in this repository are highly *experimental*.

As support stabilizes and matures, bindings of sufficient quality will swim up to the mainline LaTeXML "Package" support, and will be removed from this repository.

### Note on Licensing

All files under `bindings/` are released in the public domain and you are invited to reuse them.

All other assets currently in the repository come from the wider LaTeX publishing ecosystem, and are distributable under their own licenses.

Ideally, avoid using this repository in any way that relies on raw `.sty` or `.cls` assets. Only the `.ltxml` files are ours to fully distribute.
