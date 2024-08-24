%include "tests/assert.asm"

_start:
    init_test __FILE__

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
    assert_is_true __LINE__

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
    assert_is_false __LINE__

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
    assert_is_false __LINE__

test_str_comp_different_casing:
    ; prepare
    assert_input_buf_reset
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 'a'
    assert_input_buf_push_byte 'A'
    assert_input_buf_push_byte 0x00

    ; call to be tested function
    mov rax, assert_input_buf
    lea rdi, [assert_input_buf + 4]
    call str_comp
    assert_is_false __LINE__

    end_test __LINE__
