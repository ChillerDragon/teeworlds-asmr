_com_quit:
    ; rax = args
    exit 0
    jmp _console_callback_matcher_end

_com_ping:
    ; rax = args
    print_label s_console_pong
    call print_newline
    jmp _console_callback_matcher_end

_com_connect:
    ; rax = args

    ; rax is the arg that we pass to str_to_sockaddr
    mov rdi, sockaddr_server
    call str_to_sockaddr

    call connect

    jmp _console_callback_matcher_end

