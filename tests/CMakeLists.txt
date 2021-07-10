if (ENABLE_APP)
    set(sample1 -1 sample1.ref sample1.bz2)
    set(sample2 -2 sample2.ref sample2.bz2)
    set(sample3 -3 sample3.ref sample3.bz2)


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
                $<TARGET_FILE:bzip2>
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
                $<TARGET_FILE:bzip2>
                ${block_size}
                ${CMAKE_CURRENT_SOURCE_DIR}/${file_name}
        )
    endforeach()

endif(ENABLE_APP)
