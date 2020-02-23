toc:

	RScript analysis/build_toc.R

render:

	RScript analysis/build_readme.R

clean:

	rm README.html

push:
	git add .
	git commit -m 'update, use `push` in Makefile'
	git push

README: toc render clean push

all: README

copy:

	RScript code/copy-md.R
