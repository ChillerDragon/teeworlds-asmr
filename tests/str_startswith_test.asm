%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_str_startswith_basic_match:
    ; rax = string
    write_str_to_mem "hello cruel world", generic_buffer_128
    mov rax, generic_buffer_128

    ; rdi = prefix
    write_str_to_mem "hello", generic_buffer_512
    mov rdi, generic_buffer_512

    call str_startswith
    assert_is_true __LINE__

_test_str_startswith_equal_strings:
    ; rax = string
    write_str_to_mem "hello", generic_buffer_128
    mov rax, generic_buffer_128

    ; rdi = prefix
    write_str_to_mem "hello", generic_buffer_512
    mov rdi, generic_buffer_512

    call str_startswith
    assert_is_true __LINE__

_test_str_startswith_empty_prefix:
    ; rax = string
    write_str_to_mem "hello", generic_buffer_128
    mov rax, generic_buffer_128

    ; rdi = prefix
    write_str_to_mem "", generic_buffer_512
    mov rdi, generic_buffer_512

    call str_startswith
    assert_is_true __LINE__

_test_str_startswith_match_trailing_space:
    ; rax = string
    write_str_to_mem "hello world", generic_buffer_128
    mov rax, generic_buffer_128

    ; rdi = prefix
    write_str_to_mem "hello ", generic_buffer_512
    mov rdi, generic_buffer_512

    call str_startswith
    assert_is_true __LINE__

_test_str_startswith_basic_no_match:
    ; rax = string
    write_str_to_mem "cruel world", generic_buffer_128
    mov rax, generic_buffer_128

    ; rdi = prefix
    write_str_to_mem "hello", generic_buffer_512
    mov rdi, generic_buffer_512

    call str_startswith
    assert_is_false __LINE__

_test_str_startswith_basic_no_match2:
    ; rax = string
    write_str_to_mem "xxx", generic_buffer_128
    mov rax, generic_buffer_128

    ; rdi = prefix
    write_str_to_mem "yyy", generic_buffer_512
    mov rdi, generic_buffer_512

    call str_startswith
    assert_is_false __LINE__

_test_str_startswith_basic_no_match_leading_space:
    ; rax = string
    write_str_to_mem " xxx", generic_buffer_128
    mov rax, generic_buffer_128

    ; rdi = prefix
    write_str_to_mem "xxx", generic_buffer_512
    mov rdi, generic_buffer_512

    call str_startswith
    assert_is_false __LINE__

    end_test __LINE__

