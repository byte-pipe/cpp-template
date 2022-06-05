generator = Ninja
build_folder = .build/$$(uname)_$(generator)
build_folder_xcode = $(build_folder)_xcode
build_folder_coverage = $(build_folder)_coverage

# =============================================================================
# PROJECT SETTINGS (update for new projects)
# =============================================================================
app_binaries = $(build_folder)/src/app/app
# =============================================================================

.PHONY : all
all: build

.PHONY : generate
generate:
	@mkdir -p $(build_folder)
	cmake -G $(generator) -B $(build_folder) -Wno-dev 2>&1 | tee $(build_folder)/cmake-generate.log

.PHONY : build
build: generate
	cmake --build $(build_folder) --parallel 2>&1 | tee $(build_folder)/cmake-build.log

.PHONY : rebuild
rebuild: clean build

.PHONY : test
test: build
	cd $(build_folder) && ctest --output-on-failure

.PHONY : coverage
coverage:
	@echo "Generating code coverage report..."
	@rm -rf $(build_folder_coverage)
	@cmake -B $(build_folder_coverage) -G $(generator) -DENABLE_COVERAGE=ON -DCMAKE_BUILD_TYPE=Debug -Wno-dev .
	@cmake --build $(build_folder_coverage) --parallel
	@cd $(build_folder_coverage) && ctest --output-on-failure
	@cmake --build $(build_folder_coverage) --target coverage
	@echo "Coverage report: $(build_folder_coverage)/coverage/index.html"

.PHONY : run
run: build
	for item in $(app_binaries); do $$item; done

.PHONY : clean
clean:
	rm -rf $(build_folder)

.PHONY : format
format: build
	cmake --build $(build_folder) --target format

.PHONY : format-check
format-check: build
	cmake --build $(build_folder) --target format-check

.PHONY : tidy
tidy: build
	cmake --build $(build_folder) --target tidy

.PHONY : tidy-fix
tidy-fix: build
	cmake --build $(build_folder) --target tidy-fix

.PHONY : xcode
xcode:
	cmake -G Xcode -B $(build_folder_xcode) -Wno-dev 2>&1 | tee $(build_folder_xcode)/cmake-generate.log
	open $(build_folder_xcode)/*.xcodeproj

-include *.mk
-include *.make

# export CC=clang, export CXX=clang++
