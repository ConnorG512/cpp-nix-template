##############
# Variables: #
##############
cmake_minimum_required(VERSION 3.30)
set(PROJECT_LANGUAGE CXX) # CXX / C
set(PROJECT_NAME App)
set(PROJECT_VERSION 1.0)
set(EXECUTABLE_NAME app)
set(INSTALL_DIR bin)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Used in find_package
set(PACKAGES 
)

# Used in add_executable
set(SOURCE_FILES
  src/main.cpp
)

#############
# Building: #
#############
project(${PROJECT_NAME} ${PROJECT_LANGUAGE})

# Find packages that have been downloaded / inside the nix build derivation:
foreach(pkg IN LISTS PACKAGES)
  find_package(${pkg} REQUIRED)
endforeach()

# Building the executable: 
if(WIN32)
  message(VERBOSE "Building Windows executable.")
  add_executable(${EXECUTABLE_NAME} WIN32 ${SOURCE_FILES})
elseif(UNIX AND NOT APPLE)
  message(VERBOSE "Building Linux executable.")
  add_executable(${EXECUTABLE_NAME} ${SOURCE_FILES})
endif()

# Include directories
target_include_directories(${EXECUTABLE_NAME} PRIVATE 
  "${CMAKE_SOURCE_DIR}/include"
)

# Linking libraries:
target_link_libraries(${EXECUTABLE_NAME} PRIVATE)

# Extra Debug tools for Linux:
if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND UNIX AND NOT APPLE)
  message(VERBOSE "Debug build detected, linking fsanitize and ggdb")
  target_compile_options(${EXECUTABLE_NAME} PRIVATE -fsanitize=address,undefined -ggdb)
  target_link_options(${EXECUTABLE_NAME} PRIVATE -fsanitize=address,undefined)
endif()

install(TARGETS ${EXECUTABLE_NAME} RUNTIME DESTINATION ${INSTALL_DIR})
