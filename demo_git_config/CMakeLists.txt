cmake_minimum_required(VERSION 2.9)

include(utils.cmake)
project(demo_git_config)


string(TIMESTAMP BUILD_TIMESTAMP "%Y-%m-%d %H:%M:%S")
message("Build timestamp is ${BUILD_TIMESTAMP}")

set(VERSION_MAJOR 0)
set(VERSION_MINOR 0)
set(VERSION_PATCH 1)
message("Version is ${VERSION_MAJOR} ${VERSION_MINOR} ${VERSION_PATCH}")

set(GIT_HASH "")
get_git_hash(GIT_HASH)
message("Git hash is ${GIT_HASH}")

set(GIT_BRANCH "")
get_git_branch(GIT_BRANCH)
message("Git branch is ${GIT_BRANCH}")


configure_file(
    "${PROJECT_SOURCE_DIR}/include/utils.h.in"
    "${PROJECT_SOURCE_DIR}/include/utils.h"
)
add_executable(${PROJECT_NAME} main.cpp)

include_directories(
    ${PROJECT_SOURCE_DIR}/include
)

install(TARGETS ${PROJECT_NAME}
     DESTINATION ${PROJECT_SOURCE_DIR})
