on_game_message:
    ; on_game_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    push_registers

    ; message id
    mov r9, rax

    ; message payload
    mov r10, rdi

    print_label s_got_game_msg_with_id
    call println_uint32

    ; payload to rax
    mov rax, r10

    cmp r9d, MSG_GAME_SV_MOTD
    je on_game_msg_sv_motd
    cmp r9d, MSG_GAME_SV_TUNEPARAMS
    je on_game_msg_sv_tuneparams
    cmp r9d, MSG_GAME_SV_READYTOENTER
    je on_game_msg_sv_readytoenter
    cmp r9d, MSG_GAME_SV_VOTECLEAROPTIONS
    je on_game_msg_sv_voteclearoptions
    cmp r9d, MSG_GAME_SV_SERVERSETTINGS
    je on_game_msg_sv_serversettings

    print_label s_unknown_game_msg
    mov rax, r9
    call println_uint32
    exit 1
on_game_message_end:
    pop_registers
    ret

on_game_msg_sv_motd:
    ; on_game_msg_sv_motd [rax]
    ;  rax = message payload
    print_label s_motd
    print_c_str rax
    call print_newline
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

on_game_msg_sv_voteclearoptions:
    ; on_game_msg_sv_voteclearoptions [rax]
    ;  rax = message payload
    jmp on_game_message_end

on_game_msg_sv_serversettings:
    ; on_game_msg_sv_serversettings [rax]
    ;  rax = message payload
    jmp on_game_message_end

