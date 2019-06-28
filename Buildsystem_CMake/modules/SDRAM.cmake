
# enable SDRAM define
string( FIND "${BUERKERT_BUILD_IMPL}" "STM32F42" F4 )
string( FIND "${BUERKERT_BUILD_IMPL}" "STM32F7" F7 )

if(( "${F4}" EQUAL 0 ) OR ( "${F7}" EQUAL 0 ))
  set( BUERKERT_USE_SDRAM ON CACHE BOOL "use the sdram" )
  if( BUERKERT_USE_SDRAM )
    add_definitions( -DUSE_EXT_SDRAM=1 )
  endif()
endif()