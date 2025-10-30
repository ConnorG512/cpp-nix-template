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

set(SOURCE_FILES
  src/main.cpp
)
set(INCLUDE_DIR include)
set(LINKED_LIBRARIES

)

#############
# Building: #
#############
project(${PROJECT_NAME} ${PROJECT_LANGUAGE})

# Platform
if(WIN32)
  add_executable(${EXECUTABLE_NAME} WIN32 ${SOURCE_FILES})
else()
  add_executable(${EXECUTABLE_NAME} ${SOURCE_FILES})
endif()

target_include_directories(${EXECUTABLE_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/${INCLUDE_DIR}")

if(MINGW)
  message(VERBOSE "MINGW Compiler found, static linking libgcc and libstdc++")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libgcc -static-libstdc++")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static-libgcc")
elseif(UNIX AND NOT APPLE)
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(VERBOSE "Debug build detected, linking fsanitize and ggdb")
    target_compile_options(${EXECUTABLE_NAME} PRIVATE -fsanitize=address,undefined -ggdb)
    target_link_options(${EXECUTABLE_NAME} PRIVATE -fsanitize=address,undefined)
  endif()
endif()

# Linking libraries:
foreach(lib IN LISTS LINKED_LIBRARIES)
  find_package(${lib} REQUIRED)
endforeach()
target_link_libraries(${EXECUTABLE_NAME} PRIVATE ${LINKED_LIBRARIES})

install(TARGETS ${EXECUTABLE_NAME} RUNTIME DESTINATION ${INSTALL_DIR})
