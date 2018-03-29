all: main.pdf

main.pdf: main.tex ref.bib bioinfo.cls
	 pdflatex main.tex
	 bibtex main
	 pdflatex main.tex
	 pdflatex main.tex

bioinfo.cls:
	 wget https://academic.oup.com/DocumentLibrary/Bioinformatics/cabios-template.zip --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.22 (KHTML, like Gecko) Ubuntu Chromium/25.0.1364.160 Chrome/25.0.1364.160 Safari/537.22"
	 unzip -n cabios-template.zip
