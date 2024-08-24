%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_str_to_ptr_simple:

    write_str_to_mem "hello", generic_buffer_128
    write_str_to_mem "hello", generic_buffer_512
    assert_str_eq generic_buffer_128, generic_buffer_512, __LINE__

    write_str_to_mem "hello", generic_buffer_128
    write_str_to_mem "world", generic_buffer_512
    assert_str_not_eq generic_buffer_128, generic_buffer_512, __LINE__

    write_str_to_mem "hello", generic_buffer_128
    write_str_to_mem "hello world", generic_buffer_512
    assert_str_not_eq generic_buffer_128, generic_buffer_512, __LINE__

    end_test __LINE__

