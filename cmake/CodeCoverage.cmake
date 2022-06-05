# Code coverage configuration
#
# Usage:
#   1. Add ENABLE_COVERAGE=ON to cmake configuration
#   2. Build your project
#   3. Run tests
#   4. Run 'make coverage' to generate report

if(ENABLE_COVERAGE)
  if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    # Add coverage flags
    add_compile_options(--coverage -O0 -g)
    add_link_options(--coverage)

    # Find required tools
    find_program(LCOV lcov REQUIRED)
    find_program(GENHTML genhtml REQUIRED)

    # Setup coverage target
    add_custom_target(coverage
      COMMAND ${LCOV} --directory . --zerocounters
      COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target test
      COMMAND ${LCOV} --directory . --capture
        --output-file coverage.info
      COMMAND ${LCOV} --remove coverage.info
        '/usr/*' '${CMAKE_BINARY_DIR}/*' 'test/*'
        --output-file coverage.info.cleaned
      COMMAND ${GENHTML} -o coverage coverage.info.cleaned
      COMMAND ${CMAKE_COMMAND} -E echo
        "Coverage report generated in ${CMAKE_BINARY_DIR}/coverage/index.html"
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      COMMENT "Generating code coverage report"
    )
  else()
    message(WARNING "Code coverage only supported with GCC or Clang")
  endif()
endif()
