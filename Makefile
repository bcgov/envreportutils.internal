docs:
	Rscript -e "library(devtools); document('.'); check_doc('.')"

check:
	Rscript -e "library(devtools); check('.')"

build:
	Rscript -e "library(devtools); build('.', binary=TRUE)"
