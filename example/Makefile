template.pdf : template.tex graph.tex
	pdflatex template.tex </dev/null

graph.tex : ../graph.pl config.pl data.csv data-exp.csv
	../graph.pl config.pl > graph.tex

data.csv : ../datagen.pl
	../datagen.pl > data.csv


force : clean all

clean :
	rm graph.tex
