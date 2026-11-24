ISABELLE ?= isabelle
SBT ?= sbt
PYTHON ?= python3

.PHONY: build check
build:
	$(ISABELLE) build -e -D .
	$(SBT) buildWasm

check: build
	test "$$($(PYTHON) nth_prime.py 0)" = 2
	test "$$($(PYTHON) nth_prime.py 1)" = 3
	test "$$($(PYTHON) nth_prime.py 4)" = 11
	test "$$($(PYTHON) nth_prime.py 99)" = 541
	! $(PYTHON) nth_prime.py -1
