cmake_minimum_required (VERSION 2.8)

project (nfc-bindings C)

if (POLICY CMP0078)
  cmake_policy (SET CMP0078 NEW)
endif ()

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


# workaround for cmake bug #0013449
if (CMAKE_VERSION VERSION_LESS 3 AND DEFINED CMAKE_FIND_ROOT_PATH)
  find_program (SWIG_EXECUTABLE NAMES swig2.0 swig)
  if (SWIG_EXECUTABLE)
    set (SWIG_USE_FILE ${CMAKE_ROOT}/Modules/UseSWIG.cmake)
    set (SWIG_FOUND TRUE)
  else ()
    message (SEND_ERROR "SWIG not found")
  endif ()
else ()
  find_package (SWIG REQUIRED)
endif ()
include (${SWIG_USE_FILE})


option (BUILD_PYTHON "Build python bindings" ON)
if (BUILD_PYTHON)
  add_subdirectory (python)
endif ()

