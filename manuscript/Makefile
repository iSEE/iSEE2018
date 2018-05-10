all: main.pdf

main.pdf: main.tex ref.bib Fig1.pdf
	pdflatex main.tex
	bibtex main
	pdflatex main.tex
	pdflatex main.tex

Fig1.pdf: pics/Fig1.svg
	cd pics; inkscape -D -A Fig1.pdf Fig1.svg;
	mv pics/Fig1.pdf .
