BASE     := $(dir $(lastword $(MAKEFILE_LIST)))

DO_BIBTEX ?=1

VIEWER   ?= evince
LATEX    ?= pdflatex
BIBTEX   ?= bibtex

BUILD    ?= ./build
DOC      ?= ./doc
LOG      ?= ./log

BUILDFIG  := ${BUILD}/figure
BUILDTAB  := ${BUILD}/table
BUILDCODE := ${BUILD}/code

BASE_SRC  := ${BASE}src
BASE_FIG  := ${BASE_SRC}/figure
BASE_BIB  := ${BASE_SRC}/bib

FIG_DIRS += ${BASE_FIG}
CONTENT_DIRS += ${BASE_SRC}

DOCUMENT       :=${DOC}/${TARGET}.pdf
DIRS           :=${BUILD} ${BUILDFIG} ${BUILDTAB} ${BUILDCODE} ${DOC} ${LOG}
GARBAGE        :=${DIRS}
DOCUMENT_LOG   :=${LOG}/${TARGET}.log
STARTFILE      := ${BASE_SRC}/main.tex

LATEXOPTIONS :=-halt-on-error -shell-escape -file-line-error --output-directory ${BUILD}
empty        :=
space        :=${empty} ${empty}
TEXPATHS     :=$(subst ${space},:,$(strip ${CONTENT_DIRS} ${FIG_DIRS} ${TAB_DIRS} ${CODE_DIRS}))
BIBPATHS     :=$(subst ${space},:,$(strip ${BIB_DIRS}))

LATEX        :=TEXINPUTS+=:${TEXPATHS} TEXFORMATS+=:${TEXPATHS} ${LATEX}
BIBTEX       :=BIBINPUTS+=:${BIBPATHS} ${BIBTEX}


TIKZ_FIGURES     := $(foreach dir,${FIGURE_DIRS}    ,$(wildcard ${dir}/*.tex))
TABLES           := $(foreach dir,${TABLE_DIRS}    ,$(wildcard ${dir}/*.tex))
CODE             := $(foreach dir,${CODE_DIRS}   ,$(wildcard ${dir}/*.tex))
CONTENT          := $(foreach dir,${CONTENT_DIRS},$(wildcard ${dir}/*.tex))
METAUML_FIGURES  := $(foreach dir,${FIGURE_DIRS}    ,$(wildcard ${dir}/*.ml) )
TEMPLATES        := $(wildcard ${BASE}/src/*.tex)
BIBS             := $(foreach dir, ${BIB_DIRS}   ,$(wildcard ${dir}/*.bib))

TIKZ_TARGETS    :=$(addprefix ${BUILDFIG}/,$(addsuffix .pdf,$(notdir $(basename ${TIKZ_FIGURES}   ))))
TABLE_TARGETS   :=$(addprefix ${BUILDTAB}/,$(addsuffix .pdf,$(notdir $(basename ${TABLES}         ))))
CODE_TARGETS    :=$(addprefix ${BUILDCODE}/,$(addsuffix .pdf,$(notdir $(basename ${CODE}           ))))
METAUML_TARGETS :=$(addprefix ${BUILDFIG}/,$(addsuffix .1  ,$(notdir $(basename ${METAUML_FIGURES}))))
SOURCES         :=${TEMPLATES} ${CONTENT} ${TIKZ_TARGETS} ${TABLE_TARGETS} ${CODE_TARGETS} ${METAUML_TARGETS} ${BIBS}

TARGET_AUX     :=${BUILD}/$(basename $(notdir ${STARTFILE}))
TARGET_PDF     :=${BUILD}/$(basename $(notdir ${STARTFILE})).pdf

LATEX_CMD1         := echo "Running PDFLatex 1." ; ${LATEX} ${LATEXOPTIONS} -draftmode ${STARTFILE} > ${LOG}/run1.log

ifeq (${DO_BIBTEX},1)
	BIBTEX_CMD     := echo "Running BibTex" ; ${BIBTEX} ${TARGET_AUX} > ${LOG}/bib.log
	LATEX_CMD2     := echo "Running PDFLatex 2." ; ${LATEX} ${LATEXOPTIONS} -draftmode ${STARTFILE} > ${LOG}/run2.log
	LATEX_CMD3     := echo "Running PDFLatex 3." ; ${LATEX} ${LATEXOPTIONS} ${STARTFILE} > ${LOG}/run3.log
else
	BIBTEX_CMD     :=
	LATEX_CMD2     := echo "Running PDFLatex 2." ; ${LATEX} ${LATEXOPTIONS} ${STARTFILE} > ${LOG}/run2.log
	LATEX_CMD3     :=
endif



vpath %.tex ${CONTENT_DIRS} ${FIGURE_DIRS} ${TABLE_DIRS} ${CODE_DIRS}
vpath %.ml  ${FIG_DIRS}


.PHONY: edit view view_log view_% clean all

all: ${DOCUMENT}

metauml: ${METAUML_TARGETS}

${DIRS}: %:
	@mkdir -p $@

${DOCUMENT}: ${SOURCES} | ${BUILD} ${DOC} ${LOG}
	@find ${BUILD} -maxdepth 1 -type f  -exec rm {} \;
	@rm -f ${LOG}/run?.log ${LOG}/bib.log
	@${LATEX_CMD1}
	@${BIBTEX_CMD}
	@${LATEX_CMD2}
	@${LATEX_CMD3}
	@mv ${TARGET_PDF} $@

${TIKZ_TARGETS}: ${BUILDFIG}/%.pdf: %.tex  figStart.tex ${METAUML_TARGETS} | ${BUILDFIG} ${LOG}
	@cat ${SRC}/figStart.tex > ${BUILD}/temp.tex
	@echo "\input $<" >> ${BUILD}/temp.tex
	@echo "\end{document}" >> ${BUILD}/temp.tex
	@${LATEX} ${LATEXOPTIONS} ${BUILD}/temp.tex > ${LOG}/$*.log
	@mv ${BUILD}/temp.pdf $@

${TABLE_TARGETS}: ${BUILDTAB}/%.pdf: %.tex ${BASE}/src/tableStart.tex ${METAUML_TARGETS} | ${BUILDTAB} ${LOG}
	@cat ${BASE}/src/tableStart.tex > ${BUILD}/temp.tex
	@echo "\input{$<}" >> ${BUILD}/temp.tex
	@echo "\end{document}" >> ${BUILD}/temp.tex
	@${LATEX} ${LATEXOPTIONS} ${BUILD}/temp.tex > ${LOG}/$*.log
	@mv ${BUILD}/temp.pdf $@

${CODE_TARGETS}: ${BUILDCODE}/%.pdf: %.tex  codeStart.tex ${METAUML_TARGETS} | ${BUILDCODE} ${LOG}
	@cat ${SRC}/codeStart.tex > ${BUILD}/temp.tex
	@echo "\input $<)" >> ${BUILD}/temp.tex
	@echo "\end{document}" >> ${BUILD}/temp.tex
	@${LATEX} ${LATEXOPTIONS} ${BUILD}/temp.tex > ${LOG}/$*.log
	@mv ${BUILD}/temp.pdf $@

${METAUML_TARGETS}: %.1: %.ml | ${BUILDFIG} ${LOG}
	@cd ${BUILDFIG} && mpost ../../$< > /dev/null
	@mv ${BUILDFIG}/$*.log ${LOG}/$*.log

clean:
	@echo "(CLEAN) ${GARBAGE}"
	@rm -rf ${GARBAGE}

edit:
	@${EDITOR} ${SOURCES} ${BIBFILES}

view: ${DOCUMENT}
	@${VIEWER} $< &

view_log:
	@${EDITOR} $(wildcard ${LOG}/*.log)

$(addprefix view_,${FIGURE_TARGETS} ${TABLE_TARGETS} ${CODE_TARGETS}): view_%: ${DOC}/%.pdf
	@${VIEWER} $<
