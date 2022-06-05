# Sanitizers.cmake
# Support for AddressSanitizer, ThreadSanitizer, UndefinedBehaviorSanitizer

option(ENABLE_ASAN "Enable AddressSanitizer" OFF)
option(ENABLE_TSAN "Enable ThreadSanitizer" OFF)
option(ENABLE_UBSAN "Enable UndefinedBehaviorSanitizer" OFF)

# Enable sanitizers on a target based on ENABLE_ASAN/TSAN/UBSAN options.
function(enable_sanitizers target_name)
  if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    return()
  endif()

  set(sanitizer_list "")

  if(ENABLE_ASAN)
    list(APPEND sanitizer_list "address")
  endif()

  if(ENABLE_TSAN)
    if(ENABLE_ASAN)
      message(WARNING "TSan is not compatible with ASan. Skipping TSan.")
    else()
      list(APPEND sanitizer_list "thread")
    endif()
  endif()

  if(ENABLE_UBSAN)
    list(APPEND sanitizer_list "undefined")
  endif()

  if(sanitizer_list)
    string(REPLACE ";" "," sanitizer_csv "${sanitizer_list}")
    target_compile_options(${target_name} PUBLIC
      -fsanitize=${sanitizer_csv} -fno-omit-frame-pointer -g)
    target_link_options(${target_name} PUBLIC
      -fsanitize=${sanitizer_csv})
    message(STATUS "Sanitizers enabled for ${target_name}: ${sanitizer_csv}")
  endif()
endfunction()
