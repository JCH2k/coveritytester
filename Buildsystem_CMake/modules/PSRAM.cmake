
# enable PSRAM define
if( ${BUERKERT_BUILD_IMPL} STREQUAL "STM32F427" )
	set( BUERKERT_USE_PSRAM ON CACHE BOOL "use the psram" )
	if( BUERKERT_USE_PSRAM )
		add_definitions( -DUSE_EXT_SDRAM=1 )
	endif()
endif()