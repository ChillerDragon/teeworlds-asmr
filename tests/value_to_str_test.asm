%include "tests/assert.asm"

_start:
test_int_to_str:
    mov rax, 10
    mov rdi, assert_actual_buf
    call int32_to_str

    str_to_stack "10"
    assert_str_eq rax, rdi
test_negative_int_to_str0:
    mov rax, -10
    mov rdi, assert_actual_buf
    call int32_to_str

    str_to_stack "-10"
    assert_str_eq rax, rdi
test_ptr_to_str:
    mov rax, 0x1122334455667788
    mov rdi, assert_actual_buf
    call ptr_to_str

    str_to_stack "0x1122334455667788"
    assert_str_eq rax, rdi
    exit 0

