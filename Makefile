# Makefile for LiLi Compiler

all: clean-all compiler

compiler: clean-compiler
	./scripts/compiler.sh

clean-sources:
	./scripts/utils/clean_sources.sh

clean-compiler:
	./scripts/utils/clean_compiler.sh

clean-all:
	./scripts/utils/clean_all.sh
