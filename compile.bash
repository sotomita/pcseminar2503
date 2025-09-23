#! /bin/bash

if [ ! -f build/Makefile ]; then
    cmake -B build
fi

cd build
make
