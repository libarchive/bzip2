set(DOC_TYPES pdf ps html)

find_program(PROG_SH sh)
if(NOT PROG_SH)
    message(FATAL_ERROR "Generator not found!")
endif()

foreach(t IN LISTS DOC_TYPES)
    add_custom_command(
        OUTPUT
            manual.${t}
        COMMAND
            ${PROG_SH} xmlproc.sh -${t} manual.${t}
    )

    install(
        FILES
            ${CMAKE_CURRENT_BINARY_DIR}/manual.${t}
        DESTINATION
            ${CMAKE_INSTALL_PREFIX}/docs)
endforeach()
