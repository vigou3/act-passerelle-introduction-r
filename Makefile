### -*-Makefile-*- pour préparer "Passerelle d'introduction à la programmation en R"
##
## Copyright (C) 2017 Vincent Goulet
##
## 'make pdf' crée les fichiers .tex à partir des fichiers .Rnw avec
## Sweave et compile le document maître avec XeLaTeX.
##
## 'make zip' crée l'archive contenant le code source des sections
## d'exemples.
##
## 'make release' crée une nouvelle version dans GitHub, téléverse les
## fichiers PDF et .zip et modifie les liens de la page web.
##
## 'make all' est équivalent à 'make pdf' question d'éviter les
## publications accidentelles.
##
## Auteur: Vincent Goulet
##
## Ce fichier fait partie du projet "Passerelle d'introduction à la
## programmation en R"
## http://github.com/vigou3/act-passerelle-introduction-r


## Principaux fichiers
MASTER = act-passerelle-introduction-r.pdf
ARCHIVE = act-passerelle-introduction-r.zip
README = README.md
SCRIPTS = \
	presentation.R \
	bases.R \
	donnees.R \
	application.R
OTHER = LICENSE

## Numéro de version et numéro ISBN extraits du fichier maître
YEAR = $(shell grep "newcommand{\\\\year" ${MASTER:.pdf=.tex} \
	| cut -d } -f 2 | tr -d {)
MONTH = $(shell grep "newcommand{\\\\month" ${MASTER:.pdf=.tex} \
	| cut -d } -f 2 | tr -d {)
VERSION = ${YEAR}.${MONTH}
ISBN = $(shell grep "newcommand{\\\\ISBN" ${MASTER:.pdf=.tex} \
	| cut -d } -f 2 | tr -d {)

## Le document maître dépend de tous les fichiers .tex et des fichiers
## .R mentionnés
RNWFILES = $(wildcard *.Rnw)
TEXFILES = \
	couverture-avant.tex \
	frontispice.tex \
	licence.tex \
	reference.tex \
	presentation.tex \
	application.tex \
	controle.tex \
	extensions.tex \
	colophon.tex \
	couverture-arriere.tex
AUXFILES = \
	Fotolia_99831160.jpg \
	by-sa.pdf \
	by.pdf \
	sa.pdf \
	Chambers.jpg \
	introduction-programmation-r.jpg \
	programmer-avec-r.png

## Outils de travail
SWEAVE = R CMD SWEAVE --encoding="utf-8"
TEXI2DVI = LATEX=xelatex TEXINDY=makeindex texi2dvi -b
RBATCH = R CMD BATCH --no-timing
RM = rm -rf

## Dossier temporaire pour construire l'archive
TMPDIR = tmpdir

## Dépôt GitHub et authentification
REPOSURL = https://api.github.com/repos/vigou3/act-passerelle-introduction-r
OAUTHTOKEN = $(shell cat ~/.github/token)


all: pdf

.PHONY: tex pdf zip release create-release upload clean

pdf: $(MASTER)

tex: $(RNWFILES:.Rnw=.tex)

release: zip create-release upload publish

%.tex: %.Rnw
	$(SWEAVE) '$<'

$(MASTER): $(MASTER:.pdf=.tex) $(RNWFILES:.Rnw=.tex) $(TEXFILES) $(SCRIPTS) ${AUXFILES}
	$(TEXI2DVI) $(MASTER:.pdf=.tex)

zip: ${MASTER} ${README} ${SCRIPTS} ${OTHER}
	if [ -d ${TMPDIR} ]; then ${RM} ${TMPDIR}; fi
	mkdir -p ${TMPDIR}
	touch ${TMPDIR}/${README} && \
	  awk 'state==0 && /^# / { state=1 }; \
	       /^## Auteur/ { printf("## Version\n\n%s\n\n", "${VERSION}") } \
	       state' ${README} >> ${TMPDIR}/${README}
	cp ${MASTER} ${SCRIPTS} ${ROUTFILES} ${OTHER} ${TMPDIR}
	cd ${TMPDIR} && zip --filesync -r ../${ARCHIVE} *
	${RM} ${TMPDIR}

create-release :
	@echo ----- Creating release on GitHub...
	@if [ -n "$(shell git status --porcelain | grep -v '^??')" ]; then \
	     echo "uncommitted changes in repository; not creating release"; exit 2; fi
	@if [ -n "$(shell git log origin/master..HEAD)" ]; then \
	    echo "unpushed commits in repository; pushing to origin"; \
	     git push; fi
	if [ -e relnotes.in ]; then rm relnotes.in; fi
	touch relnotes.in
	awk 'BEGIN { ORS=" "; print "{\"tag_name\": \"v${VERSION}\"," } \
	      /^$$/ { next } \
	      /^## Historique/ { state=0; next } \
              (state==0) && /^### / { state = 1; out = $$2; \
	                             for(i=3; i<=NF; i++) { out = out" "$$i }; \
	                             printf "\"name\": \"Édition %s\", \"body\": \"", out; \
	                             next } \
	      (state==1) && /^### / { exit } \
	      state==1 { printf "%s\\n", $$0 } \
	      END { print "\", \"draft\": false, \"prerelease\": false}" }' \
	      README.md >> relnotes.in
	curl --data @relnotes.in ${REPOSURL}/releases?access_token=${OAUTHTOKEN}
	rm relnotes.in
	@echo ----- Done creating the release

upload :
	@echo ----- Getting upload URL from GitHub...
	$(eval upload_url=$(shell curl -s ${REPOSURL}/releases/latest \
	 			  | awk -F '[ {]' '/^  \"upload_url\"/ \
	                                    { print substr($$4, 2, length) }'))
	@echo ${upload_url}
	@echo ----- Uploading PDF and archive to GitHub...
	curl -H 'Content-Type: application/zip' \
	     -H 'Authorization: token ${OAUTHTOKEN}' \
	     --upload-file ${ARCHIVE} \
             -i "${upload_url}?&name=${ARCHIVE}" -s
	@echo ----- Done uploading files

clean:
	$(RM) $(RNWFILES:.Rnw=.tex) \
	      *-[0-9][0-9][0-9].pdf \
	      *.aux *.log  *.blg *.bbl *.out *.rel *~ Rplots.ps


