set(sample1 -1 sample1.ref sample1.bz2)
set(sample2 -1 sample2.ref sample2.bz2)
set(sample3 -1 sample3.ref sample3.bz2)

if(WIN32)
    set(BZIP2_EXE "$<CONFIG>/bzip2.exe")
else()
    set(BZIP2_EXE bzip2)
endif()

foreach(TEST
    "${sample1}"
    "${sample2}"
    "${sample3}"
)
    list(GET TEST 0 block_size)
    list(GET TEST 1 file_name)
    list(GET TEST 2 zip_name)

    add_test(NAME "compress_${file_name}"
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/runtest.py
            --mode compress
            ${CMAKE_BINARY_DIR}/${BZIP2_EXE}
            ${block_size}
            ${CMAKE_CURRENT_SOURCE_DIR}/${file_name}
            ${CMAKE_CURRENT_SOURCE_DIR}/${zip_name}
    )
endforeach()

foreach(TEST
    "${sample1}"
    "${sample2}"
    "${sample3}"
)
list(GET TEST 0 block_size)
list(GET TEST 1 file_name)

    add_test(NAME "decompress_${file_name}"
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/runtest.py
            --mode decompress
            ${CMAKE_BINARY_DIR}/${BZIP2_EXE}
            ${block_size}
            ${CMAKE_CURRENT_SOURCE_DIR}/${file_name}
    )
endforeach()
