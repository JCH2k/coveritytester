# first install LLVM from http://releases.llvm.org/download.html to tools/LLVM
find_program(
        CLANG_TIDY_EXE
        NAMES "clang-tidy"
        HINTS $ENV{TOOLCHAIN_PATH}/tools/LLVM/bin
        DOC "Path to clang-tidy executable"
)
if(NOT CLANG_TIDY_EXE)
  message(STATUS "clang-tidy not found.")
else()
  message(STATUS "clang-tidy found: ${CLANG_TIDY_EXE}")
  set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_EXE}" "-checks=-*,google-*,modernize-*,-modernize-use-equals-default" "-extra-arg=-D__GNUC__" "-header-filter=.*")
endif()
