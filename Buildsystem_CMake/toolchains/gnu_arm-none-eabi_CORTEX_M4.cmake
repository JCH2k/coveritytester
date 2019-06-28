#general checks
if( DEFINED ENV{TOOLCHAIN_PATH} )
  set( TOOLCHAIN_PATH $ENV{TOOLCHAIN_PATH} )
else()
  message( FATAL_ERROR "No TOOLCHAIN_PATH environment variable set!" )
endif()
if( NOT EXISTS ${TOOLCHAIN_PATH} )
  message( FATAL_ERROR "${TOOLCHAIN_PATH} does not exist" )
endif()

# http://www.cmake.org/Wiki/CMake_Cross_Compiling
# Name and version of the OS CMake is building for.
set( CMAKE_SYSTEM_NAME Generic )
set( CMAKE_SYSTEM_VERSION 1 )

# set build architecture
set( BUERKERT_BUILD_ARCH CORTEX_M4 )

set( BUERKERT_COMPILER "GNUARM" )

set( GNU_TOOLCHAIN_PATH ${TOOLCHAIN_PATH}/tools/gcc-arm )

# specify the cross compiler if not set
if( NOT CMAKE_C_COMPILER AND NOT CMAKE_CXX_COMPILER )
set( CMAKE_ASM_COMPILER ${GNU_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc.exe )
set( CMAKE_C_COMPILER ${GNU_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc.exe )
set( CMAKE_CXX_COMPILER ${GNU_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc.exe )
endif( NOT CMAKE_C_COMPILER AND NOT CMAKE_CXX_COMPILER )

# where is the target environment
set( CMAKE_FIND_ROOT_PATH ${GNU_TOOLCHAIN_PATH}/arm-none-eabi )

# search for programs in the build host directories
set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )

# for libraries and headers in the target directories
set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY LAST )
set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE LAST )

set( CMAKE_EXE_LINKER_FLAGS "-nostartfiles --specs=nano.specs -nodefaultlibs" )
set( CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb" CACHE STRING "C Compiler flags" )
set( CMAKE_C_FLAGS_DEBUG "-g -DDEBUG" CACHE STRING "Flags used by the compiler during debug builds." )
set( CMAKE_CXX_FLAGS "-mcpu=cortex-m4 -mthumb" CACHE STRING "CXX Compiler flags" )
set( CMAKE_CXX_FLAGS_DEBUG "-g -DDEBUG" CACHE STRING "Flags used by the compiler during debug builds." )