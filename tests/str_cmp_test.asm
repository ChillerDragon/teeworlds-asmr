%include "tests/assert.asm"

_start:
test_str_comp_aaa_eq:
    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00

    ; call to be tested function
    mov rax, assert_input_buf
    lea rdi, [assert_input_buf + 4]
    call str_comp
    assert_is_true

test_str_comp_aaa_neq:
    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'B'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00

    ; call to be tested function
    mov rax, assert_input_buf
    lea rdi, [assert_input_buf + 4]
    call str_comp
    assert_is_false

test_str_comp_different_length:
    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00

    ; call to be tested function
    mov rax, assert_input_buf
    lea rdi, [assert_input_buf + 4]
    call str_comp
    assert_is_false

    exit 0

