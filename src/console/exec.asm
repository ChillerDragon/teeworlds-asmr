_console_match_cmd:
    ; _console_match_cmd [rax] [rdi]
    ;  rax = fixed command name
    ;  rdi = user input to check
    ; sets `je` flag if they match
    push_registers
    call str_comp
    pop_registers
    ret

%macro match_cmd 1
    mov rdi, r8
    mov rax, _con_str_%1
    call _console_match_cmd
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
    match_cmd connect
    match_cmd logfile

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
    ; supports semicolon separated commands with a few caveats:
    ;
    ;  1. It requires spaces after commands without args.
    ;     "ping;ping" does not work only "ping ;ping"
    ;
    ;  2. Because the code uses recursion the order of commands is reversed.
    ;     "foo ;bar" will execute "bar" then "foo"
    ;
    ; example:
    ;
    ;  str_to_stack "ping unused_argument"
    ;  call exec_line
    ;  mov rsp, rbp
    ;
    push_registers
    mov rbp, rsp

    ; allocate two 512 byte buffers on the stack
    ; the first is the command and the second its args
    sub rsp, 512*2

    ; cmd = ""
    mov byte [rbp-1024], 0x00

    ; args = ""
    mov byte [rbp-512], 0x00

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
    lea rax, [rbp-1024] ; cmd buffer
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
    lea rax, [rbp-512]
    call mem_copy

    ; find ; in args and split command
    lea rax, [rbp-512] ; args
    mov rdi, ';'
    call str_find_char
    cmp rax, -1
    jg .got_semicolon
    jmp .got_no_semicolons
    .got_semicolon:

    ; replace semicolon with null terminator
    lea rax, [rbp-512+rax]
    mov byte [rax], 0x00

    ; recurse to parse next command
    ; by skipping the null byte and calling self
    inc rax
    call exec_line

    .got_no_semicolons:

    lea rax, [rbp-1024] ; command
    lea rdi, [rbp-512] ; args
    call _console_callback_matcher

    mov rsp, rbp
    pop_registers
    ret


test_console:
    ; str_to_stack "connect 127.0.0.1:8303"
    ; call exec_line
    ; mov rsp, rbp


    str_to_stack "uwu;xxx;ping"
    ; str_to_stack "ping"
    ; str_to_stack "ping"
    call exec_line
    mov rsp, rbp

    ret

