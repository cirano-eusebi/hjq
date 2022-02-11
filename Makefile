.PHONY: all build test run ghci

all: | test run

build:
	@stack build

test:
	@stack test

ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

run:
	@stack exec hjq-exe $(RUN_ARGS)

ghc-options = -XOverloadedStrings
ghci:
	@stack ghci --ghc-options $(ghc-options)
