.PHONY: build install test clean

build:
	./build.sh

install:
	./build.sh install

test:
	./build.sh test

clean:
	./build.sh clean
