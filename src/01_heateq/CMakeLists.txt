cmake_minimum_required(VERSION 3.15)
project(pcsemi2503 Fortran)

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

add_executable(heateq solve_heateq.f90 read_config.f90)
target_include_directories(heateq PRIVATE ${NETCDF_INCLUDE})
target_link_libraries(heateq PRIVATE
    ${NETCDF_LIB}/libnetcdff.so
    ${NETCDF_LIB}/libnetcdf.so
)
set_target_properties(heateq PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)