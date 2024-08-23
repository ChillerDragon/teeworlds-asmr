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
    call print_newline ; todo: remove

    mov byte [generic_buffer_128 + 0], 0xff
    mov byte [generic_buffer_128 + 1], 0x01
    unpacker_reset generic_buffer_128, 2

    call get_int
    assert_eax_eq -128, __LINE__

    exit 0

