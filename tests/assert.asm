global _start:

section .data
    %include "src/data/posix.asm"
    %include "src/data/syscalls.asm"
    %include "src/data/logger.asm"
    %include "src/data/hex.asm"

    s_assert_ok db "[assert] OK", 0x0a
    l_s_assert_ok equ $ - s_assert_ok
    s_assert_error db "[assert] assertion error: rax does not match the expected value", 0x0a
    l_s_assert_error equ $ - s_assert_error
    s_assert_expected db "[assert]   expected: "
    l_s_assert_expected equ $ - s_assert_expected
    s_assert_actual db "[assert]     actual: "
    l_s_assert_actual equ $ - s_assert_actual

section .bss
    %include "src/bss/hex.asm"
    assert_expect_buf resb 2048
    assert_actual_buf resb 2048
section .text

%include "src/macros.asm"
%include "src/syscalls.asm"
%include "src/logger.asm"
%include "src/hex.asm"

; set rax or eax does not really matter
; then compare it against a value up to 4 bytes
; example:
;
;  mov rax, 0xAABB
;  assert_eax_eq 0xAABB
;
;  mox eax, 0
;  assert_eax_eq 0
;
%macro assert_eax_eq 1
    cmp eax, %1
    jz %%assert_ok
    print s_assert_error

    push rax
    print s_assert_expected
    mov qword [assert_expect_buf], %1
    mov rax, assert_expect_buf
    mov rdi, 4
    call print_hexdump
    call print_newline
    pop rax

    print s_assert_actual
    mov [assert_actual_buf], rax
    mov rax, assert_actual_buf
    mov rdi, 4
    call print_hexdump
    call print_newline

    exit 1
    %%assert_ok:
    print s_assert_ok
%endmacro

_start:

