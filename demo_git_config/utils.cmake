# 用于获取git的hash和分支
macro(get_git_hash _git_hash)
    find_package(GIT QUIET) 
    if(GIT_FOUND)# GIT_FOUND是内置变量
        execute_process( # cmake：execute_process执行外部命令
            # command 是命令行执行
            # GIT_EXECUTABLE 是git执行路径， -1 是最后一条
            #-—pretty＝：使用其他格式显示历史提交信息，可选项有：oneline,short,medium,full,fuller,email,raw以及format:<string>,默认为medium，如：
            # --pretty=oneline：一行显示，只显示哈希值和提交说明（--online本身也可以作为单独的属性）
            # --pretty=format:” "：控制显示的记录格式，如：
            #     %H  提交对象（commit）的完整哈希字串
            #     %h  提交对象的简短哈希字串
            #     %T  树对象（tree）的完整哈希字串
            #     %t  树对象的简短哈希字串
            #     %P  父对象（parent）的完整哈希字串
            #     %p  父对象的简短哈希字串
            #     %an 作者（author）的名字
            #     %ae 作者的电子邮件地址
            #     %ad 作者修订日期（可以用 -date= 选项定制格式）
            #     %ar 作者修订日期，按多久以前的方式显示
            #     %cn 提交者(committer)的名字
            #         作者和提交者的区别不知道是啥？
            #         作者与提交者的关系：作者是程序的修改者，提交者是代码提交人（自己的修改不提交是怎么能让别人拉下来再提交的？）
            #         其实作者指的是实际作出修改的人，提交者指的是最后将此工作成果提交到仓库的人。所以，当你为某个项目发布补丁，然后某个核心成员将你的补丁并入项目时，你就是作者，而那个核心成员就是提交者（soga）
            #     %ce 提交者的电子邮件地址
            #     %cd 提交日期（可以用 -date= 选项定制格式）
            #     %cr 提交日期，按多久以前的方式显示
            #     %s  提交说明
            COMMAND ${GIT_EXECUTABLE} log -1 --pretty=format:%h
            OUTPUT_VARIABLE ${_git_hash}        # 输出字符串存入变量
            OUTPUT_STRIP_TRAILING_WHITESPACE    # 删除字符串尾的换行符
            ERROR_QUIET                         # 对执行错误静默
            WORKING_DIRECTORY                   # 执行路径
              ${CMAKE_CURRENT_SOURCE_DIR}
            )
        endif()
endmacro()

# get git branch
macro(get_git_branch _git_branch)   # 宏的开始
    find_package(Git QUIET)     # 查找Git，QUIET静默方式不报错
    if(GIT_FOUND)
      execute_process(          # 执行一个子进程
        COMMAND ${GIT_EXECUTABLE} symbolic-ref --short -q HEAD
        OUTPUT_VARIABLE ${_git_branch}        # 输出字符串存入变量
        OUTPUT_STRIP_TRAILING_WHITESPACE    # 删除字符串尾的换行符
        ERROR_QUIET                         # 对执行错误静默
        WORKING_DIRECTORY                   # 执行路径
          ${CMAKE_CURRENT_SOURCE_DIR}
        )
    endif()
endmacro()                      # 宏的结束
