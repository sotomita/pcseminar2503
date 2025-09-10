cmake_minimum_required(VERSION 3.15)
project(init_sine Fortran)

set(NETCDF_DIR "/DATA/USER/tomita/m/lib/netcdf")
set(NETCDF_INCLUDE "${NETCDF_DIR}/include")
set(NETCDF_LIB     "${NETCDF_DIR}/lib")
set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/bin")

add_executable(init_sine init_sine.f90)

target_include_directories(init_sine PRIVATE ${NETCDF_INCLUDE})

target_link_libraries(init_sine PRIVATE
    ${NETCDF_LIB}/libnetcdff.so
    ${NETCDF_LIB}/libnetcdf.so
)
