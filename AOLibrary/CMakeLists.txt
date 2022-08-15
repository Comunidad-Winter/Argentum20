cmake_minimum_required(VERSION 3.20.2)

# Set the project name
project(AOLibrary VERSION 1.0)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set compiler flags
if (MSVC)
	add_compile_options(-W4)
	
elseif(MINGW OR MSYS)
	# Prevent CMake to append `lib` to the output filename
	set(CMAKE_SHARED_LIBRARY_PREFIX "")
	
	add_compile_options(-Wall -m32)
	add_link_options(-Wl,--kill-at)
endif()

# Get a list of all *.cpp and files to pass to the compiler
file(GLOB SOURCE_CODE CONFIGURE_DEPENDS "src/*.cpp")

# Declare library and sources
add_library(${PROJECT_NAME} SHARED ${SOURCE_CODE})

# Include header files from `include` directory
target_include_directories(${PROJECT_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/src/include")