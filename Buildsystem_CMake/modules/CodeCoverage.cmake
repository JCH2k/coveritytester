if( CMAKE_COMPILER_IS_GNUCC )
	set( BUERKERT_COVERAGE ON CACHE BOOL "Build with Coverage" )
	if( BUERKERT_COVERAGE ) 
		set( COVERAGE_BUILD_FLAGS "-ftest-coverage -fprofile-arcs" )
		set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -ftest-coverage -fprofile-arcs" )
	endif()
endif()