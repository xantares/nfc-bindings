cmake_minimum_required ( VERSION 2.8 )

project(nfc-bindings C)

list ( APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake )

find_package ( LibNFC REQUIRED )
include_directories ( ${LIBNFC_INCLUDE_DIRS} )

# check that nfc_iso14443b_crc symbol is available
# bug in 1.7.0, fixed in trunk
include(CheckCSourceRuns)
set(CMAKE_REQUIRED_LIBRARIES ${LIBNFC_LIBRARIES})
CHECK_C_SOURCE_RUNS(${CMAKE_CURRENT_SOURCE_DIR}/cmake/nfc_iso14443b_crc.c NFC_ISO14443B_CRC_RUN)
message(STATUS "iso14443b_crc: ${NFC_ISO14443B_CRC_RUN}")
if (NOT NFC_ISO14443B_CRC_RUN)
  add_definitions(-DNFC_NO_ISO14443B_CRC)
endif ()

option ( PYTHON_BINDINGS "Build python bindings" ON )
if ( PYTHON_BINDINGS )
  add_subdirectory ( python )
endif ()




