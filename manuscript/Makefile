all: main.pdf

main.pdf: main.tex ref.bib bioinfo.cls
	 pdflatex main.tex
	 bibtex main
	 pdflatex main.tex
	 pdflatex main.tex

bioinfo.cls:
	 wget https://academic.oup.com/DocumentLibrary/Bioinformatics/cabios-template.zip
	 unzip cabios-template.zip
