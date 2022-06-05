# Create application executable
add_executable(app
  src/main.cpp
)

# Link dependencies
target_link_libraries(app
  PRIVATE
    foo
    common
    project_warnings
)

# Installation
install(TARGETS app
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
