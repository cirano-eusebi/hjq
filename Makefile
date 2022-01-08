.PHONY: all build test run ghci

all: | build test run

build:
	@stack build

test:
	@stack test

run:
	@stack exec hjq-exe

ghci-options = -XOverloadedStrings
ghci:
	@stack ghci --ghci-options $(ghci-options)