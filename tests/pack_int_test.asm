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

test_pack_int_single_positive_offset_1:
    mov rax, 9
    mov rdi, assert_input_buf
    call pack_int
    mov r9, assert_input_buf
    sub rax, r9

    ; expect 1 byte pointer offset returned
    ; when packing number 9
    assert_eax_eq 1

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

test_pack_int_double_positive_offset_2:
    mov rax, 65
    mov rdi, assert_input_buf
    call pack_int
    mov r9, assert_input_buf
    sub rax, r9

    ; expect 2 byte pointer offset returned
    ; when packing number 65
    assert_eax_eq 2

test_pack_int_single_negative:
    mov rax, -1
    mov rdi, assert_input_buf
    call pack_int
    mov al, [assert_input_buf]
    assert_al_eq 0x40

    mov rax, -2
    mov rdi, assert_input_buf
    call pack_int
    mov al, [assert_input_buf]
    assert_al_eq 0x41

test_pack_int_double_negative:
    mov rax, -65
    mov rdi, assert_input_buf
    call pack_int
    mov eax, [assert_input_buf]
    assert_eax_eq 0x01_C0; 0xC0 0x01 is the sane people endianness

    mov rax, -66
    mov rdi, assert_input_buf
    call pack_int
    mov eax, [assert_input_buf]
    assert_eax_eq 0x01_C1 ; 0xC1 0x01 is the sane people endianness

    exit 0

