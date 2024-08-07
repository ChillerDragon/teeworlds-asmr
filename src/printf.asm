%macro printdf 2
    ; printdf [format str] [int]
    push_registers

    ; TODO: do not segfault when we write out of those bounds
    %define MAX_PRINTF_LEN 2048

    ; rax = is null terminated format str
    str_to_stack %1

    sub rsp, MAX_PRINTF_LEN
    ; r10 is index in final output string
    mov r10, 0
    ; r11 is pointer to start of output string
    lea r11, [rbp-MAX_PRINTF_LEN]

    mov rcx, 0
%%printf_fmt_char_loop:
    mov r9b, byte [rax+rcx]
    inc rcx

    ; copy one letter from the format string
    ; to the output buffer
    mov byte [r11+r10], r9b
    inc r10

    cmp r9b, '%'
    jne %%printf_fmt_char_loop_check_repeat

%%printf_fmt_char_loop_got_percentage:
    mov r9b, byte [rax+rcx]
    cmp r9b, 'd'
    jne %%printf_fmt_char_loop_check_repeat

%%printf_fmt_char_loop_got_fmt_d:

    ; overwrite the %d
    dec r10
    inc rcx

    push rax
    push rdi

    mov rax, %2
    lea rdi, [r11+r10]
    call int32_to_str
    add r10, rax

    pop rdi
    pop rax
%%printf_fmt_char_loop_check_repeat:

    cmp r9b, 0
    jne %%printf_fmt_char_loop

    ; print output buffer
    printn r11, r10

    ; frees stack string
    ; and copy buffer
    mov rsp, rbp

    ; TODO: support \n escape sequence
    call print_newline

    pop_registers
%endmacro

