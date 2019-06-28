
# Generates a binary for unit test with gtest.
# You can call the resulting binaries directly or call 'ctest' in your ${CMAKE_BINARY_DIR} to call all binaries (then xml files are stored in ${CMAKE_BINARY_DIR}/Testing/).
# Define TEST_SOURCE_FILES before including this file to define your test files to compile.
# If you alternatively define TEST_SOURCE_FILES_n (with n 1, 2, 3, ...) you get multiple binaries, e.g. when your test file got to big.
# Optional: Define TEST_LINK_LIBRARIES and/or TEST_INCLUDE_DIRECTORIES if they are necessary for compiling.
if(BUERKERT_USE_TESTING)
  foreach(loop_var RANGE 1 100 1)
    if(TEST_SOURCE_FILES_${loop_var})
      LIST(APPEND allNumbers ${loop_var})
    else( TEST_SOURCE_FILES_${loop_var} )
      break()
    endif()
  endforeach()
  list(LENGTH allNumbers length)

  if(TEST_SOURCE_FILES)
    if(${length} GREATER 0)
      message(FATAL_ERROR "Define for TEST_SOURCE_FILES and TEST_SOURCE_FILES_n may not occur simultaneously!")
    else()
      # only TEST_SOURCE_FILES is set, append any number to loop exactly once
      LIST(APPEND allNumbers 0)
    endif( ${length} GREATER 0 )
  else()
    if(${length} EQUAL 0)
      message(FATAL_ERROR "Forgot to define TEST_SOURCE_FILES?")
    endif( ${length} EQUAL 0 )
  endif( TEST_SOURCE_FILES )

  set(OLD_CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS})
  foreach(count IN LISTS allNumbers)
  	
  	if( DEFINED TESTED_CLASS )
    	set(TEST_TARGET ${TESTED_CLASS})
    else()
    	set(TEST_TARGET ${TARGET})
    endif( DEFINED TESTED_CLASS )
    
    if(${length} GREATER 0)
      set(TEST_TARGET ${TEST_TARGET}_${count})
      set(TEST_SOURCE_FILES "${TEST_SOURCE_FILES_${count}}")
    endif( ${length} GREATER 0 )
    
    set(TEST_TARGET ${TEST_TARGET}_test)
    
    set( TEST_ENABLED UNITTEST_${TEST_TARGET}_ENABLED ) 
    set( ${TEST_ENABLED} ON CACHE BOOL "ON if ${TEST_TARGET} should be compiled" )
    
    if( TEST_ENABLED )

        add_test(${TEST_TARGET} ${TEST_TARGET} "--gtest_output=xml:${CMAKE_BINARY_DIR}/Testing/${TEST_TARGET}.xml")
    
        if(NOT WIN32 AND NOT ${BUERKERT_BUILD_ARCH} STREQUAL "Linux")
          include(DefaultLinkerScript)
          include(DefaultBuerkertImplDir)
    
          # pull in the objects from ESA_Implementation that should appear on the linker command line
          set(CMAKE_EXE_LINKER_FLAGS "${OLD_CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${TEST_TARGET}.map -T ${BUERKERT_UNITTEST_LINKER_SCRIPT}")
          set(IMPLEMENTATION_OBJECTS $<TARGET_OBJECTS:ESA_Implementation_CmdLineLink>)
          set(IMPLEMENTATION_LIB     ESA_Implementation)
        else()
          include(DefaultBuerkertImplDir)
          if(EXISTS ${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR})
               set(IMPLEMENTATION_LIB ESA_Implementation)
          else()
              message(STATUS "${TEST_TARGET} for ${BUERKERT_BUILD_ARCH} without Implementation")
        endif( EXISTS ${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR} )
      endif( NOT WIN32 AND NOT ${BUERKERT_BUILD_ARCH} STREQUAL "Linux" )
    
        add_executable(${TEST_TARGET} ${IMPLEMENTATION_OBJECTS} ${TEST_SOURCE_FILES})
        target_link_libraries(${TEST_TARGET} ${IMPLEMENTATION_LIB} ${TARGET} gtest gtest_main gmock ESA_Core_Mock ESA_Interface_Mock ${TEST_LINK_LIBRARIES})
      if( TEST_COMPILE_DEFINITIONS )
        target_compile_definitions( ${TEST_TARGET} PRIVATE ${TEST_COMPILE_DEFINITIONS} )
      endif( TEST_COMPILE_DEFINITIONS )
        if(NOT "${TEST_INCLUDE_DIRECTORIES}" STREQUAL "")
          target_include_directories(${TEST_TARGET} PRIVATE ${TEST_INCLUDE_DIRECTORIES})
      endif( NOT "${TEST_INCLUDE_DIRECTORIES}" STREQUAL "" )
    
        if( BUERKERT_COVERAGE )
		    message( STATUS "Cover ${TEST_TARGET}" )
		    set_target_properties( ${TEST_TARGET} PROPERTIES COMPILE_FLAGS ${COVERAGE_BUILD_FLAGS} )
      endif( BUERKERT_COVERAGE )
    
        if(NOT WIN32 AND NOT ${BUERKERT_BUILD_ARCH} STREQUAL "Linux" )
          set_target_properties(${TEST_TARGET} PROPERTIES LINK_DEPENDS ${BUERKERT_UNITTEST_LINKER_SCRIPT})      # dependency on linkerscript
          # the following custom command is only necessary for clion for now, we can remove it if clion supports flashing the binary natively
          # for eclipse projects this does not harm at all
          add_custom_target(
                  FLASH_${TEST_TARGET}
                  COMMAND "arm-none-eabi-gdb.exe" ^
                  -iex "target remote tcp:127.0.0.1:2331" ^
                  -iex "monitor speed auto" ^
                  -iex "monitor flash download = 1" ^
                  -iex "monitor reset" ^
                  -iex "load ${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_FILE_NAME:${TEST_TARGET}>" ^
                  -iex "disconnect" ^
                  -iex "quit"
          )
      endif( NOT WIN32 AND NOT ${BUERKERT_BUILD_ARCH} STREQUAL "Linux" )
    
        if(NOT SKIP_POSTBUILD_STEP)
          if(NOT WIN32 AND NOT ${BUERKERT_BUILD_ARCH} STREQUAL "Linux")
            get_filename_component(POSTBUILD_SCRIPT ${CMAKE_SOURCE_DIR}/Buildsystem_CMake/postbuildstep.bat PROGRAM)
          else()
            get_filename_component(POSTBUILD_SCRIPT ${CMAKE_SOURCE_DIR}/Buildsystem_CMake/postbuildstepCopyOnly.bat PROGRAM)
        endif( NOT WIN32 AND NOT ${BUERKERT_BUILD_ARCH} STREQUAL "Linux" )
    
            add_custom_command(
              TARGET ${TEST_TARGET}
              POST_BUILD
              COMMAND ${POSTBUILD_SCRIPT}
              ARGS $<TARGET_FILE_NAME:${TEST_TARGET}> ${TEST_TARGET} ${CMAKE_SOURCE_DIR} ${CMAKE_BUILD_TYPE} 1
              WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} # cmake bug? needed so COMMAND isn't called relatively which doesn't work
              COMMENT "Running post build step for ${TEST_TARGET}"
            )
      endif( NOT SKIP_POSTBUILD_STEP )
        
    endif( TEST_ENABLED )
  endforeach()
  #reset temporary vars
  unset( TEST_LINK_LIBRARIES )
  unset( TEST_COMPILE_DEFINITIONS )
  unset( TESTED_CLASS )
endif( BUERKERT_USE_TESTING )
