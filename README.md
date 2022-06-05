# C++ Project Template

Modern C++20 project template with CMake, Google Test, and Ninja.

## Requirements

**Required:**

- CMake 3.25+ (`brew install cmake`)
- C++20 compiler (GCC 10+, Clang 10+, MSVC 2019+)
- Ninja (`brew install ninja`)

**Optional (targets degrade gracefully if missing):**

- clang-format -- for `make format` / `make format-check` (included with Xcode)
- clang-tidy -- for `make tidy` / `make tidy-fix` (`brew install llvm` on macOS)
- lcov + genhtml -- for `make coverage`
- pre-commit -- for git hooks (`pip install pre-commit`)

Google Test is fetched automatically by CMake (no install needed).

## Quick Start

```bash
make build    # generate + build
make test     # run all tests
make run      # run the application
```

## Project Structure

```
CMakeLists.txt              # main cmake config
Makefile                    # convenience wrapper
cmake/                      # cmake modules (ClangTools, CodeCoverage)
src/
  common/include/           # shared headers
  foo/                      # library module
    include/ src/ tests/
  app/                      # application
    src/
```

## Make Targets

| Target              | Description                        | Requires      |
| ------------------- | ---------------------------------- | ------------- |
| `make build`        | Generate + build                   | cmake, ninja  |
| `make rebuild`      | Clean + build                      | cmake, ninja  |
| `make test`         | Build + run tests via ctest        | ctest         |
| `make run`          | Build + run application            |               |
| `make clean`        | Remove build directory             |               |
| `make format`       | Format code with clang-format      | clang-format  |
| `make format-check` | Check formatting without modifying | clang-format  |
| `make tidy`         | Run clang-tidy static analysis     | clang-tidy    |
| `make tidy-fix`     | Run clang-tidy with auto-fix       | clang-tidy    |
| `make coverage`     | Generate code coverage report      | lcov, genhtml |
| `make xcode`        | Generate + open Xcode project      | macOS         |

## Sanitizers

Off by default. Enable via CMake options:

```bash
cmake -B .build -DENABLE_ASAN=ON     # AddressSanitizer (memory errors)
cmake -B .build -DENABLE_TSAN=ON     # ThreadSanitizer (data races)
cmake -B .build -DENABLE_UBSAN=ON    # UndefinedBehaviorSanitizer
```

## Adding a New Module

1. Create the directory structure:

```
src/mymodule/
  CMakeLists.txt
  include/mymodule.h
  src/mymodule.cpp
  tests/
    CMakeLists.txt
    tests.cpp
```

2. Add `add_subdirectory(mymodule)` to `src/CMakeLists.txt`.

3. Update `app_binaries` in the Makefile if the module produces an executable.

## Customizing for a New Project

Update the clearly marked `PROJECT SETTINGS` sections:

- **CMakeLists.txt** -- `project()` name and version
- **Makefile** -- `app_binaries` paths

Everything else (build targets, cmake modules, test infrastructure) is generic boilerplate.

## License

MIT
