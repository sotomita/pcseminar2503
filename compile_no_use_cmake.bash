#!/bin/bash

export LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH
export NETCDF="./lib"

mkdir -p build/bin

# -----------------------------
# init_sine
# -----------------------------
gfortran -O3 -I./include -c src/init_sine.f90 -o build/init_sine.o
gfortran build/init_sine.o -o build/bin/init_sine -L$NETCDF -lnetcdff -lnetcdf
# gfortran -O3 -I./include src/init_sine.f90 -o build/bin/init_sine -L$NETCDF -lnetcdff -lnetcdf


# -----------------------------
# forward
# -----------------------------
gfortran -O3 -I./include -c src/read_config.f90 -o build/read_config.o
gfortran -O3 -I./include -c src/forward.f90     -o build/forward.o
gfortran build/read_config.o build/forward.o -o build/bin/forward -L$NETCDF -lnetcdff -lnetcdf
# gfortran -O3 -I./include src/read_config.f90 src/forward.f90 -o build/bin/forward -L$NETCDF -lnetcdff -lnetcdf
