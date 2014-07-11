docs:
	Rscript -e "library(devtools); document('.'); check_doc()"

check:
	Rscript -e "library(devtools); check()"

build_reload:
	Rscript -e "library(devtools); build('.'); install('.')"
