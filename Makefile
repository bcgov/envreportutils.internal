docs:
	Rscript -e "library(devtools); library(methods); document('.'); check_doc('.')"

check:
	Rscript -e "library(devtools); library(methods); check('.')"

build:
	Rscript -e "library(devtools); build('.', binary=TRUE)"

install:
	Rscript -e "library(devtools); install('.')"
