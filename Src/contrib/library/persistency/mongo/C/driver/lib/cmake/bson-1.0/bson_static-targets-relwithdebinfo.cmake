#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "mongo::bson_static" for configuration "RelWithDebInfo"
set_property(TARGET mongo::bson_static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(mongo::bson_static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELWITHDEBINFO "C"
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/bson-static-1.0.lib"
  )

list(APPEND _cmake_import_check_targets mongo::bson_static )
list(APPEND _cmake_import_check_files_for_mongo::bson_static "${_IMPORT_PREFIX}/lib/bson-static-1.0.lib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
