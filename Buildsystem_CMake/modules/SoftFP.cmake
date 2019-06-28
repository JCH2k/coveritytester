
# enable using software floatingpoint; this is a cortex m4 feature
set( BUERKERT_USE_SOFT_FP_ABI ON CACHE BOOL "Using Library for floating point unit." )
if( ${BUERKERT_BUILD_ARCH} STREQUAL "CORTEX_M4" OR ${BUERKERT_BUILD_ARCH} STREQUAL "CORTEX_M7" )
  if( ${BUERKERT_USE_SOFT_FP_ABI} )
    set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=softfp -mfpu=fpv4-sp-d16" )
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfloat-abi=softfp -mfpu=fpv4-sp-d16" )
    set( CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -mfloat-abi=softfp -mfpu=fpv4-sp-d16" )
  endif()
endif()
