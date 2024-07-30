%include "tests/assert.asm"

_start:
    ; call to be tested function
    mov rax, 1
    mov rdi, assert_input_buf
    call pack_int

    mov al, [assert_input_buf]
    assert_al_eq 0x01
    exit 0

