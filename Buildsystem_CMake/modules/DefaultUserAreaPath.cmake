
# Try to find default UserArea.
# Set ESA_USER_AREA_PATH in your main CMakeLists.txt if your path differs from the ESA default.
if(NOT DEFINED ESA_USER_AREA_PATH)
	set(ESA_USER_AREA_PATH ${CMAKE_SOURCE_DIR}/UserArea)
endif()
if(NOT EXISTS ${ESA_USER_AREA_PATH})
  message(FATAL_ERROR "UserArea on '${ESA_USER_AREA_PATH}' not found! Define a project specific ESA_USER_AREA_PATH in your main CMakeLists.txt.")
endif()
