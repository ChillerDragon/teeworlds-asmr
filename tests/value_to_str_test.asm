%include "tests/assert.asm"

_start:
    init_test __FILE__

    ; print_label s_assert_expected
    ; mov rax, rsp
    ; mov rdi, 8
    ; call print_hexdump
    ; call print_newline


test_int_to_str:
    mov rax, 10
    mov rdi, assert_actual_buf
    call int32_to_str

    str_to_stack "10"
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp
test_negative_int_to_str0:
    mov rax, -10
    mov rdi, assert_actual_buf
    call int32_to_str

    str_to_stack "-10"
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp
test_ptr_to_str:
    mov rax, 0x1122334455667788
    mov rdi, assert_actual_buf
    call ptr_to_str

    str_to_stack "0x1122334455667788"
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp

    ; TODO: this fails
    exit 0
    ; end_test __LINE__

