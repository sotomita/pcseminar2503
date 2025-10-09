cmake_minimum_required(VERSION 3.15)
project(pcsemi2503 LANGUAGES Fortran)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O3")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# init_sine
set(SOURCES
    src/init_sine.f90
)
add_executable(init_sine ${SOURCES})

target_include_directories(init_sine PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_directories(init_sine PRIVATE ${CMAKE_SOURCE_DIR}/lib)

target_link_libraries(init_sine PRIVATE netcdf netcdff)

set_target_properties(init_sine PROPERTIES
    BUILD_RPATH ${CMAKE_SOURCE_DIR}/lib
    INSTALL_RPATH ${CMAKE_SOURCE_DIR}/lib
)

# forward
set(SOURCES
    src/read_config.f90
    src/forward.f90
)
add_executable(forward ${SOURCES})

target_include_directories(forward PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_directories(forward PRIVATE ${CMAKE_SOURCE_DIR}/lib)

target_link_libraries(forward PRIVATE netcdf netcdff)

set_target_properties(forward PROPERTIES
    BUILD_RPATH ${CMAKE_SOURCE_DIR}/lib
    INSTALL_RPATH ${CMAKE_SOURCE_DIR}/lib
)