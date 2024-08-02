on_system_message:
    ; on_system_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    push_registers

    ; message id
    mov r9, rax

    ; message payload
    mov r10, rdi

    print s_got_system_msg_with_id
    call println_uint32

    ; payload to rax
    mov rax, r10

    cmp r9d, MSG_SYSTEM_MAP_CHANGE
    je on_system_msg_map_change

    print s_unknown_system_msg
    mov rax, r9
    call println_uint32
    exit 1

on_system_message_end:
    pop_registers
    ret

on_system_msg_map_change:
    ; on_system_msg_map_change [rax]
    ;  rax = message payload
    print s_map_change
    print_c_str rax
    call print_newline

    call send_ready

    jmp on_system_message_end
