
set( CMAKE_CXX_STANDARD 11 ) # we use c++11 by default
set( CMAKE_CXX_STANDARD_REQUIRED ON )

if( WIN32 )
  add_definitions( -DWINDOWS )
  add_definitions( -D__STDC_FORMAT_MACROS )
elseif( CMAKE_SYSTEM_NAME STREQUAL "Linux" )
  add_definitions( -DLINUX )
  add_definitions( -D__STDC_LIMIT_MACROS )
  add_definitions( -D__STDC_FORMAT_MACROS )
else()
  if( NOT ${BUERKERT_BUILD_ARCH} STREQUAL CORTEX_M0 )
    add_definitions( -DEMBOS )
  endif()
endif()

if( NOT WIN32 AND NOT CMAKE_SYSTEM_NAME STREQUAL "Linux" )
  set( CMAKE_EXECUTABLE_SUFFIX .elf )
endif()

if( CMAKE_SYSTEM_NAME STREQUAL "Linux" )
  set( CMAKE_EXECUTABLE_SUFFIX "" )
endif()

if( NOT ${BUERKERT_BUILD_IMPL} STREQUAL "" )
  add_definitions( -D${BUERKERT_BUILD_IMPL} )
  message( STATUS "implementation: " ${BUERKERT_BUILD_IMPL} )
endif()

if( NOT ${BUERKERT_BUILD_ARCH} STREQUAL "" )
  add_definitions( -D${BUERKERT_BUILD_ARCH} )
  message( STATUS "architecture: " ${BUERKERT_BUILD_ARCH} )
endif()

if( NOT ${BUERKERT_BUILD_DEF} STREQUAL "" )
  add_definitions( ${BUERKERT_BUILD_DEF} )
  message( STATUS "build specific defines: " ${BUERKERT_BUILD_DEF} )
endif()

if( CMAKE_HOST_UNIX )
  # these lines are from https://stackoverflow.com/questions/15617484/how-to-set-the-maximum-path-length-with-cmake ; untested
  #execute_process(COMMAND getconf PATH_MAX OUTPUT_VARIABLE CMAKE_OBJECT_PATH_MAX OUTPUT_STRIP_TRAILING_WHITESPACE)
else()
  set( CMAKE_OBJECT_PATH_MAX 255 )
  # the following should fix the problem with the
  # cmd max length 8191 limit
  #SET(CMAKE_C_USE_RESPONSE_FILE_FOR_OBJECTS 1)
  #SET(CMAKE_CXX_USE_RESPONSE_FILE_FOR_OBJECTS 1)
  if( NOT CMAKE_EXPORT_COMPILE_COMMANDS )
    set( CMAKE_C_USE_RESPONSE_FILE_FOR_INCLUDES 1 )
    set( CMAKE_CXX_USE_RESPONSE_FILE_FOR_INCLUDES 1 )
    set( CMAKE_C_RESPONSE_FILE_LINK_FLAG "@" )
    set( CMAKE_CXX_RESPONSE_FILE_LINK_FLAG "@" )
  else()
    set( CMAKE_C_USE_RESPONSE_FILE_FOR_INCLUDES 0 )
    set( CMAKE_CXX_USE_RESPONSE_FILE_FOR_INCLUDES 0 )
    message( STATUS "CMAKE_EXPORT_COMPILE_COMMANDS -> no response file usage" )
  endif( NOT CMAKE_EXPORT_COMPILE_COMMANDS )
  # by using a response file instead
endif()

# using -O3 is not recommended
STRING( REPLACE "-O3" "-O2" CMAKE_ASM_FLAGS_RELEASE "${CMAKE_ASM_FLAGS_RELEASE}" )
STRING( REPLACE "-O3" "-O2" CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}" )
STRING( REPLACE "-O3" "-O2" CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}" )

set( BUERKERT_CUSTOM_OPTIMIZATION OFF CACHE BOOL "Custom Optimization for Buerkert Components" )