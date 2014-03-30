option ( LINK_PYTHON_LIBRARY "Link against python libraries" ON )

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_definitions(-DHAVE_CONFIG_H)
set(CMAKE_SWIG_FLAGS "-ignoremissing")

if ( PYTHON_BINDINGS )
  # workaround for cmake bug #0013449
  if ( NOT DEFINED CMAKE_FIND_ROOT_PATH )
    find_package ( SWIG )
  else ()
    find_program ( SWIG_EXECUTABLE NAMES swig2.0 swig )
    if ( SWIG_EXECUTABLE )
      set ( SWIG_USE_FILE ${CMAKE_ROOT}/Modules/UseSWIG.cmake )
      set ( SWIG_FOUND TRUE )
    endif ()
  endif ()
  find_package ( PythonLibs )
  find_package ( PythonInterp )
endif ()

if ( SWIG_FOUND AND PYTHONLIBS_FOUND AND PYTHONINTERP_FOUND )
  include ( UseSWIG )
  include_directories ( ${PYTHON_INCLUDE_DIRS} )
  link_directories ( ${CMAKE_CURRENT_BINARY_DIR}/../src )

  swig_add_module ( nfc python ../nfc.i )
  swig_link_libraries ( nfc ${LIBNFC_LIBRARIES} )

  if ( LINK_PYTHON_LIBRARY )
    swig_link_libraries ( nfc ${PYTHON_LIBRARIES} )
  endif ()

  set_target_properties ( ${SWIG_MODULE_nfc_REAL_NAME} PROPERTIES NO_SONAME ON )

  execute_process ( COMMAND ${PYTHON_EXECUTABLE} -c "from distutils import sysconfig; print( sysconfig.get_python_lib( plat_specific=True, prefix='${CMAKE_INSTALL_PREFIX}' ) )"
                    OUTPUT_VARIABLE _ABS_PYTHON_MODULE_PATH
                    OUTPUT_STRIP_TRAILING_WHITESPACE )

  get_filename_component ( _ABS_PYTHON_MODULE_PATH ${_ABS_PYTHON_MODULE_PATH} ABSOLUTE )
  file ( RELATIVE_PATH _REL_PYTHON_MODULE_PATH ${CMAKE_INSTALL_PREFIX} ${_ABS_PYTHON_MODULE_PATH} )

  set ( PYTHON_MODULE_PATH
        ${_REL_PYTHON_MODULE_PATH}
      )

  install ( FILES ${CMAKE_CURRENT_BINARY_DIR}/nfc.py DESTINATION ${PYTHON_MODULE_PATH} )
  install ( TARGETS ${SWIG_MODULE_nfc_REAL_NAME} LIBRARY DESTINATION ${PYTHON_MODULE_PATH} )

  set ( NFC_PYTHON_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/${PYTHON_MODULE_PATH} )

  
  add_subdirectory(examples)
endif ()


