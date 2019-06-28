cmake_minimum_required(VERSION 3.0)
project(CoverityTester)    # set here your project name, 'C CXX ASM' is for enabling programming languages

### here you can enable/disable features which are available in the modules directory
### depending on the changed options, you may have to clear the cmake cache and/or clean your project to take effect
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/Buildsystem_CMake/modules)
include(BasicChecks)		# do not disable this basic checks
include(BasicDefines)
include(CodeCoverage)

set(SOURCE_FILES main.cpp InitializationOfArrays.cpp DummyClass.cpp TestWarning.cpp misc.cpp)
add_executable(CoverityTester ${SOURCE_FILES})
