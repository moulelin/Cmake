[cmake repository](https://github.com/moulelin/Cmake) stores some learning examples

## 1. Why cmake?

> There are many Make tools, such as GNU Make, QT's qmake, Microsoft's MS nmake, BSD Make (pmake), Makepp, etc. These Make tools follow different norms and standards, and the format of the Makefile they execute varies widely. This brings up a serious problem: if the software wants to be cross-platform, it must be guaranteed to be able to compile on different platforms. And if you use the above Make tool, you have to write a Makefile for each standard, which will be a crazy job. CMake is a tool designed to address the above problems: it first allows developers to write a platform-independent CMakeList.txt file to customize the entire compilation process, and then further generates the required localized Makefile and project files according to the target user's platform


## 2. [make install](https://github.com/moulelin/Cmake/tree/master/demo2_install)


- Customize the paths of compiled .o files and .h files

    - 2.1 CMakeLists.txt in the main directory

        ```
        cmake_minimum_required (VERSION 2.8)

        project(demo1)
        #PROJECT_SOURCE_DIR/CMAKE_SOURCE_DIR/_SOURCE_DIR: The folder path where the last CMakeLists.txt file containing the PROJECT() command is located.
        #PROJECT_BINARY_DIR/CMAKE_BINARY_DIR/_BINARY_DIR: The directory where the cmake command is run, that is, the path where the project compilation takes place.

        configure_file(
            "${PROJECT_SOURCE_DIR}/config.h.in"
            "${PROJECT_BINARY_DIR}/config.h"
        )
        option(USE_MYMATH "Use the provide library" ON)

        if(USE_MYMATH)
            include_directories("${PROJECT_SOURCE_DIR}/math")
            add_subdirectory(math)
            set(EXTRA_LIBS ${EXTRA_LIBS} MathFunctions)
        endif(USE_MYMATH)

        aux_source_directory(.DIR_SRCS)

        # Specify to generate exe files

        add_executable(Demo1 ${DIR_SRCS})
        target_link_libraries(Demo1 ${EXTRA_LIBS})

        # Specify the generated file directory
        install(TARGETS Demo1 DESTINATION bin)
        install(FILES "${PROJECT_BINARY_DIR}/config.h" DESTINATION include)
        ```

        - cmake_minimum_required minimum cmake version requirement
        - project project name
        - configure_file reads the configuration file, just write config.h.in here, and config.h will be automatically generated
        - option as ON and OFF, two options
        - Variables inside if do not need ${}
        - include_directories find the path of the header file
        - add_subdirectory adds a subfolder, and some required classes are stored below
        - set assigns the following value to the previous variable, here:
            - set(EXTRA_LIBS ${EXTRA_LIBS} MathFunctions)
            - EXTRA_LIBS ${EXTRA_LIBS} is for, if EXTRA_LIBS has a value, add a piece, if not, it is empty
            - Same as path=${path}:/usr/
        - aux_source_directory finds the files that need to be executed in the current folder
        - The name of the executable file generated by add_executable
        - target_link_libraries link sub-library (functions and classes that main needs to use)
        - install(TARGETS Demo1 DESTINATION bin) The path of the .o file, the default value is /usr/local/, here is /usr/local/bin
        - You can use set to modify built-in variables to modify the value of `CMAKE_INSTALL_PREFIX`
        - install(FILES "${PROJECT_BINARY_DIR}/config.h" DESTINATION include) .h file path, here is /usr/local/include'


    ---


    - 2.2 CMakeLists.txt in the math directory

    
        ```
        aux_source_directory(.DIR_LIB_SRCS)

        # Specify to generate the MathFunctions link library
        add_library(MathFunctions ${DIR_LIB_SRCS})
        install(TARGETS MathFunctions DESTINATION bin)
        install(FILES MathFunctions.h DESTINATION include)

        ```

    ---

    - 2.3 Project Add Test

        CMake provides a testing tool called CTest. All we have to do is call a series of add_test commands in the CMakeLists file in the project root directory.

        ```
        # enable testing
        enable_testing()

        # Test if the program runs successfully
        add_test (test_run Demo 5 2)

        # Test whether the help information can be prompted normally
        add_test (test_usage Demo)
        set_tests_properties (test_usage
        PROPERTIES PASS_REGULAR_EXPRESSION "Usage: .* base exponent")

        # test the square of 5
        add_test (test_5_2 Demo 5 2)

        set_tests_properties(test_5_2
        PROPERTIES PASS_REGULAR_EXPRESSION "is 25")

        # test 10 to the power of 5
        add_test (test_10_5 Demo 10 5)

        set_tests_properties(test_10_5
        PROPERTIES PASS_REGULAR_EXPRESSION "is 100000")

        # test 2 to the power of 10
        add_test (test_2_10 Demo 2 10)

        set_tests_properties(test_2_10
        PROPERTIES PASS_REGULAR_EXPRESSION "is 1024")
        ```

        or use the macro definition

        ```
        # Define a macro to simplify testing
        macro (do_test arg1 arg2 result)
        add_test (test_${arg1}_${arg2} Demo ${arg1} ${arg2})
        set_tests_properties(test_${arg1}_${arg2}
            PROPERTIES PASS_REGULAR_EXPRESSION ${result})
        endmacro (do_test)
        
        # Use this macro to perform a series of data tests
        do_test(5 2 "is 25")
        do_test(10 5 "is 100000")
        do_test(2 10 "is 1024")
        
        ```

## 3. configure_file
   
   - configure_file(input output options)
   - Copy a file (specified by the input parameter) to the specified location (specified by the output parameter), and modify its content according to options.
   - configure_file command is generally used for custom compilation options or custom macro scenarios. The configure_file command will automatically convert the cmakedefine keyword and its content in the input file according to the rules specified by options

   demo
    
        ```
        qwq
        ```

## 4. cmake gets the hash and version of git, comprehensive example

[Github code](https://github.com/moulelin/Cmake/tree/master/demo_git_config)
Sometimes, we need to indicate the version number, Git hash number, compilation time and other information in the project, but obviously, we don't want to manually fill in the Git hash number and compilation time by ourselves. Now provide a way to write this information into the header file, and then compile it into the so library file or executable program.

In this way, these values ​​can be obtained by providing the interface of the library file or printing the executable program

### 4.1 utils.cmake file

    ```

    # Used to get the hash and branch of git
    macro(get_git_hash_git_hash)
        find_package(GIT QUIET)
        if(GIT_FOUND)# GIT_FOUND is a built-in variable
            execute_process( # cmake: execute_process executes external commands
                # command is command line execution
                # GIT_EXECUTABLE is the git execution path, -1 is the last one
                #--pretty=: use other formats to display historical submission information, the options are: oneline, short, medium, full, fuller, email, raw and format: <string>, the default is medium, such as:
                # --pretty=oneline: one line display, only hash value and submission description (--online itself can also be used as a separate attribute)
                # --pretty=format:” ": Control the displayed record format, such as:
                #%H The complete hash word of the commit object (commit)
                # %h short hash string for the commit object
                # %T The complete hash string of the tree object (tree)
                # %t short hash string for the tree object
                # %P The full hash string of the parent object (parent)
                # %p short hash string of the parent object
                # %an author's name
                # %ae author's email address
                # %ad author modification date (can use -date= option to customize the format)
                # %ar author revision date, in order of how far back
                # %cn the name of the committer
                # What is the difference between author and submitter?
                # The relationship between the author and the submitter: the author is the program modifier, and the submitter is the code submitter (how can others pull it down and submit it if you don’t submit your own modification?)
                # In fact, the author refers to the person who actually made the modification, and the submitter refers to the person who finally submitted the work result to the warehouse. So, when you release a patch for a project, and then some core member merges your patch into the project, you are the author, and that core member is the committer (soga)
                # %ce email address of submitter
                # %cd Commit date (you can customize the format with the -date= option)
                # %cr Commit date, displayed in terms of how long ago
                # %s submission instructions
                COMMAND ${GIT_EXECUTABLE} log -1 --pretty=format:%h
                OUTPUT_VARIABLE ${_git_hash} # output string stored in variable
                # OUTPUT_VARIABLE : Specifies the variable that receives the output to the standard output;
                OUTPUT_STRIP_TRAILING_WHITESPACE # Delete the newline at the end of the string
                ERROR_QUIET # Quiet on execution errors
                WORKING_DIRECTORY # execution path
                ${CMAKE_CURRENT_SOURCE_DIR}
                )
            endif()
    endmacro()

    # get git branch
    macro(get_git_branch _git_branch) # start of macro
        find_package(Git QUIET) # Find Git, QUIET silent mode does not report an error
        if(GIT_FOUND)
        execute_process( # Execute a child process
            COMMAND ${GIT_EXECUTABLE} symbolic-ref --short -q HEAD
            OUTPUT_VARIABLE ${_git_branch} # output string stored in variable
            OUTPUT_STRIP_TRAILING_WHITESPACE # Delete the newline at the end of the string
            ERROR_QUIET # Quiet on execution errors
            WORKING_DIRECTORY # execution path
            ${CMAKE_CURRENT_SOURCE_DIR}
            )
        endif()
    endmacro() # end of macro

    ```

  - Use a macro definition to define two macro definitions
  - Use execute_process to execute external commands
  - OUTPUT_VARIABLE can get the output to the command line and assign it to the variable

### 4.2 CMakeLists.txt

    ```
    cmake_minimum_required (VERSION 2.9)

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

    ```

   - The macro definition is called
    
### 4.3 utils.h.in

    ```
    #ifndef UTILS_H_IN
    #define UTILS_H_IN

    #define VERSION_MAJOR @VERSION_MAJOR@
    #define VERSION_MINOR @VERSION_MINOR@
    #define VERSION_PATCH @VERSION_PATCH@

    #define BUILD_TIMESTAMP "@BUILD_TIMESTAMP@"

    #define GIT_BRANCH "@GIT_BRANCH@"
    #define GIT_HASH "@GIT_HASH@"

    #endif // UTILS_H_IN

    ```

### 4.4 Execute cmake .

  Generate utils.h as follows

    ```
    #ifndef UTILS_H_IN
    #define UTILS_H_IN

    #define VERSION_MAJOR 0
    #define VERSION_MINOR 0
    #define VERSION_PATCH 1

    #define BUILD_TIMESTAMP "2022-11-26 21:35:07"

    #define GIT_BRANCH "master"
    #define GIT_HASH "0e1f110"

    #endif // UTILS_H_IN

    ```

### 4.5 Use make to link .o files to generate executable files

 The output is as follows

    ```
    (base) moule@mouledeMacBook-Air demo_git_config % ./demo_git_config
    version is 0, 0, 1
    timestamp is 2022-11-26 21:35:07
    git is master, 0e1f110
    ```