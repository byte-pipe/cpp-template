# Create foo library
add_library(foo STATIC
  src/foo.cpp
)

# Set include directories
target_include_directories(foo
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  PRIVATE
    src
)

# Link dependencies
target_link_libraries(foo
  PUBLIC
    common
  PRIVATE
    project_warnings
)

# Sanitizers
enable_sanitizers(foo)

# Add tests
if(BUILD_TESTING)
  add_subdirectory(tests)
endif()

# Installation
install(TARGETS foo
  EXPORT ${PROJECT_NAME}Targets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
