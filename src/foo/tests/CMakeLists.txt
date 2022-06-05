# Create test executable
add_executable(test-foo
  tests.cpp
)

# Link test dependencies
target_link_libraries(test-foo
  PRIVATE
    foo
    project_warnings
    GTest::gtest
    GTest::gtest_main
)

# Register with ctest
add_test(NAME test-foo COMMAND test-foo)

# Enable code coverage if requested
if(ENABLE_COVERAGE)
  target_compile_options(test-foo PRIVATE --coverage)
  target_link_options(test-foo PRIVATE --coverage)
endif()
