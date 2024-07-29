global _start:

section .data
    %include "src/data/posix.asm"
    %include "src/data/syscalls.asm"
    %include "src/data/logger.asm"
    %include "src/data/hex.asm"
    %include "src/data/teeworlds.asm"
    %include "src/data/teeworlds_strings.asm"

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
    %include "src/bss/teeworlds.asm"
    assert_expect_buf resb 2048
    assert_actual_buf resb 2048
    assert_input_buf resb 2048
    assert_input_buf_index resb 4
section .text

%include "src/macros.asm"
%include "src/syscalls.asm"
%include "src/logger.asm"
%include "src/hex.asm"
%include "src/system.asm"

%macro assert_input_buf_reset 0
    mov dword [assert_input_buf_index], 0
%endmacro

; TODO: make this variadic so one can do `push_bytes 0xff, 0xdd, 0xaa`
%macro assert_input_buf_push_byte 1
    push rax
    mov rax, %1

    push rcx
    push rdx

    mov dword edx, [assert_input_buf_index]

    lea rcx, [assert_input_buf + edx]
    mov byte [rcx], al

    mov rcx, [assert_input_buf_index]
    inc rcx
    mov [assert_input_buf_index], rcx

    pop rdx
    pop rcx

    pop rax
%endmacro

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
    mov dword [assert_expect_buf], %1
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

%macro assert_al_eq 1
    cmp al, %1
    jz %%assert_ok
    print s_assert_error

    push rax
    print s_assert_expected
    mov byte [assert_expect_buf], %1
    mov rax, assert_expect_buf
    mov rdi, 1
    call print_hexdump
    call print_newline
    pop rax

    print s_assert_actual
    mov [assert_actual_buf], al
    mov rax, assert_actual_buf
    mov rdi, 1
    call print_hexdump
    call print_newline

    exit 1
    %%assert_ok:
    print s_assert_ok
%endmacro

assert_entry:

