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

_com_logfile:
    ; rax = args

    ; logfile
    mov r9, rax

    mov rax, logger_logfile_path
    mov rdi, r9
    mov rsi, 512
    call str_copy

    print "loggin to "
    print_c_str logger_logfile_path
    puts " ..."

    mov rax, logger_logfile_path
    mov rdi, O_APPEND
    call fopen

    ; rax is set by open(2) and should be a valid (positive)
    ; file descriptor
    cmp rax, 0
    jg .fopen_ok

    printf "error: logger failed and got fd=%d", rax
    exit 1

    .fopen_ok:
    call close

    jmp _console_callback_matcher_end

