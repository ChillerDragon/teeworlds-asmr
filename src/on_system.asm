on_system_message:
    ; on_system_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    push_registers

    ; message id
    mov r9, rax

    ; message payload
    mov r10, rdi

    print_label s_got_system_msg_with_id
    call println_uint32

    ; payload to rax
    mov rax, r10

    cmp r9d, MSG_SYSTEM_MAP_CHANGE
    je on_system_msg_map_change
    cmp r9d, MSG_SYSTEM_SERVERINFO
    je on_system_msg_serverinfo
    cmp r9d, MSG_SYSTEM_CON_READY
    je on_system_msg_con_ready
    cmp r9d, MSG_SYSTEM_SNAP
    je on_system_msg_snap
    cmp r9d, MSG_SYSTEM_SNAPEMPTY
    je on_system_msg_snapempty
    cmp r9d, MSG_SYSTEM_SNAPSINGLE
    je on_system_msg_snapsingle

    print_label s_unknown_system_msg
    mov rax, r9
    call println_uint32
    exit 1

on_system_message_end:
    pop_registers
    ret

on_system_msg_map_change:
    ; on_system_msg_map_change [rax]
    ;  rax = message payload
    print_label s_map_change
    print_c_str rax
    call print_newline

    call send_ready

    jmp on_system_message_end

on_system_msg_serverinfo:
    ; on_system_msg_serverinfo [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_con_ready:
    ; on_system_msg_con_ready [rax]
    ;  rax = message payload

    call send_start_info

    jmp on_system_message_end

on_system_msg_snap:
    ; on_system_msg_snap [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_snapempty:
    ; on_system_msg_snapempty [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_snapsingle:
    ; on_system_msg_snapsingle [rax]
    ;  rax = message payload
    jmp on_system_message_end

