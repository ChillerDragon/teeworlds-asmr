on_chat:
    ; on_chat [rax]
    push_registers

    ; mode
    call get_int

    ; client id
    call get_int
    mov r8, rax

    ; target id
    call get_int
    mov r9, rax

    ; message
    call get_string
    mov r10, rax

    print_label s_chat

    ; get author name
    mov rbx, r8
    imul rbx, TW_CLIENT_SIZE
    lea rsi, [tw_clients + rbx + TW_CLIENT_NAME_OFFSET]
    print_c_str rsi

    call print_colon
    call print_space

    ; print message
    print_c_str r10

    call print_newline

    pop_registers
    ret

