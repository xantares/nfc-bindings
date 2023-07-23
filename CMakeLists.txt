cmake_minimum_required (VERSION 3.8)

set (CMAKE_BUILD_TYPE Release CACHE STRING "build type")

project (nfc-bindings C)

if (POLICY CMP0078)
  cmake_policy (SET CMP0078 NEW)
endif ()
if (POLICY CMP0086)
  cmake_policy (SET CMP0086 NEW)
endif ()

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

find_package (LibNFC 1.7.2 REQUIRED)
include_directories (${LIBNFC_INCLUDE_DIRS})

find_package (SWIG REQUIRED)
include (${SWIG_USE_FILE})

include (GNUInstallDirs)

option (BUILD_PYTHON "Build python bindings" ON)
if (BUILD_PYTHON)
  add_subdirectory (python)
endif ()

