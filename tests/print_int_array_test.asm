%include "tests/assert.asm"

_start:
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
    exit 0
