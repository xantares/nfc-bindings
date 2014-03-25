# - Find LibNFC
# LibNFC is an extensible high performance math expression parser library written in C++
# http://muparser.sourceforge.net
#
# The module defines the following variables:
#  LIBNFC_FOUND        - True if LibNFC found.
#  LIBNFC_INCLUDE_DIRS - where to find nfc/nfc.h, etc.
#  LIBNFC_LIBRARIES    - List of libraries when using LibNFC.
#

if ( LIBNFC_INCLUDE_DIR AND LIBNFC_LIBRARIES )
  # Already in cache, be silent
  set ( LibNFC_FIND_QUIETLY TRUE )
endif ()

find_path ( LIBNFC_INCLUDE_DIR
            NAMES
            nfc/nfc.h
          )
            
set ( LIBNFC_INCLUDE_DIRS ${LIBNFC_INCLUDE_DIR} )

# version
set ( _VERSION_FILE ${LIBNFC_INCLUDE_DIR}/LibNFCDef.h )
if ( EXISTS ${_VERSION_FILE} )
  file ( STRINGS ${_VERSION_FILE} _LIBNFC_VERSION_LINE REGEX "#define[ ]+MUP_VERSION[ ]+_T\\(\".*\"\\)" )
  if ( _LIBNFC_VERSION_LINE )
    string ( REGEX REPLACE ".*_T\\(\"(.*)\"\\)" "\\1" LIBNFC_VERSION_STRING ${_LIBNFC_VERSION_LINE} )
    if ( LIBNFC_VERSION_STRING )
      string ( REGEX REPLACE "([0-9]+)\\..*" "\\1" LIBNFC_MAJOR_VERSION ${LIBNFC_VERSION_STRING} )
      string ( REGEX REPLACE "[0-9]+\\.([0-9]+).*" "\\1" LIBNFC_MINOR_VERSION ${LIBNFC_VERSION_STRING} )
      string ( REGEX REPLACE "[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" LIBNFC_PATCH_VERSION ${LIBNFC_VERSION_STRING} )
      if ( LIBNFC_PATCH_VERSION STREQUAL LIBNFC_VERSION_STRING )
        set ( LIBNFC_PATCH_VERSION )
      endif ()
    endif ()
  endif ()
endif ()

# check version
set ( _LIBNFC_VERSION_MATCH TRUE )
if ( LibNFC_FIND_VERSION AND LIBNFC_VERSION_STRING )
  if ( LibNFC_FIND_VERSION_EXACT )
    if ( ${LibNFC_FIND_VERSION} VERSION_EQUAL ${LIBNFC_VERSION_STRING} )
    else()
      set ( _LIBNFC_VERSION_MATCH FALSE)
    endif ()
  else ()
    if ( ${LibNFC_FIND_VERSION} VERSION_GREATER ${LIBNFC_VERSION_STRING} )
      set ( _LIBNFC_VERSION_MATCH FALSE )
    endif ()
  endif ()
endif ()

find_library ( LIBNFC_LIBRARY
               NAMES nfc
               )
               
# set LIBNFC_LIBRARIES
set ( LIBNFC_LIBRARIES ${LIBNFC_LIBRARY} )
list (APPEND LIBNFC_LIBRARIES usb)

# root dir
# try to guess root dir from include dir
if ( LIBNFC_INCLUDE_DIR )
  string ( REGEX REPLACE "(.*)/include.*" "\\1" LIBNFC_ROOT_DIR ${LIBNFC_INCLUDE_DIR} )

# try to guess root dir from library dir
elseif ( LIBNFC_LIBRARY )
  string ( REGEX REPLACE "(.*)/lib[/|32|64].*" "\\1" LIBNFC_ROOT_DIR ${LIBNFC_LIBRARY} )
endif ()

# handle REQUIRED and QUIET options
include ( FindPackageHandleStandardArgs )

if ( CMAKE_VERSION VERSION_LESS 2.8.3 )
  find_package_handle_standard_args ( LibNFC DEFAULT_MSG LIBNFC_LIBRARY
    _LIBNFC_VERSION_MATCH
    LIBNFC_LIBRARIES
    LIBNFC_INCLUDE_DIR
    LIBNFC_VERSION_STRING
  )
else ()
  find_package_handle_standard_args ( LibNFC 
    REQUIRED_VARS LIBNFC_LIBRARY _LIBNFC_VERSION_MATCH LIBNFC_LIBRARIES LIBNFC_INCLUDE_DIR
    VERSION_VAR LIBNFC_VERSION_STRING
  )
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
