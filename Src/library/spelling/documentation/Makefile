NAME = report

all: $(NAME).pdf

$(NAME).pdf: $(NAME).tex
	xelatex $(NAME).tex
	xelatex $(NAME).tex
	xelatex $(NAME).tex

$(NAME).tex: basis.sty

clean:
	rm -f *~ *.aux *.bbl *.blg *-blx.bib *.log *.nav *.out *.run.xml *.snm *.toc
