%macro match_cmd 1
    mov rdi, r8
    mov rax, _con_str_%1
    call str_comp
    mov rax, r10
    je _com_%1
%endmacro

_console_callback_matcher:
    ; _console_callback_matcher [rax] [rdi]
    ;  rax = command
    ;  rdi = arguments

    ; r8 command
    mov r8, rax

    ; r10 args
    mov r10, rdi

    print_label s_console_got_command
    print_c_str r8
    print_label s_console_with_args
    print_c_str r10
    call print_single_quote
    call print_newline

    match_cmd quit
    match_cmd ping

    _console_callback_matcher_unknown_command:
    print_label s_console_unknown_command
    print_c_str r8
    call print_single_quote
    call print_newline

    _console_callback_matcher_end:
    ret

exec_line:
    ; exec_line [rax]
    ;  rax = command str with arguments
    ; does only support one command with space separated args at a time
    ;
    ; example:
    ;
    ;  str_to_stack "ping unused_argument"
    ;  call exec_line
    ;  mov rsp, rbp
    ;
    push_registers

    ; mem_copy [rax] [rdi] [rsi]
    ;   rax = destination buffer pointer
    ;   rdi = source buffer pointer
    ;   rsi = size

    ; *******
    ; command
    ; *******

    ; rdi = source buffer pointer
    mov rdi, rax

    ; rsi = size
    push rax
    call str_get_word_boundary_offset
    mov rsi, rax
    pop rax

    ; rax = destination buffer pointer
    push rax
    mov rax, generic_buffer_128
    call mem_copy
    pop rax

    ; *******
    ; args
    ; *******

    ; rsi is still word boundary
    ; so we skip that with + 1
    ;   rdi = source buffer pointer
    lea rdi, [rax+rsi]
    cmp byte [rdi], 0x00
    je .empty_arg
    ; if there are no args we leave it at the null byte
    ; if there are args we assume the separator is one space
    ; so we skip the space to have the args start with an letter
    inc rdi
    .empty_arg:
    ;   rsi = size is max buffer size we depend on c string termination here
    mov rsi, 512

    ;   rax = destination buffer pointer
    mov rax, generic_buffer_512
    call mem_copy

    mov rax, generic_buffer_128 ; command
    mov rdi, generic_buffer_512 ; args
    call _console_callback_matcher

    pop_registers
    ret


test_console:
    str_to_stack "quip"
    call exec_line
    mov rsp, rbp

    str_to_stack "ping args"
    call exec_line
    mov rsp, rbp

    str_to_stack "quit foo"
    call exec_line
    mov rsp, rbp

    ret

