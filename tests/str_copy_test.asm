%include "tests/assert.asm"

_start:
    init_test __FILE__

test_str_copy_aaaabbbb:
.test_str_copy_aaaabbbb_copy:
    push rbp
    mov rbp, rsp
    sub rsp, 20
    mov dword [rbp-20], 'aaaa'
    mov dword [rbp-16], 'bbbb'
    mov byte [rbp-12], 0

    ; rax = output buffer
    mov rax, assert_input_buf
    ; rdi = source buffer "aaaabbbb\0"
    lea rdi, [rbp-20]
    ; rsi = random max len
    mov rsi, 512
    call str_copy

    mov rsp, rbp
    pop rbp

    ; expect 8 bytes to be copied
    cmp rax, 8
    assert_is_true __LINE__

.test_str_copy_aaaabbbb_compare_result:
    assert_expect_buf_reset
    assert_expect_buf_push_byte 'a'
    assert_expect_buf_push_byte 'a'
    assert_expect_buf_push_byte 'a'
    assert_expect_buf_push_byte 'a'
    assert_expect_buf_push_byte 'b'
    assert_expect_buf_push_byte 'b'
    assert_expect_buf_push_byte 'b'
    assert_expect_buf_push_byte 'b'
    assert_expect_buf_push_byte 0x00

    mov rax, assert_input_buf
    lea rdi, assert_expect_buf
    call str_comp
    assert_is_true __LINE__

test_str_copy_aaaabbbb_max_len_2:
.test_str_copy_aaaabbbb_max_len_2_copy:
    push rbp
    mov rbp, rsp
    sub rsp, 20
    mov dword [rbp-20], 'aaaa'
    mov dword [rbp-16], 'bbbb'
    mov byte [rbp-12], 0

    ; rax = output buffer
    mov rax, assert_input_buf
    ; rdi = source buffer "aaaabbbb\0"
    lea rdi, [rbp-20]
    ; rsi = max len shorter than source string
    mov rsi, 2
    call str_copy

    mov rsp, rbp
    pop rbp

    ; expect 2 bytes to be copied
    cmp rax, 2
    assert_is_true __LINE__

.test_str_copy_aaaabbbb_max_len_2_compare_result:
    assert_expect_buf_reset
    assert_expect_buf_push_byte 'a'
    assert_expect_buf_push_byte 'a'
    assert_expect_buf_push_byte 0x00

    mov rax, assert_input_buf
    lea rdi, assert_expect_buf
    call str_comp
    assert_is_true __LINE__

    exit 0

