aux_source_directory(. DIR_LIB_SRCS)

# 指定生成 MathFunctions 链接库
add_library (MathFunctions ${DIR_LIB_SRCS})
install(TARGETS MathFunctions DESTINATION bin)
install(FILES MathFunctions.h DESTINATION include)

