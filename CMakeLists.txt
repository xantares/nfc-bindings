cmake_minimum_required (VERSION 2.8)

project (nfc-bindings C)

option (INSTALL_EXAMPLES "install examples" ON)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

find_package (LibNFC 1.7.1 REQUIRED)
include_directories (${LIBNFC_INCLUDE_DIRS})

# https://github.com/nfc-tools/libnfc/pull/297
include (CheckSymbolExists)
set (CMAKE_REQUIRED_LIBRARIES ${LIBNFC_LIBRARIES})
check_symbol_exists (iso14443b_crc nfc/nfc.h HAS_ISO14443B_CRC)
if (NOT HAS_ISO14443B_CRC)
  add_definitions(-DNO_ISO14443B_CRC)
endif ()

option (BUILD_PYTHON "Build python bindings" ON)
if (BUILD_PYTHON)
  add_subdirectory (python)
endif ()

