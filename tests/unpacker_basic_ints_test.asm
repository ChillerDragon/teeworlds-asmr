%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_one_byte_ints:
    mov byte [generic_buffer_128 + 0], 0x01
    mov byte [generic_buffer_128 + 1], 0x02
    unpacker_reset generic_buffer_128, 2

    call get_int
    assert_eax_eq 1, __LINE__
    call get_int
    assert_eax_eq 2, __LINE__

_test_negative_multi_byte:
    mov byte [generic_buffer_128 + 0], 0xff
    mov byte [generic_buffer_128 + 1], 0x01
    unpacker_reset generic_buffer_128, 2

    call get_int
    assert_eax_eq -128, __LINE__

_test_negative_three_byte:
    mov byte [generic_buffer_128 + 0], 0xff
    mov byte [generic_buffer_128 + 1], 0xff
    mov byte [generic_buffer_128 + 2], 0x01
    unpacker_reset generic_buffer_128, 3

    call get_int
    assert_eax_eq -16384, __LINE__

_test_positive_three_byte:
    mov byte [generic_buffer_128 + 0], 0x80
    mov byte [generic_buffer_128 + 1], 0xff
    mov byte [generic_buffer_128 + 2], 0x01
    unpacker_reset generic_buffer_128, 3

    call get_int
    assert_eax_eq 16320, __LINE__

_test_positive_three_byte_plus_one_byte:
    mov byte [generic_buffer_128 + 0], 0x80
    mov byte [generic_buffer_128 + 1], 0xff
    mov byte [generic_buffer_128 + 2], 0x01
    mov byte [generic_buffer_128 + 3], 0x06
    unpacker_reset generic_buffer_128, 4

    call get_int
    assert_eax_eq 16320, __LINE__
    call get_int
    assert_eax_eq 6, __LINE__

_test_int_plus_string:
    mov byte [generic_buffer_128 + 0], 0x01
    mov byte [generic_buffer_128 + 1], 'A'
    mov byte [generic_buffer_128 + 2], 'B'
    mov byte [generic_buffer_128 + 3], 0x00
    unpacker_reset generic_buffer_128, 4

    call get_int
    assert_eax_eq 1, __LINE__

    call get_string
    mov rdi, rax
    str_to_stack "AB"
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp

_test_multiple_ints_plus_strings:
    mov byte [generic_buffer_128 + 0], 0x02
    mov byte [generic_buffer_128 + 1], 'C'
    mov byte [generic_buffer_128 + 2], 'C'
    mov byte [generic_buffer_128 + 3], 0x00
    mov byte [generic_buffer_128 + 4], 0x05
    mov byte [generic_buffer_128 + 5], 'f'
    mov byte [generic_buffer_128 + 6], 'o'
    mov byte [generic_buffer_128 + 7], 'o'
    mov byte [generic_buffer_128 + 8], 0x00
    mov byte [generic_buffer_128 + 9], 0x09
    unpacker_reset generic_buffer_128, 10

    call get_int
    assert_eax_eq 2, __LINE__

    call get_string
    mov rdi, rax
    str_to_stack "CC"
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp

    call get_int
    assert_eax_eq 5, __LINE__

    call get_string
    mov rdi, rax
    str_to_stack "foo"
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp

    call get_int
    assert_eax_eq 9, __LINE__

_test_unpack_raw:
    mov byte [generic_buffer_128 + 0], 0x02
    mov byte [generic_buffer_128 + 1], 'C'
    mov byte [generic_buffer_128 + 2], 'C'
    mov byte [generic_buffer_128 + 3], 0x00
    mov byte [generic_buffer_128 + 4], 0x05
    mov byte [generic_buffer_128 + 5], 'f'
    mov byte [generic_buffer_128 + 6], 'o'
    mov byte [generic_buffer_128 + 7], 'o'
    mov byte [generic_buffer_128 + 8], 0x00
    mov byte [generic_buffer_128 + 9], 0x09
    unpacker_reset generic_buffer_128, 10

    call get_int
    assert_eax_eq 2, __LINE__

    mov rax, 3
    call get_raw
    mov rdi, rax
    str_to_stack "CC"
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp

    call get_int
    assert_eax_eq 5, __LINE__

    call get_string
    mov rdi, rax
    str_to_stack "foo"
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp

    call get_int
    assert_eax_eq 9, __LINE__

    end_test __LINE__

