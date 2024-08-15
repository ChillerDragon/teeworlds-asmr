%include "tests/assert.asm"

_start:
    init_test __FILE__

test_str_length_triple_a:
    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00

    ; call to be tested function
    mov rax, assert_input_buf
    call str_length

    assert_eax_eq 3, __LINE__

test_str_length_empty:
    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 0x00

    ; call to be tested function
    mov rax, assert_input_buf
    call str_length

    assert_eax_eq 0, __LINE__
    exit 0
