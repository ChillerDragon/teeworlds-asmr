on_system_message:
    ; on_system_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    push_registers

    ; message id
    mov r9, rax

    ; message payload
    mov r10, rdi

    ; print_label s_got_system_msg_with_id
    ; call println_uint32

    ; payload to rax
    mov rax, r10

    ; if 0.6 or 0.7
    push r11
    mov r11b, [connection_version]
    cmp r11b, 7
    pop r11
    je .version7

    .version6:
    push rax
    mov eax, [chunk_header_size]
    printf "[debug] got sys msg with size %d\n", rax
    pop rax
    ; call print_udp

    cmp r9d, MSG6_SYSTEM_NULL
    je on_system_msg6_null
    cmp r9d, MSG6_SYSTEM_MAP_CHANGE
    je on_system_msg6_map_change

    print_label s_unknown_system_msg
    mov rax, r9
    call println_uint32
    exit 1

    .version7:
    cmp r9d, MSG_SYSTEM_NULL
    je on_system_msg_null
    cmp r9d, MSG_SYSTEM_MAP_CHANGE
    je on_system_msg_map_change
    cmp r9d, MSG_SYSTEM_MAP_DATA
    je on_system_msg_map_data
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
    cmp r9d, MSG_SYSTEM_INPUTTIMING
    je on_system_msg_inputtiming
    cmp r9d, MSG_SYSTEM_RCON_AUTH_ON
    je on_system_msg_rcon_auth_on
    cmp r9d, MSG_SYSTEM_RCON_AUTH_OFF
    je on_system_msg_rcon_auth_off
    cmp r9d, MSG_SYSTEM_RCON_LINE
    je on_system_msg_rcon_line
    cmp r9d, MSG_SYSTEM_RCON_CMD_ADD
    je on_system_msg_rcon_cmd_add
    cmp r9d, MSG_SYSTEM_RCON_CMD_REM
    je on_system_msg_rcon_cmd_rem
    cmp r9d, MSG_SYSTEM_PING_REPLY
    je on_system_msg_ping_reply
    cmp r9d, MSG_SYSTEM_MAPLIST_ENTRY_ADD
    je on_system_msg_maplist_entry_add
    cmp r9d, MSG_SYSTEM_MAPLIST_ENTRY_REM
    je on_system_msg_maplist_entry_rem

    print_label s_unknown_system_msg
    mov rax, r9
    call println_uint32
    exit 1

on_system_message_end:
    pop_registers
    ret

on_system_msg_null:
    ; on_system_msg_null [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_map_change:
    ; on_system_msg_map_change [rax]
    ;  rax = message payload
    mov rbp, rsp
    sub rsp, 2048 ; buffer for chat message

    ; index into msg stack buffer
    mov r9, -2048

    lea rax, [rbp+r9]
    mov rdi, c_map_change
    call str_copy
    add r9, rax

    call get_string
    mov rdi, rax ; arg for str_copy
    lea rax, [rbp+r9]
    call str_copy

    mov rax, c_client
    lea rdi, [rbp-2048]
    call log_info

    mov rsp, rbp

    call send_ready

    jmp on_system_message_end

on_system_msg_map_data:
    ; on_system_msg_map_data [rax]
    ;  rax = message payload
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

    ; game tick
    call get_int
    mov dword [ack_game_tick], eax

    ; delta tick
    call get_int

    ; num parts
    call get_int

    ; part
    call get_int

    ; crc
    call get_int

    ; part size
    call get_int
    mov rdi, rax

    ; data
    call get_int

    ; there is no snapshot storage yet
    ; so we just claim there was no payload (SNAPEMPTY)
    ; when we get a partial snap

    ; data = nulltpr
    mov rax, 0
    ; data size = 0
    mov rdi, 0
    call on_snap

    jmp on_system_message_end

on_system_msg_snapempty:
    ; on_system_msg_snapempty [rax]
    ;  rax = message payload

    call get_int
    mov dword [ack_game_tick], eax

    ; data = nulltpr
    mov rax, 0
    ; data size = 0
    mov rdi, 0
    call on_snap

    jmp on_system_message_end

on_system_msg_snapsingle:
    ; on_system_msg_snapsingle [rax]
    ;  rax = message payload

    ; game tick
    call get_int
    mov dword [ack_game_tick], eax

    ; delta tick
    call get_int

    ; crc
    call get_int

    ; part size
    call get_int
    mov rdi, rax

    ; data
    call get_int

    ; rax = data
    ; rdi = part size
    call on_snap

    jmp on_system_message_end

on_system_msg_inputtiming:
    ; on_system_msg_inputtiming [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_rcon_auth_on:
    ; on_system_msg_rcon_auth_on [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_rcon_auth_off:
    ; on_system_msg_rcon_auth_off [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_rcon_line:
    ; on_system_msg_rcon_auth_off [rax]
    ;  rax = message payload

    print_label s_rcon

    call get_string
    print_c_str rax
    call print_newline

    jmp on_system_message_end

on_system_msg_rcon_cmd_add:
    ; on_system_msg_rcon_cmd_add [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_rcon_cmd_rem:
    ; on_system_msg_rcon_cmd_rem [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_ping_reply:
    ; on_system_msg_ping_reply [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_maplist_entry_add:
    ; on_system_msg_maplist_entry_add [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_maplist_entry_rem:
    ; on_system_msg_maplist_entry_add [rax]
    ;  rax = message payload
    jmp on_system_message_end

