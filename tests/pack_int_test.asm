%include "tests/assert.asm"

_start:
test_pack_int_single_positive:
    mov rax, 9
    mov rdi, assert_input_buf
    call pack_int
    mov al, [assert_input_buf]
    assert_al_eq 9

    mov rax, 2
    mov rdi, assert_input_buf
    call pack_int
    mov al, [assert_input_buf]
    assert_al_eq 2

    mov rax, 63
    mov rdi, assert_input_buf
    call pack_int
    mov al, [assert_input_buf]
    assert_al_eq 63

test_pack_int_double_positive:
    mov rax, 64
    mov rdi, assert_input_buf
    call pack_int
    mov eax, [assert_input_buf]
    assert_eax_eq 0x01_80 ; 0x80 0x81 is the sane people endianness

    mov rax, 65
    mov rdi, assert_input_buf
    call pack_int
    mov eax, [assert_input_buf]
    assert_eax_eq 0x01_81 ; 0x81 0x01 is the sane people endianness

    exit 0

