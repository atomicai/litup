NAME := $(shell python setup.py --name)
UNAME := $(shell uname -s)

FLAKE_FLAGS=--in-place --ignore-init-module-imports --remove-all-unused-imports --remove-unused-variable --recursive -cd
FLAKE_FLAGS_DIFF=--ignore-init-module-imports --remove-all-unused-imports --remove-unused-variable --recursive -cd
BLACK_FLAGS=-c
ISORT_FLAGS=
# "" is for multi-lang strings (comments, logs), '' is for everything else.
# BLACK_FLAGS=--skip-string-normalization --line-length=${LINE_WIDTH}
PYTEST_FLAGS=-p no:warnings

install:
	pip install -e '.[all]'

init:
	pip install pre-commit==3.3.3
	pip install isort==5.12.0
	pip install black==23.7.0
	pip install autoflake==2.2.0
	pyclean==2.7.3
	pre-commit clean
	pre-commit install
  	# To check whole pipeline.
	# pre-commit run --all-files

formatdiff:
	black ${NAME} tests --diff

format:
	black ${NAME} tests
	isort ${NAME} tests
	autoflake -r ${FLAKE_FLAGS} ${NAME} tests

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
