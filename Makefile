PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)

all: docs check build install

docs:
	rm -f NAMESPACE
	Rscript -e "library(devtools); library(methods); document('.'); check_doc('.')"

check:
	Rscript -e "library(devtools); library(methods); check('.')"

build:
	Rscript -e "library(devtools); build('.'); build('.', binary=TRUE)"
	cp ../$(PKGNAME)_$(PKGVERS).zip ../$(PKGNAME)_$(PKGVERS).tar.gz \
	"/d/packages/"

install:
	Rscript -e "library(devtools); install('.', build_vignettes = TRUE)"
	
vignette:
	rm -rf inst/doc/
	Rscript -e "library(devtools); build_vignettes('.')"
