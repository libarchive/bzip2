set(MAN_FILES bzip2.1 bzgrep.1 bzdiff.1 bzmore.1)
foreach(m IN LISTS MAN_FILES)
    install(
        FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/${m}
        DESTINATION
            ${CMAKE_INSTALL_PREFIX}/man/man1)
endforeach()
