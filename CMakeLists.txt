cmake_minimum_required(VERSION 3.15)
project(pcsemi2503 LANGUAGES Fortran)

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O3")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)


# init_sine
add_executable(init_sine src/init_sine.f90)

target_include_directories(init_sine PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_directories(init_sine PRIVATE ${CMAKE_SOURCE_DIR}/lib)

target_link_libraries(init_sine PRIVATE netcdff netcdf)

set_target_properties(init_sine PROPERTIES
    BUILD_RPATH ${CMAKE_SOURCE_DIR}/lib
    INSTALL_RPATH ${CMAKE_SOURCE_DIR}/lib
)

