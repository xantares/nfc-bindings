
include_directories (${CMAKE_CURRENT_SOURCE_DIR})

if (CMAKE_VERSION VERSION_LESS 3.24)
  find_package (Python 3.6 COMPONENTS Interpreter Development)
else ()
  find_package (Python 3.6 COMPONENTS Interpreter Development.Module)
endif ()

if (Python_FOUND)
  include_directories (${Python_INCLUDE_DIRS})

  swig_add_library (nfc LANGUAGE python SOURCES ../nfc.i python_wrapping.c)
  target_link_libraries (${SWIG_MODULE_nfc_REAL_NAME} ${LIBNFC_LIBRARIES})

  if (TARGET Python::Module)
    target_link_libraries (${SWIG_MODULE_nfc_REAL_NAME} Python::Module)
  else ()
    include (TargetLinkLibrariesWithDynamicLookup)
    target_link_libraries_with_dynamic_lookup (${SWIG_MODULE_nfc_REAL_NAME} ${Python_LIBRARIES})
  endif ()

  if (WIN32)
    set (PYTHON_SITE_PACKAGES Lib/site-packages CACHE PATH "sp dir")
  else ()
    set (PYTHON_SITE_PACKAGES ${CMAKE_INSTALL_LIBDIR}/python${Python_VERSION_MAJOR}.${Python_VERSION_MINOR}/site-packages CACHE PATH "sp dir")
  endif ()

  install (FILES ${CMAKE_CURRENT_BINARY_DIR}/nfc.py DESTINATION ${PYTHON_SITE_PACKAGES})
  install (TARGETS ${SWIG_MODULE_nfc_REAL_NAME} LIBRARY DESTINATION ${PYTHON_SITE_PACKAGES})

  set (NFC_PYTHON_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/${PYTHON_MODULE_PATH})

endif ()


