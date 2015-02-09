cmake_minimum_required (VERSION 2.8)

project (nfc-bindings C)

option (INSTALL_EXAMPLES "install examples" ON)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

find_package (LibNFC 1.7.1 REQUIRED)
include_directories (${LIBNFC_INCLUDE_DIRS})

option (BUILD_PYTHON "Build python bindings" ON)
if (BUILD_PYTHON)
  add_subdirectory (python)
endif ()

