%include "tests/assert.asm"

_start:
test_1_byte_int_array:
    ; no asserts just checking if we crash or not

    ; stack allocated array of 3 elements
    ; every element is a one byte integer
    mov rbp, rsp
    sub rsp, 3
    mov byte [rbp-3], 0x01
    mov byte [rbp-2], 0x02
    mov byte [rbp-1], 0x02

    ; rax=buf 1=element size 3=array size
    lea rax, [rbp-3]

    print_int_array rax, 1, 3

    mov rsp, rbp

test_2_byte_int_array:
    call print_space

    ; no asserts just checking if we crash or not

    ; stack allocated array of 3 elements
    ; every element is a one byte integer
    mov rbp, rsp
    sub rsp, 6
    mov word [rbp-6], 666
    mov word [rbp-4], 777
    mov word [rbp-2], 888

    ; rax=buf 2=element size 3=array size
    lea rax, [rbp-6]

    print_int_array rax, 2, 3

    mov rsp, rbp

test_4_byte_int_array:
    call print_space

    ; no asserts just checking if we crash or not

    ; stack allocated array of 3 elements
    ; every element is a one byte integer
    mov rbp, rsp
    sub rsp, 12
    mov dword [rbp-12], 0xaabbccdd
    mov dword [rbp-8], 0xaabbccdf
    mov dword [rbp-4], 0xaabbccdd

    ; rax=buf 4=element size 3=array size
    lea rax, [rbp-12]

    print_int_array rax, 4, 3

    mov rsp, rbp

    exit 0

