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

on_game_msg_sv_motd:
    ; on_game_msg_sv_motd [rax]
    ;  rax = message payload
    print_label s_motd
    call get_string
    print_c_str rax
    call print_newline
    jmp on_game_message_end

on_game_msg_sv_broadcast:
    ; on_game_msg_sv_broadcast [rax]
    ;  rax = message payload
    print_label s_broadcast
    call get_string
    print_c_str rax
    call print_newline
    jmp on_game_message_end

on_game_msg_sv_chat:
    ; on_game_msg_sv_chat [rax]
    ;  rax = message payload
    print_label s_chat
    call print_newline
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

