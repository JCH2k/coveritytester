
# Try to get directory name of the currenct implementation.
# Set the correct path to your implementation in ESA_Implementation/path.cmake.
if(NOT DEFINED BUERKERT_IMPL_DIR)
	include(${CMAKE_SOURCE_DIR}/ESA_Implementation/path.cmake)
endif()
if(NOT DEFINED BUERKERT_IMPL_DIR AND NOT EXISTS ${CMAKE_SOURCE_DIR}/ESA_Implementation/${BUERKERT_IMPL_DIR})
	message(FATAL_ERROR "Missing Implementation. Go to 'ESA_Implementation/path.cmake' and set the correct path to your implementation. Current BUERKERT_BUILD_IMPL is '${BUERKERT_BUILD_IMPL}'.")
endif()
