cmake_minimum_required(VERSION 3.25)

# =============================================================================
# PROJECT SETTINGS (update for new projects)
# =============================================================================
project(cpp-template VERSION 1.0.0 LANGUAGES CXX)
# =============================================================================

# Default build type for single-config generators
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Build type" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    Debug Release RelWithDebInfo MinSizeRel)
endif()

# Global C++ settings
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Warning flags (link to project targets only, not third-party)
add_library(project_warnings INTERFACE)
target_compile_options(project_warnings INTERFACE
  $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-Wall>
  $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-Wextra>
  $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-Wpedantic>
  $<$<CXX_COMPILER_ID:MSVC>:/W4>
)

# Enable testing
include(CTest)

# Find packages
find_package(Threads REQUIRED)
# need global googletest, brew install googletest, for example
# find_package(GTest REQUIRED)

# Fetch GoogleTest
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.tar.gz
  SYSTEM
)
FetchContent_MakeAvailable(googletest)

# Code coverage option
option(ENABLE_COVERAGE "Enable code coverage" OFF)
if(ENABLE_COVERAGE)
  include(cmake/CodeCoverage.cmake)
endif()

# Sanitizers (cmake -DENABLE_ASAN=ON, -DENABLE_TSAN=ON, -DENABLE_UBSAN=ON)
include(cmake/Sanitizers.cmake)

# Clang tools integration
include(cmake/ClangTools.cmake)

# Add common library for shared headers
add_library(common INTERFACE)
target_include_directories(common INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/common/include>
  $<INSTALL_INTERFACE:include>
)

# Add subdirectories
add_subdirectory(src)

# Installation rules
include(GNUInstallDirs)
install(TARGETS common project_warnings EXPORT ${PROJECT_NAME}Targets)
install(DIRECTORY src/common/include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Export targets
install(EXPORT ${PROJECT_NAME}Targets
  FILE ${PROJECT_NAME}Targets.cmake
  NAMESPACE ${PROJECT_NAME}::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Create package configuration
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)
