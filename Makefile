.PHONY: all

all: | build run

build:
	@stack build

run:
	@stack exec hjq-exe

ghci-options = -XOverloadedStrings
ghci:
	@stack ghci --ghci-options $(ghci-options)