
set(BUERKERT_USE_TESTING ON CACHE BOOL "Use Google Test for Unit Testing")
if(BUERKERT_USE_TESTING)
	enable_language( CXX )
	add_definitions(-DBUERKERT_USE_TESTING)
	enable_testing()
	if( ${BUERKERT_BUILD_ARCH} STREQUAL "X86" OR ${BUERKERT_BUILD_ARCH} STREQUAL "CORTEX_M4" OR ${BUERKERT_BUILD_ARCH} STREQUAL "CORTEX_M3" OR ${BUERKERT_BUILD_ARCH} STREQUAL "CORTEX_M7" )
		#disable pthread
	set(gtest_disable_pthreads ON CACHE BOOL "Build gtest without pthread" FORCE)
	endif()
	add_subdirectory(Testsystem_gtest)
	include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})
	include_directories(${gmock_SOURCE_DIR}/include ${gmock_SOURCE_DIR})
	
	target_compile_definitions( gtest 
							PRIVATE 
										BUERKERT_PACKAGE_NAME="${BUERKERT_BUILD_IMPL}_${CMAKE_BUILD_TYPE}"
							)
	
if( NOT ${BUERKERT_BUILD_ARCH} STREQUAL "X86" AND NOT ${BUERKERT_BUILD_ARCH} STREQUAL "Linux" )
	include(DefaultBuerkertImplDir)
endif()
	include(DefaultUserAreaPath)
	target_include_directories(gtest_main PUBLIC
		${ESA_USER_AREA_PATH}
		${CMAKE_SOURCE_DIR}/ESA_Interface
		${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/
		${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl
		${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/specific
	)

	string(REGEX MATCH "STM32F[0-9]" RegResult ${BUERKERT_BUILD_IMPL}) # RegResult could be STM32F3, STM32F4, ...
	if("${RegResult}" STREQUAL "STM32F1")
		target_include_directories(gtest_main PUBLIC
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f10x
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f10x/inc
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f10x/CM3
		)
	elseif("${RegResult}" STREQUAL "STM32F2")
		target_include_directories(gtest_main PUBLIC
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f2xx
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f2xx/inc
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f2xx/CM3
		)
	elseif("${RegResult}" STREQUAL "STM32F3")
		target_include_directories(gtest_main PUBLIC
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f3xx
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f3xx/inc
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f3xx/CM3
		)
	elseif("${RegResult}" STREQUAL "STM32F4")
		target_include_directories(gtest_main PUBLIC
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f4xx
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f4xx/inc
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f4xx/CM4
		)
	elseif("${RegResult}" STREQUAL "STM32F7")
		target_include_directories(gtest_main PUBLIC
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f7xx
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f7xx/inc
			${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR}/impl/libstm32f7xx/CM7
		)
		target_compile_definitions(gtest_main PUBLIC STM32F745xx)
	elseif(${BUERKERT_BUILD_ARCH} STREQUAL "X86")
	elseif(${BUERKERT_BUILD_ARCH} STREQUAL "Linux")
	else()
		message(WARNING "Unknown Implementation. Add correct include directories for target 'gtest' in your main CMakeLists.txt.")
	endif()
endif()
