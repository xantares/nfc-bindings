
include_directories (${CMAKE_CURRENT_SOURCE_DIR})

add_definitions (-DHAVE_CONFIG_H)
list (APPEND CMAKE_SWIG_FLAGS "-ignoremissing")
separate_arguments (CMAKE_SWIG_FLAGS)

find_package (PythonInterp)
find_package (PythonLibs ${PYTHON_VERSION_STRING} EXACT)

if (PYTHONLIBS_FOUND AND PYTHONINTERP_FOUND)
  include_directories (${PYTHON_INCLUDE_DIRS})

  if (CMAKE_VERSION VERSION_LESS 3.8)
    swig_add_module (nfc python ../nfc.i python_wrapping.c)
  else ()
    swig_add_library (nfc LANGUAGE python SOURCES ../nfc.i python_wrapping.c)
  endif ()

  target_link_libraries (${SWIG_MODULE_nfc_REAL_NAME} ${LIBNFC_LIBRARIES})
  target_link_libraries_with_dynamic_lookup (${SWIG_MODULE_nfc_REAL_NAME} ${PYTHON_LIBRARIES})

  set_target_properties (${SWIG_MODULE_nfc_REAL_NAME} PROPERTIES NO_SONAME ON)

  execute_process ( COMMAND ${PYTHON_EXECUTABLE} -c "from distutils import sysconfig; print(sysconfig.get_python_lib( plat_specific=True, prefix='${CMAKE_INSTALL_PREFIX}'))"
                    OUTPUT_VARIABLE _ABS_PYTHON_MODULE_PATH
                    OUTPUT_STRIP_TRAILING_WHITESPACE )

  get_filename_component (_ABS_PYTHON_MODULE_PATH ${_ABS_PYTHON_MODULE_PATH} ABSOLUTE)
  file (RELATIVE_PATH _REL_PYTHON_MODULE_PATH ${CMAKE_INSTALL_PREFIX} ${_ABS_PYTHON_MODULE_PATH})

  set (PYTHON_MODULE_PATH ${_REL_PYTHON_MODULE_PATH})

  install (FILES ${CMAKE_CURRENT_BINARY_DIR}/nfc.py DESTINATION ${PYTHON_MODULE_PATH})
  install (TARGETS ${SWIG_MODULE_nfc_REAL_NAME} LIBRARY DESTINATION ${PYTHON_MODULE_PATH})

  set (NFC_PYTHON_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/${PYTHON_MODULE_PATH} )

  add_subdirectory (examples)
endif ()


