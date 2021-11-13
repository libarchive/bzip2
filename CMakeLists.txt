cmake_minimum_required(VERSION 3.12)

project(bzip2
        VERSION 1.1.0
        DESCRIPTION "This Bzip2/libbz2 a program and library for lossless block-sorting data compression."
        LANGUAGES C)

# See versioning rule:
#  http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
#
# KEEP THESE IN SYNC WITH meson.build OR STUFF WILL BREAK!
set(LT_CURRENT  1)
set(LT_REVISION 9)
set(LT_AGE      0)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
include(Version)
include(SymLink)

set(BZ_VERSION ${PROJECT_VERSION})
configure_file (
    ${PROJECT_SOURCE_DIR}/bz_version.h.in
    ${PROJECT_BINARY_DIR}/bz_version.h
)
include_directories(${PROJECT_BINARY_DIR})

math(EXPR LT_SOVERSION "${LT_CURRENT} - ${LT_AGE}")
set(LT_VERSION "${LT_SOVERSION}.${LT_AGE}.${LT_REVISION}")
set(PACKAGE_VERSION ${PROJECT_VERSION})
HexVersion(PACKAGE_VERSION_NUM ${PROJECT_VERSION_MAJOR} ${PROJECT_VERSION_MINOR} ${PROJECT_VERSION_PATCH})

set(ENABLE_APP_DEFAULT ON)
set(ENABLE_EXAMPLES_DEFAULT OFF)
set(ENABLE_DOCS_DEFAULT OFF)
include(CMakeOptions.txt)

if(ENABLE_LIB_ONLY AND (ENABLE_APP OR ENABLE_EXAMPLES))
    # Remember when disabled options are disabled for later diagnostics.
    set(ENABLE_LIB_ONLY_DISABLED_OTHERS 1)
else()
    set(ENABLE_LIB_ONLY_DISABLED_OTHERS 0)
endif()
if(ENABLE_LIB_ONLY)
    set(ENABLE_APP      OFF)
    set(ENABLE_EXAMPLES OFF)
endif()

# Do not disable assertions based on CMAKE_BUILD_TYPE.
foreach(_build_type Release MinSizeRel RelWithDebInfo)
    foreach(_lang C)
        string(TOUPPER CMAKE_${_lang}_FLAGS_${_build_type} _var)
        string(REGEX REPLACE "(^|)[/-]D *NDEBUG($|)" " " ${_var} "${${_var}}")
    endforeach()
endforeach()

# Support the latest c++ standard available.
include(ExtractValidFlags)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the build type" FORCE)

    # Include "None" as option to disable any additional (optimization) flags,
    # relying on just CMAKE_C_FLAGS and CMAKE_CXX_FLAGS (which are empty by
    # default). These strings are presented in cmake-gui.
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
        None Debug Release MinSizeRel RelWithDebInfo)
endif()

include(GNUInstallDirs)

# For test scripts and documentation
find_package(Python3)

# Checks for header files.
include(CheckIncludeFile)
check_include_file(arpa/inet.h    HAVE_ARPA_INET_H)
check_include_file(fcntl.h        HAVE_FCNTL_H)
check_include_file(inttypes.h     HAVE_INTTYPES_H)
check_include_file(limits.h       HAVE_LIMITS_H)
check_include_file(netdb.h        HAVE_NETDB_H)
check_include_file(netinet/in.h   HAVE_NETINET_IN_H)
check_include_file(pwd.h          HAVE_PWD_H)
check_include_file(sys/socket.h   HAVE_SYS_SOCKET_H)
check_include_file(sys/time.h     HAVE_SYS_TIME_H)
check_include_file(syslog.h       HAVE_SYSLOG_H)
check_include_file(time.h         HAVE_TIME_H)
check_include_file(unistd.h       HAVE_UNISTD_H)

include(CheckTypeSize)
# Checks for typedefs, structures, and compiler characteristics.
# AC_TYPE_SIZE_T
check_type_size("ssize_t" SIZEOF_SSIZE_T)
if(NOT SIZEOF_SSIZE_T)
    # ssize_t is a signed type in POSIX storing at least -1.
    # Set it to "int" to match the behavior of AC_TYPE_SSIZE_T (autotools).
    set(ssize_t int)
endif()

include(CheckStructHasMember)
check_struct_has_member("struct tm" tm_gmtoff time.h HAVE_STRUCT_TM_TM_GMTOFF)

# Checks for library functions.
include(CheckFunctionExists)
check_function_exists(_Exit     HAVE__EXIT)
check_function_exists(accept4   HAVE_ACCEPT4)
check_function_exists(mkostemp  HAVE_MKOSTEMP)

include(CheckSymbolExists)
# XXX does this correctly detect initgroups (un)availability on cygwin?
check_symbol_exists(initgroups grp.h HAVE_DECL_INITGROUPS)
if(NOT HAVE_DECL_INITGROUPS AND HAVE_UNISTD_H)
    # FreeBSD declares initgroups() in unistd.h
    check_symbol_exists(initgroups unistd.h HAVE_DECL_INITGROUPS2)
    if(HAVE_DECL_INITGROUPS2)
        set(HAVE_DECL_INITGROUPS 1)
    endif()
endif()

set(WARNCFLAGS)
if(CMAKE_C_COMPILER_ID MATCHES "MSVC")
    if(ENABLE_WERROR)
        set(WARNCFLAGS    /WX)
    endif()
else()
    if(ENABLE_WERROR)
        extract_valid_c_flags(WARNCFLAGS    -Werror)
    endif()

    # For C compiler
    # Please keep this list in sync with meson.build
    extract_valid_c_flags(WARNCFLAGS
        -Wall
        -Wextra
        -Wmissing-prototypes
        -Wstrict-prototypes
        -Wmissing-declarations
        -Wpointer-arith
        -Wdeclaration-after-statement
        -Wformat-security
        -Wwrite-strings
        -Wshadow
        -Winline
        -Wnested-externs
        -Wfloat-equal
        -Wundef
        -Wendif-labels
        -Wempty-body
        -Wcast-align
        -Wclobbered
        -Wvla
        -Wpragmas
        -Wunreachable-code
        -Waddress
        -Wattributes
        -Wdiv-by-zero
        -Wshorten-64-to-32
        -Wconversion
        -Wextended-offsetof
        -Wformat-nonliteral
        -Wlanguage-extension-token
        -Wmissing-field-initializers
        -Wmissing-noreturn
        -Wmissing-variable-declarations
        # -Wpadded                          # Not used because we cannot change public structs
        -Wsign-conversion
        # -Wswitch-enum                     # Not used because this basically disallows default case
        -Wunreachable-code-break
        -Wunused-macros
        -Wunused-parameter
        -Wredundant-decls
        -Wheader-guard
        -Wno-format-nonliteral              # This is required because we pass format string as "const char*.
    )
endif()

if(ENABLE_DEBUG)
    set(DEBUGBUILD 1)
endif()

#add_definitions(-DHAVE_CONFIG_H)
#configure_file(cmakeconfig.h.in config.h)

# autotools-compatible names
# Sphinx expects relative paths in the .rst files. Use the fact that the files
# below are all one directory level deep.
file(RELATIVE_PATH top_srcdir   ${CMAKE_CURRENT_BINARY_DIR}/dir ${CMAKE_CURRENT_SOURCE_DIR})
file(RELATIVE_PATH top_builddir ${CMAKE_CURRENT_BINARY_DIR}/dir ${CMAKE_CURRENT_BINARY_DIR})
set(abs_top_srcdir   ${CMAKE_CURRENT_SOURCE_DIR})
set(abs_top_builddir ${CMAKE_CURRENT_BINARY_DIR})
# bzip2.pc (pkg-config file)
set(prefix      ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX})
set(bindir      ${CMAKE_INSTALL_FULL_BINDIR})
set(sbindir     ${CMAKE_INSTALL_FULL_SBINDIR})
set(libdir      ${CMAKE_INSTALL_FULL_LIBDIR})
set(includedir  ${CMAKE_INSTALL_FULL_INCLUDEDIR})
set(VERSION     ${PACKAGE_VERSION})

configure_file(
    bzip2.pc.in
    ${CMAKE_CURRENT_BINARY_DIR}/bzip2.pc
    @ONLY)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/bzip2.pc
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

#
# The build targets.
#   In a larger project, the following would be in subdirectories and
#   These targets would be included with `add_subdirectory()`
#
set(BZ2_SOURCES
    blocksort.c
    huffman.c
    crctable.c
    randtable.c
    compress.c
    decompress.c
    bzlib.c)

# The bz2 OBJECT-library, required for bzip2, bzip2recover.
add_library(bz2_ObjLib OBJECT)
target_sources(bz2_ObjLib
    PRIVATE   ${BZ2_SOURCES}
    PUBLIC    ${CMAKE_CURRENT_SOURCE_DIR}/bzlib_private.h
    INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/bzlib.h)

# Windows resource file
set(BZ2_RES "")
if(WIN32)
    configure_file(
        version.rc.in
        ${CMAKE_CURRENT_BINARY_DIR}/version.rc
        @ONLY)

    set(BZ2_RES ${CMAKE_CURRENT_BINARY_DIR}/version.rc)
endif()

if(ENABLE_SHARED_LIB)
    # The libbz2 shared library.
    add_library(bz2 SHARED ${BZ2_RES})
    target_sources(bz2
        PRIVATE   ${BZ2_SOURCES}
                  ${CMAKE_CURRENT_SOURCE_DIR}/libbz2.def
        PUBLIC    ${CMAKE_CURRENT_SOURCE_DIR}/bzlib_private.h
        INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/bzlib.h)
    # Always use '-fPIC'/'-fPIE' option for shared libraries.
    set_property(TARGET bz2 PROPERTY POSITION_INDEPENDENT_CODE ON)
    set_target_properties(bz2 PROPERTIES
        COMPILE_FLAGS "${WARNCFLAGS}"
        VERSION ${LT_VERSION} SOVERSION ${LT_SOVERSION})
    install(TARGETS bz2 DESTINATION ${CMAKE_INSTALL_LIBDIR})
    install(FILES bzlib.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

    if(USE_OLD_SONAME)
        # Hack to support the old libbz2.so.1.0 version by including an extra copy.
        # Technically the old SONAME is not libtool compatible.
        # This hack is to support binary compatibility with libbz2 in some distro packages.
        if(UNIX AND NOT APPLE)
            add_library(bz2_old_soname SHARED ${BZ2_RES})
            target_sources(bz2_old_soname
                PRIVATE   ${BZ2_SOURCES}
                        ${CMAKE_CURRENT_SOURCE_DIR}/libbz2.def
                PUBLIC    ${CMAKE_CURRENT_SOURCE_DIR}/bzlib_private.h
                INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/bzlib.h
            )
            set_target_properties(bz2_old_soname PROPERTIES
                COMPILE_FLAGS "${WARNCFLAGS}"
                VERSION ${LT_SOVERSION}.${LT_AGE} SOVERSION ${LT_SOVERSION}.${LT_AGE}
                OUTPUT_NAME bz2
            )
            install(TARGETS bz2_old_soname DESTINATION ${CMAKE_INSTALL_LIBDIR})
        endif()
    endif()
endif()

if(ENABLE_STATIC_LIB)
    # The libbz2 static library.
    add_library(bz2_static STATIC)
    target_sources(bz2_static
        PRIVATE     ${BZ2_SOURCES}
        PUBLIC      ${CMAKE_CURRENT_SOURCE_DIR}/bzlib_private.h
        INTERFACE   ${CMAKE_CURRENT_SOURCE_DIR}/bzlib.h)
    set_target_properties(bz2_static PROPERTIES
        COMPILE_FLAGS       "${WARNCFLAGS}"
        VERSION             ${LT_VERSION}
        SOVERSION           ${LT_SOVERSION}
        ARCHIVE_OUTPUT_NAME bz2_static)
    target_compile_definitions(bz2_static PUBLIC BZ2_STATICLIB)
    install(TARGETS bz2_static DESTINATION ${CMAKE_INSTALL_LIBDIR})
    install(FILES bzlib.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endif()

if(ENABLE_APP)
    # The bzip2 executable.
    add_executable(bzip2)
    target_sources(bzip2
        PRIVATE   bzip2.c)
    target_link_libraries(bzip2
        PRIVATE   bz2_ObjLib)
    if(WIN32)
        target_compile_definitions(bzip2 PUBLIC BZ_LCCWIN32 BZ_UNIX=0)
    else()
        target_compile_definitions(bzip2 PUBLIC BZ_LCCWIN32=0 BZ_UNIX)
    endif()
    install(TARGETS bzip2 DESTINATION ${CMAKE_INSTALL_BINDIR})

    # Create bzip2 copies bzcat and bunzip.
    # The default behavior is altered in bzip2.c code by checking the program name.
    install_target_symlink(bzip2 bzcat)
    install_target_symlink(bzip2 bunzip)

    # The bzip2recover executable.
    add_executable(bzip2recover)
    target_sources(bzip2recover
        PRIVATE   bzip2recover.c)
    target_link_libraries(bzip2recover
        PRIVATE bz2_ObjLib)
    if(WIN32)
        target_compile_definitions(bzip2recover PUBLIC BZ_LCCWIN32 BZ_UNIX=0)
    else()
        target_compile_definitions(bzip2recover PUBLIC BZ_LCCWIN32=0 BZ_UNIX)
    endif()
    install(TARGETS bzip2recover DESTINATION ${CMAKE_INSTALL_BINDIR})

    if(ENABLE_EXAMPLES)
        if(ENABLE_SHARED_LIB)
            # The dlltest executable.
            add_executable(dlltest)
            target_sources(dlltest
                PRIVATE   dlltest.c)
            target_link_libraries(dlltest bz2)
            install(TARGETS dlltest DESTINATION ${CMAKE_INSTALL_BINDIR})
        endif()
    endif()

    if(NOT WIN32)
        # Install shell scripts, and renamed copies.
        install(PROGRAMS bzdiff bzgrep bzmore
            DESTINATION ${CMAKE_INSTALL_BINDIR})

        install_script_symlink(bzdiff bzcmp)

        install_script_symlink(bzgrep bzegrep)
        install_script_symlink(bzgrep bzfgrep)

        install_script_symlink(bzmore bzless)
    endif()

endif()

if(Python3_FOUND)
    enable_testing()
    add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND})
    add_subdirectory(tests)
endif()

add_subdirectory(man)

set(DOCGEN_EXECS xsltproc perl xmllint grep pdfxmltex pdftops)

if(ENABLE_DOCS)
    foreach(EXEC IN LISTS DOCGEN_EXECS)
        find_program(${EXEC}_EXEC ${EXEC})
        if(NOT ${EXEC}_EXEC)
            message(WARNING "Missing '${EXEC}', required to generate docs!")
            set(MISSING_GENERATOR TRUE)
        endif()
    endforeach()

    if(MISSING_GENERATOR)
        message(FATAL_ERROR "Unable to generate docs.")
    endif()

    add_subdirectory(docs)
endif()

# The Summary Info.
string(TOUPPER "${CMAKE_BUILD_TYPE}" _build_type)
message(STATUS "Summary of build options:

    Package version: ${VERSION}
    Library version: ${LT_CURRENT}:${LT_REVISION}:${LT_AGE}
    Install prefix:  ${CMAKE_INSTALL_PREFIX}
    Target system:   ${CMAKE_SYSTEM_NAME}
    Compiler:
        Build type:     ${CMAKE_BUILD_TYPE}
        C compiler:     ${CMAKE_C_COMPILER}
        CFLAGS:         ${CMAKE_C_FLAGS_${_build_type}} ${CMAKE_C_FLAGS}
        WARNCFLAGS:     ${WARNCFLAGS}
    Test:
        Python:         ${Python3_FOUND} (${Python3_VERSION}, ${Python3_EXECUTABLE})
    Docs:
        Build docs:     ${ENABLE_DOCS}
    Features:
        Applications:   ${ENABLE_APP}
        Examples:       ${ENABLE_EXAMPLES}
")
if(ENABLE_LIB_ONLY_DISABLED_OTHERS)
    message("Only the library will be built. To build other components "
            "(such as applications and examples), set ENABLE_LIB_ONLY=OFF.")
endif()
