
# check if BUERKERT_BUILD_IMPL is set
if("${BUERKERT_BUILD_IMPL}" STREQUAL "")
	message(FATAL_ERROR "BUERKERT_BUILD_IMPL not defined. Use CMake GUI or the like to define it in the CMake cache (e.g. STM32F427). The build architecture is ${BUERKERT_BUILD_ARCH}.")
endif()

# check if source and binary dir differs
if("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
	message(SEND_ERROR "Please use out-of-source builds!")
endif()

# check for CMAKE_BUILD_TYPE, what never should happen
if(NOT CMAKE_BUILD_TYPE)
	message(FATAL_ERROR "CMAKE_BUILD_TYPE not defined.")
endif()