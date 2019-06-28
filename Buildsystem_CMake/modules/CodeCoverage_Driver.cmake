if( CMAKE_COMPILER_IS_GNUCC )
	if( NOT BUERKERT_USE_TESTING )
		message( FATAL_ERROR "Coverage is currently available only in conjunction with BUERKERT_USE_TESTING!" )
	endif()
	if( BUERKERT_COVERAGE )
		message( STATUS "Cover ${TARGET}" )
		set_target_properties( ${TARGET} PROPERTIES COMPILE_FLAGS ${COVERAGE_BUILD_FLAGS} )
	endif()
endif()
