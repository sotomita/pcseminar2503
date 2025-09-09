cmake_minimum_required(VERSION 3.10)

add_executable(hello hello.f90)

project(HelloFortran LANGUAGES Fortran)

set(CMAKE_Fortran_COMPILER gfortran)

set_target_properties(hello PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)


