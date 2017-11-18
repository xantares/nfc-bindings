option (LINK_PYTHON_LIBRARY "Link against python libraries" ON )

include_directories (${CMAKE_CURRENT_SOURCE_DIR})

add_definitions (-DHAVE_CONFIG_H)
list (APPEND CMAKE_SWIG_FLAGS "-ignoremissing")

find_package (PythonInterp)
find_package (PythonLibs)

if (PYTHONLIBS_FOUND AND PYTHONINTERP_FOUND)
  include_directories (${PYTHON_INCLUDE_DIRS})
  link_directories (${CMAKE_CURRENT_BINARY_DIR}/../src)

  if (CMAKE_VERSION VERSION_LESS 3.8)
    swig_add_module (nfc python ../nfc.i)
  else ()
    swig_add_library (nfc LANGUAGE python SOURCES ../nfc.i)
  endif ()

  swig_link_libraries (nfc ${LIBNFC_LIBRARIES})

  if (LINK_PYTHON_LIBRARY)
    swig_link_libraries (nfc ${PYTHON_LIBRARIES})
  endif ()

  set_target_properties (${SWIG_MODULE_nfc_REAL_NAME} PROPERTIES NO_SONAME ON)

  execute_process ( COMMAND ${PYTHON_EXECUTABLE} -c "from distutils import sysconfig; print(sysconfig.get_python_lib( plat_specific=True, prefix='${CMAKE_INSTALL_PREFIX}'))"
                    OUTPUT_VARIABLE _ABS_PYTHON_MODULE_PATH
                    OUTPUT_STRIP_TRAILING_WHITESPACE )

  get_filename_component ( _ABS_PYTHON_MODULE_PATH ${_ABS_PYTHON_MODULE_PATH} ABSOLUTE )
  file ( RELATIVE_PATH _REL_PYTHON_MODULE_PATH ${CMAKE_INSTALL_PREFIX} ${_ABS_PYTHON_MODULE_PATH} )

  set ( PYTHON_MODULE_PATH
        ${_REL_PYTHON_MODULE_PATH}
      )

  install (FILES ${CMAKE_CURRENT_BINARY_DIR}/nfc.py DESTINATION ${PYTHON_MODULE_PATH})
  install (TARGETS ${SWIG_MODULE_nfc_REAL_NAME} LIBRARY DESTINATION ${PYTHON_MODULE_PATH})

  set (NFC_PYTHON_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/${PYTHON_MODULE_PATH} )

  
  add_subdirectory (examples)
endif ()


