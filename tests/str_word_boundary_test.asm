%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_boundary_space:
    write_str_to_mem "hello world", generic_buffer_128
    mov rax, generic_buffer_128
    call str_get_word_boundary_offset
    assert_eax_eq 5, __LINE__

_test_boundary_another_space:
    write_str_to_mem "hi world", generic_buffer_128
    mov rax, generic_buffer_128
    call str_get_word_boundary_offset
    assert_eax_eq 2, __LINE__

_test_boundary_eol:
    write_str_to_mem "hello", generic_buffer_128
    mov rax, generic_buffer_128
    call str_get_word_boundary_offset
    assert_eax_eq 5, __LINE__

_test_boundary_captial_bra:
    write_str_to_mem "helloBRA", generic_buffer_128
    mov rax, generic_buffer_128
    call str_get_word_boundary_offset
    assert_eax_eq 5, __LINE__

_test_boundary_comma:
    write_str_to_mem "hi,world", generic_buffer_128
    mov rax, generic_buffer_128
    call str_get_word_boundary_offset
    assert_eax_eq 2, __LINE__

_test_boundary_another_comma:
    write_str_to_mem "foo,bar,baz", generic_buffer_128
    mov rax, generic_buffer_128
    call str_get_word_boundary_offset
    assert_eax_eq 3, __LINE__

_test_boundary_zero:
    write_str_to_mem "!bang", generic_buffer_128
    mov rax, generic_buffer_128
    call str_get_word_boundary_offset
    assert_eax_eq 0, __LINE__

    end_test __LINE__

