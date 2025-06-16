on_game_message:
    ; on_game_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    push_registers

    ; message id
    mov r9, rax

    ; message payload
    mov r10, rdi

    ; print_label s_got_game_msg_with_id
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
    printf "[debug] got game msg with size %d\n", rax
    pop rax
    ; call print_udp

    cmp r9d, MSG6_GAME_NULL
    je on_game_msg6_null

    print_label s_unknown_game_msg
    mov rax, r9
    call println_uint32
    exit 1

    .version7:
    cmp r9d, MSG_GAME_NULL
    je on_game_msg_null
    cmp r9d, MSG_GAME_SV_MOTD
    je on_game_msg_sv_motd
    cmp r9d, MSG_GAME_SV_BROADCAST
    je on_game_msg_sv_broadcast
    cmp r9d, MSG_GAME_SV_CHAT
    je on_game_msg_sv_chat
    cmp r9d, MSG_GAME_SV_TEAM
    je on_game_msg_sv_team
    cmp r9d, MSG_GAME_SV_KILLMSG
    je on_game_msg_sv_killmsg
    cmp r9d, MSG_GAME_SV_TUNEPARAMS
    je on_game_msg_sv_tuneparams
    cmp r9d, MSG_GAME_SV_READYTOENTER
    je on_game_msg_sv_readytoenter
    cmp r9d, MSG_GAME_SV_WEAPONPICKUP
    je on_game_msg_sv_weaponpickup
    cmp r9d, MSG_GAME_SV_EMOTICON
    je on_game_msg_sv_emoticon
    cmp r9d, MSG_GAME_SV_VOTECLEAROPTIONS
    je on_game_msg_sv_voteclearoptions
    cmp r9d, MSG_GAME_SV_VOTECLEAROPTIONS
    je on_game_sv_voteclearoptions
    cmp r9d, MSG_GAME_SV_VOTEOPTIONLISTADD
    je on_game_sv_voteoptionlistadd
    cmp r9d, MSG_GAME_SV_VOTEOPTIONADD
    je on_game_sv_voteoptionadd
    cmp r9d, MSG_GAME_SV_VOTEOPTIONREMOVE
    je on_game_sv_voteoptionremove
    cmp r9d, MSG_GAME_SV_VOTESET
    je on_game_sv_voteset
    cmp r9d, MSG_GAME_SV_VOTESTATUS
    je on_game_sv_votestatus
    cmp r9d, MSG_GAME_SV_SERVERSETTINGS
    je on_game_msg_sv_serversettings
    cmp r9d, MSG_GAME_SV_CLIENTINFO
    je on_game_msg_sv_clientinfo
    cmp r9d, MSG_GAME_SV_GAMEINFO
    je on_game_msg_sv_gameinfo
    cmp r9d, MSG_GAME_SV_CLIENTDROP
    je on_game_msg_sv_clientdrop
    cmp r9d, MSG_GAME_SV_GAMEMSG
    je on_game_msg_sv_gamemsg
    cmp r9d, MSG_GAME_SV_SKINCHANGE
    je on_game_msg_sv_skinchange
    cmp r9d, MSG_GAME_SV_RACEFINISH
    je on_game_msg_sv_racefinish
    cmp r9d, MSG_GAME_SV_CHECKPOINT
    je on_game_msg_sv_checkpoint
    cmp r9d, MSG_GAME_SV_COMMANDINFO
    je on_game_msg_sv_commandinfo
    cmp r9d, MSG_GAME_SV_COMMANDINFOREMOVE
    je on_game_msg_sv_commandinforemove

    print_label s_unknown_game_msg
    mov rax, r9
    call println_uint32
    exit 1
on_game_message_end:
    pop_registers
    ret


on_game_msg_null:
    ; on_game_msg_null [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_motd:
    ; on_game_msg_sv_motd [rax]
    ;  rax = message payload
    call get_string
    cmp byte [rax], 0x00
    mov r10, rax ; motd
    je on_game_message_end

    mov rbp, rsp
    sub rsp, 2048

    ; offset into stack buffer
    mov r9, -2048

    lea rax, [rbp+r9]
    mov rdi, c_motd
    call str_copy
    add r9, rax

    lea rax, [rbp+r9]
    mov rdi, r10 ; motd from the get_string
    call str_copy

    mov rax, c_motd
    lea rdi, [rbp-2048]
    call log_info

    mov rsp, rbp

    jmp on_game_message_end

on_game_msg_sv_broadcast:
    ; on_game_msg_sv_broadcast [rax]
    ;  rax = message payload
    call get_string
    mov rdi, rax
    mov rax, c_broadcast
    call log_info
    jmp on_game_message_end

on_game_msg_sv_chat:
    ; on_game_msg_sv_chat [rax]
    ;  rax = message payload
    call on_chat
    jmp on_game_message_end

on_game_msg_sv_team:
    ; on_game_msg_sv_tea [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_killmsg:
    ; on_game_msg_sv_killmsg [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_tuneparams:
    ; on_game_msg_sv_tuneparams [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_readytoenter:
    ; on_game_msg_sv_readytoenter [rax]
    ;  rax = message payload

    call send_msg_enter_game

    jmp on_game_message_end

on_game_msg_sv_weaponpickup:
    ; on_game_msg_sv_weaponpickup [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_emoticon:
    ; on_game_msg_sv_emoticon [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_voteclearoptions:
    ; on_game_msg_sv_voteclearoptions [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_sv_voteclearoptions:
    ; on_game_sv_voteclearoptions [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_sv_voteoptionlistadd:
    ; on_game_sv_voteoptionlistadd [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_sv_voteoptionadd:
    ; on_game_sv_voteoptionadd [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_sv_voteoptionremove:
    ; on_game_sv_voteoptionremove [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_sv_voteset:
    ; on_game_sv_voteset [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_sv_votestatus:
    ; on_game_sv_votestatus [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_serversettings:
    ; on_game_msg_sv_serversettings [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_clientinfo:
    ; on_game_msg_sv_clientinfo [rax]
    ;  rax = message payload

    ; client id
    call get_int
    mov rcx, rax

    ; local
    call get_int
    cmp rax, 1
    jne .skip_local
    .local_client_info:
    mov dword [local_client_id], ecx
    .skip_local:

    ; client id
    mov rax, rcx
    call set_client_info

    jmp on_game_message_end

on_game_msg_sv_clientdrop:
    ; on_game_msg_sv_clientdrop [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_gamemsg:
    ; on_game_msg_sv_gamemsg [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_gameinfo:
    ; on_game_msg_sv_gameinfo [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_skinchange:
    ; on_game_msg_sv_skinchange [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_racefinish:
    ; on_game_msg_sv_racefinish [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_checkpoint:
    ; on_game_msg_sv_checkpoint [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_commandinfo:
    ; on_game_msg_sv_commandinfo [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_commandinforemove:
    ; on_game_msg_sv_commandinforemove [rax]
    ;  rax = message payload
    jmp on_game_message_end

