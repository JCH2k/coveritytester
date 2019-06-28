
# make the resulting binaries smaller by removing unused functions and data while linking
# be careful, this can break thinks
# at the expense of performance
if(NOT WIN32)		# unit tests on x86 can easily exceed the max available sections
	if(CMAKE_COMPILER_IS_GNUCC)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffunction-sections -fdata-sections")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ffunction-sections -fdata-sections")
		set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections")
	endif()
endif()
