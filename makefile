ifneq (,$(wildcard ./.env))
    include .env
    export
endif

NAME := $(shell python setup.py --name)
UNAME := $(shell uname -s)

INSTALL_FLAGS=
LINE_WIDTH=122

FLAKE_FLAGS=-c --quiet --in-place --remove-all-unused-imports --remove-unused-variable --recursive --ignore-init-module-imports
FLAKE_FLAGS_DIFF=-c --quiet --remove-all-unused-imports --remove-unused-variable --recursive --ignore-init-module-imports
# "" is for multi-lang strings (comments, logs), '' is for everything else.
# BLACK_FLAGS=--skip-string-normalization --line-length=${LINE_WIDTH} -S -C
# BLACK_FLAGS_DIFF=--skip-string-normalization --line-length=${LINE_WIDTH} -S -C --diff --check
PYTEST_FLAGS=-p no:warnings

install:
	pip install -e '.[all]'

init:
	pip install pre-commit==2.21.0 ${INSTALL_FLAGS}
	pip install isort==5.11.5 ${INSTALL_FLAGS}
	pip install black==23.3.0 ${INSTALL_FLAGS}
	pip install autoflake==2.1.1 ${INSTALL_FLAGS}
	pre-commit clean
	pre-commit install
  	# To check whole pipeline.
	# pre-commit run --all-files


format:
	black -q external ${NAME} tests
	isort external ${NAME} tests
	autoflake ${FLAKE_FLAGS} external ${NAME} tests

formatdiff:
	black -q external ${NAME} tests --diff
	isort external ${NAME} tests --diff
	autoflake ${FLAKE_FLAGS_DIFF} external ${NAME} tests

test:
	pytest tests ${PYTEST_FLAGS} --testmon --suppress-no-test-exit-code

test-all:
	pytest tests ${PYTEST_FLAGS}

clean:
	rm -rf .ipynb_checkpoints
	rm -rf **/.ipynb_checkpoints
	rm -rf .pytest_cache
	rm -rf build
	rm -rf dist
	rm -rf downloads
	rm -rf wandb
	find . -name ".DS_Store" -print -delete
	rm -rf .cache
	pyclean .
