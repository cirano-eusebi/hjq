.PHONY: all build test run ghci

build:
	@stack build

test:
	@stack test

run:
	@stack exec hjq-exe '$(filter-out $@,$(MAKECMDGOALS))'

%:
	@:

ghc-options = -XOverloadedStrings
ghci:
	@stack ghci --ghc-options $(ghc-options)
