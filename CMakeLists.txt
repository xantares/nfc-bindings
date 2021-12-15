cmake_minimum_required (VERSION 3.2)

set (CMAKE_BUILD_TYPE Release CACHE STRING "build type")

project (nfc-bindings C)

if (POLICY CMP0078)
  cmake_policy (SET CMP0078 NEW)
endif ()
if (POLICY CMP0086)
  cmake_policy (SET CMP0086 NEW)
endif ()

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

include (TargetLinkLibrariesWithDynamicLookup)

find_package (SWIG REQUIRED)
include (${SWIG_USE_FILE})


option (BUILD_PYTHON "Build python bindings" ON)
if (BUILD_PYTHON)
  add_subdirectory (python)
endif ()

