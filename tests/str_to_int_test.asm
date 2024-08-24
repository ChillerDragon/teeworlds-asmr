%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_str_to_int_unisgned_123:
    write_str_to_mem "123.", generic_buffer_128
    mov rdi, generic_buffer_128
    call str_to_int_unsigned
    assert_eax_eq 123, __LINE__

_test_str_to_int_unsigned_2:
    write_str_to_mem "2.", generic_buffer_128
    mov rdi, generic_buffer_128
    call str_to_int_unsigned
    assert_eax_eq 2, __LINE__

_test_str_to_int_2:
    write_str_to_mem "2.", generic_buffer_128
    mov rax, generic_buffer_128
    call str_to_int
    assert_eax_eq 2, __LINE__

_test_str_to_int_negative_2:
    write_str_to_mem "-2.", generic_buffer_128
    mov rax, generic_buffer_128
    call str_to_int
    assert_eax_eq -2, __LINE__

_test_str_to_int_negative_512_nullterm:
    str_to_stack "-512"
    call str_to_int
    assert_eax_eq -512, __LINE__
    mov rsp, rbp

_test_str_to_int_non_digits:
    str_to_stack "hello"
    call str_to_int
    assert_eax_eq 0, __LINE__
    mov rsp, rbp

_test_str_to_int_seek:
    str_to_stack "127.0.0.1"
    mov rdi, rax
    call str_to_int_seek_rdi
    assert_eax_eq 127, __LINE__
    inc rdi ; skip dot
    call str_to_int_seek_rdi
    assert_eax_eq 0, __LINE__
    inc rdi ; skip dot
    call str_to_int_seek_rdi
    assert_eax_eq 0, __LINE__
    inc rdi ; skip dot
    call str_to_int_seek_rdi
    assert_eax_eq 1, __LINE__
    mov rsp, rbp

    end_test __LINE__

