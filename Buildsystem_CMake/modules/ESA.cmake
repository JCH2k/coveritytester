include(DefaultUserAreaPath)
include_directories(
	ESA_Core
	ESA_Interface
	${ESA_USER_AREA_PATH}
)

#Varaibles for ESA configuration
if( BUERKERT_USE_TESTING )
	set( BUERKERT_ESA_INTERFACE_TESTS OFF CACHE BOOL "Enable ESA Interface Tests" )
	set( BUERKERT_ESA_CORE_TESTS OFF CACHE BOOL "Enable ESA Core Tests" )
endif()
if( BUERKERT_COVERAGE )
	set( BUERKERT_ESA_COVERAGE OFF CACHE BOOL "Build ESA with Coverage" )
endif()

# add ESA sources
add_subdirectory(ESA_Core)
add_subdirectory(ESA_Implementation)
add_subdirectory(ESA_Interface)
