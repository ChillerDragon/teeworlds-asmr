global _start:

section .data
    %include "src/data/posix.asm"
    %include "src/data/syscalls.asm"
    %include "src/data/logger.asm"
    %include "src/data/hex.asm"
    %include "src/data/teeworlds.asm"
    %include "src/data/teeworlds_strings.asm"
    %include "src/data/udp.asm"
    %include "src/data/huffman.asm"

    s_assertion_failed_in db 0x0a, "[assert] assertion failed in "
    l_s_assertion_failed_in equ $ - s_assertion_failed_in
    s_assert_ok db "[assert] OK", 0x0a
    l_s_assert_ok equ $ - s_assert_ok
    s_assert_error db "[assert] assertion error: rax does not match the expected value", 0x0a
    l_s_assert_error equ $ - s_assert_error
    s_assert_expected db "[assert]   expected: "
    l_s_assert_expected equ $ - s_assert_expected
    s_assert_actual db "[assert]     actual: "
    l_s_assert_actual equ $ - s_assert_actual
    s_assert_true_error db "[assert] assertion error: assert_is_true failed (expected cmp to match and zero flag to be set)", 0x0a
    l_s_assert_true_error  equ $ - s_assert_true_error
    s_assert_false_error db "[assert] assertion error: assert_is_false failed (expected cmp to not match and zero flag to be unset)", 0x0a
    l_s_assert_false_error  equ $ - s_assert_false_error

section .bss
    %include "src/bss/hex.asm"
    %include "src/bss/teeworlds.asm"
    %include "src/bss/buffers.asm"
    %include "src/bss/huffman.asm"

    ; holds the path to the current source code file
    ; of the test as a null terminated C string
    ; will be used in backtraces
    assert_test_filename resb 2048

    ; used in assert eq macros
    ; but can also be used as argument to user code
    assert_expect_buf resb 2048
    assert_expect_buf_index resb 4

    assert_actual_buf resb 2048

    assert_input_buf resb 2048
    assert_input_buf_index resb 4

    assert_counter resb 4
section .text

%include "src/macros.asm"
%include "src/syscalls.asm"
%include "src/printf.asm"
%include "src/logger.asm"
%include "src/hex.asm"
%include "src/check_bounds.asm"
%include "src/udp.asm"
%include "src/packer.asm"
%include "src/packet.asm"
%include "src/chunk_unpacker.asm"
%include "src/chunk_packer.asm"
%include "src/send_control.asm"
%include "src/send_system.asm"
%include "src/receive_control.asm"
%include "src/system.asm"
%include "src/packet_header.asm"
%include "src/on_packet.asm"
%include "src/on_system.asm"
%include "src/on_game.asm"
%include "src/packet_packer.asm"
%include "src/pack_int.asm"
%include "src/huffman/huffman.asm"

%macro init_test 1
    ; init_test [__FILE__]
    str_to_stack %1
    mov rdi, rax
    mov rax, assert_test_filename
    mov rsi, 2048
    call str_copy
    mov rsp, rbp
%endmacro

_assert_trace:
    ; _assert_trace [rax]
    ;  rax = line number
    ;
    ; prints
    ;
    ; [assert] assertion failed in file/path/to/test.asm:79
    ;
    print_label s_assertion_failed_in
    print_c_str assert_test_filename
    call print_colon
    call println_uint32
    ret

%macro assert_trace 1
    ; assert_trace [line number]
    push rax
    mov rax, %1
    call _assert_trace
    pop rax
%endmacro

assert_ok:
    push_registers

    ; verbose
    ; print_label s_assert_ok

    ; non verbose
    printn char_dot, 1

    pop_registers
    ret

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

%macro assert_expect_buf_reset 0
    mov dword [assert_expect_buf_index], 0
%endmacro

%macro assert_expect_buf_push_byte 1
    push rax
    mov rax, %1

    push rcx
    push rdx

    mov dword edx, [assert_expect_buf_index]

    lea rcx, [assert_expect_buf + edx]
    mov byte [rcx], al

    mov rcx, [assert_expect_buf_index]
    inc rcx
    mov [assert_expect_buf_index], rcx

    pop rdx
    pop rcx

    pop rax
%endmacro

; set rax or eax does not really matter
; then compare it against a value up to 4 bytes
; example:
;
;  mov rax, 0xAABB
;  assert_eax_eq 0xAABB, __LINE__
;
;  mox eax, 0
;  assert_eax_eq 0, __LINE__
;
%macro assert_eax_eq 2
    ; assert_eax_eq [value] [__LINE__]
    cmp eax, %1
    je %%assert_ok

    assert_trace %2
    print_label s_assert_error

    push rax
    print_label s_assert_expected
    mov dword [assert_expect_buf], %1
    mov rax, assert_expect_buf
    mov rdi, 4
    call print_hexdump
    call print_newline
    pop rax

    print_label s_assert_actual
    mov [assert_actual_buf], rax
    mov rax, assert_actual_buf
    mov rdi, 4
    call print_hexdump
    call print_newline

    exit 1
    %%assert_ok:
    call assert_ok
%endmacro

; assert_is_true
; checks if the equal or zero flag is set
; do a `cmp` and then call assert_is_true
; if they match the assert will pass
%macro assert_is_true 1
    ; assert_is_true [__LINE__]
    je %%assert_ok

    assert_trace %1
    print_label s_assert_true_error
    exit 1

    %%assert_ok:
    call assert_ok
%endmacro

; assert_is_false
; checks if the equal or zero flag is set
; do a `cmp` and then call assert_is_true
; if they match the assert will pass
%macro assert_is_false 1
    ; assert_is_false [__LINE__]
    jne %%assert_ok

    assert_trace %1
    print_label s_assert_false_error
    exit 1

    %%assert_ok:
    call assert_ok
%endmacro

%macro assert_al_eq 2
    ; assert_al_eq [value] [__LINE__]
    cmp al, %1
    je %%assert_ok
    assert_trace %2
    print_label s_assert_error

    push rax
    print_label s_assert_expected
    mov byte [assert_expect_buf], %1
    mov rax, assert_expect_buf
    mov rdi, 1
    call print_hexdump
    call print_newline
    pop rax

    print_label s_assert_actual
    mov [assert_actual_buf], al
    mov rax, assert_actual_buf
    mov rdi, 1
    call print_hexdump
    call print_newline

    exit 1
    %%assert_ok:
    call assert_ok
%endmacro

%macro assert_str_eq 2
    ; assert_str_eq [expected] [actual]
    mov rbp, rsp
    sub rsp, 16
    mov qword [rbp-16], %1
    mov qword [rbp-8], %2

    mov rax, [rbp-16]
    mov rdi, [rbp-8]
    call str_comp
    je %%assert_ok

    print_label s_assert_error
    print "  expected: '"
    print_c_str [rbp-16]
    puts "'"
    print "    actual: '"
    print_c_str [rbp-8]
    puts "'"

    %%assert_ok:
    call assert_ok

    mov rsp, rbp
%endmacro

assert_entry:

