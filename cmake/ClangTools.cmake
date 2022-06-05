# Clang tools integration
#
# Adds targets for running clang-format and clang-tidy

# Export compile commands for clang tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Get all source files (for format: headers + sources)
file(GLOB_RECURSE ALL_SOURCE_FILES
  ${CMAKE_SOURCE_DIR}/src/*.cpp
  ${CMAKE_SOURCE_DIR}/src/*.h
  ${CMAKE_SOURCE_DIR}/src/*.hpp
)

# Get only .cpp files (for tidy: needs compile commands)
file(GLOB_RECURSE ALL_CPP_FILES
  ${CMAKE_SOURCE_DIR}/src/*.cpp
)

# Find clang-format
find_program(CLANG_FORMAT clang-format)
if(CLANG_FORMAT)
  # Add format target
  add_custom_target(format
    COMMAND ${CLANG_FORMAT}
    -i
    -style=file
    ${ALL_SOURCE_FILES}
    COMMENT "Running clang-format on all source files"
  )

  # Add format-check target
  add_custom_target(format-check
    COMMAND ${CLANG_FORMAT}
    --dry-run
    --Werror
    -style=file
    ${ALL_SOURCE_FILES}
    COMMENT "Checking code formatting"
  )
endif()

# Find clang-tidy
find_program(CLANG_TIDY clang-tidy
  HINTS /opt/homebrew/opt/llvm/bin
)
if(CLANG_TIDY AND CMAKE_EXPORT_COMPILE_COMMANDS)
  # macOS: homebrew clang-tidy needs the SDK sysroot
  set(CLANG_TIDY_EXTRA_ARGS "")
  if(APPLE)
    execute_process(
      COMMAND xcrun --show-sdk-path
      OUTPUT_VARIABLE _OSX_SYSROOT
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if(_OSX_SYSROOT)
      set(CLANG_TIDY_EXTRA_ARGS "--extra-arg=-isysroot${_OSX_SYSROOT}")
    endif()
  endif()

  # Add tidy target
  add_custom_target(tidy
    COMMAND ${CLANG_TIDY}
    -p ${CMAKE_BINARY_DIR}
    ${CLANG_TIDY_EXTRA_ARGS}
    ${ALL_CPP_FILES}
    COMMENT "Running clang-tidy"
  )

  # Add tidy-fix target
  add_custom_target(tidy-fix
    COMMAND ${CLANG_TIDY}
    -p ${CMAKE_BINARY_DIR}
    ${CLANG_TIDY_EXTRA_ARGS}
    -fix
    -fix-errors
    ${ALL_CPP_FILES}
    COMMENT "Running clang-tidy with fixes"
  )

  # Option to run clang-tidy during build
  option(ENABLE_CLANG_TIDY "Run clang-tidy during build" OFF)
  if(ENABLE_CLANG_TIDY)
    set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY}")
  endif()
endif()
