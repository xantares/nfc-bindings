cmake_minimum_required ( VERSION 2.8 )

project(nfc-bindings C)

list ( APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake )

find_package ( LibNFC REQUIRED )
include_directories ( ${LIBNFC_INCLUDE_DIRS} )

option ( PYTHON_BINDINGS "Build python bindings" ON )
if ( PYTHON_BINDINGS )
  add_subdirectory ( python )
endif ()




