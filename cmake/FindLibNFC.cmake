#.rst:
# LibNFC
# --------
#
# Find libnfc
#
# Find libnfc includes and library. Once done this will define
#
# ::
#
#   LIBNFC_INCLUDE_DIRS   - where to find nfc/nfc.h, etc.
#   LIBNFC_LIBRARIES      - List of libraries when using libnfc.
#   LIBNFC_FOUND          - True if libnfc found.
#
#
#
# ::
#
#   LIBNFC_VERSION_STRING - The version of libnfc found (x.y.z)
#   LIBNFC_VERSION_MAJOR  - The major version of libnfc
#   LIBNFC_VERSION_MINOR  - The minor version of libnfc
#   LIBNFC_VERSION_PATCH  - The patch version of libnfc
#
#
#=============================================================================
# Copyright 2011-2014 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)


if ( LIBNFC_INCLUDE_DIR AND LIBNFC_LIBRARIES )
  # Already in cache, be silent
  set ( LibNFC_FIND_QUIETLY TRUE )
endif ()

find_package(PkgConfig)
pkg_check_modules(PC_LIBNFC libnfc)


find_path ( LIBNFC_INCLUDE_DIR
            NAMES
            nfc/nfc.h
            PATHS ${PC_LIBNFC_INCLUDEDIR}
          )

# version
set ( LIBNFC_VERSION_STRING ${PC_LIBNFC_VERSION} )
if ( LIBNFC_VERSION_STRING )
  string ( REGEX REPLACE "([0-9]+)\\..*" "\\1" LIBNFC_MAJOR_VERSION ${LIBNFC_VERSION_STRING} )
  string ( REGEX REPLACE "[0-9]+\\.([0-9]+).*" "\\1" LIBNFC_MINOR_VERSION ${LIBNFC_VERSION_STRING} )
  string ( REGEX REPLACE "[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" LIBNFC_PATCH_VERSION ${LIBNFC_VERSION_STRING} )
  if ( LIBNFC_PATCH_VERSION STREQUAL LIBNFC_VERSION_STRING )
    set ( LIBNFC_PATCH_VERSION )
  endif ()
endif ()


find_library ( LIBNFC_LIBRARY
               NAMES nfc
               PATHS ${PC_LIBNFC_LIBDIR}
               )
               
# handle REQUIRED and QUIET options
include ( FindPackageHandleStandardArgs )
# include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args ( LibNFC 
  REQUIRED_VARS LIBNFC_LIBRARY LIBNFC_INCLUDE_DIR
  VERSION_VAR LIBNFC_VERSION_STRING
)

if (LIBNFC_FOUND)          
  set ( LIBNFC_INCLUDE_DIRS ${LIBNFC_INCLUDE_DIR} )
  set ( LIBNFC_LIBRARIES ${LIBNFC_LIBRARY} )
  list (APPEND LIBNFC_LIBRARIES usb)
  string ( REGEX REPLACE "(.*)/include.*" "\\1" LIBNFC_ROOT_DIR ${LIBNFC_INCLUDE_DIR} )
endif ()

mark_as_advanced (
  LIBNFC_LIBRARY
  LIBNFC_LIBRARIES
  LIBNFC_INCLUDE_DIR
  LIBNFC_INCLUDE_DIRS
  LIBNFC_ROOT_DIR 
  LIBNFC_VERSION_STRING
  LIBNFC_MAJOR_VERSION
  LIBNFC_MINOR_VERSION
  LIBNFC_PATCH_VERSION
)
