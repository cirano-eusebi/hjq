.PHONY: all build test run ghci

all: | test run

build:
	@stack build

test:
	@stack test

run:
	@stack exec hjq-exe

ghc-options = -XOverloadedStrings
ghci:
	@stack ghci --ghc-options $(ghc-options)