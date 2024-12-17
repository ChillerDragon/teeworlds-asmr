send_ready:
    push_registers

    packer_reset
    send_msg MSG_SYSTEM_READY, CHUNKFLAG_VITAL, CHUNK_SYSTEM

    call send_packet

    pop_registers
    ret

send_msg_info:
    push_registers

    packer_reset
    pack_str GAME_NETVERSION
    pack_str cfg_password
    pack_int CLIENT_VERSION
    send_msg MSG_SYSTEM_INFO, CHUNKFLAG_VITAL, CHUNK_SYSTEM

    call send_packet

    pop_registers
    ret

send_msg6_info:
    push_registers

    packer_reset
    pack_str GAME_NETVERSION6
    pack_str cfg_password
    send_msg MSG6_SYSTEM_INFO, CHUNKFLAG_VITAL, CHUNK_SYSTEM

    call send_packet

    pop_registers
    ret

send_msg_input:
    push_registers

    packer_reset
    pack_int [ack_game_tick]
    pack_int [ack_game_tick] ; this is the pred tick lol
    pack_int 40 ; size
    pack_int [input_direction]
    pack_int [input_target_x]
    pack_int [input_target_y]
    pack_int [input_jump]
    pack_int [input_fire]
    pack_int [input_hook]
    pack_int [input_player_flags]
    pack_int [input_wanted_weapon]
    pack_int [input_next_weapon]
    pack_int [input_prev_weapon]
    pack_int 0 ; what is ping correction ????

    send_msg MSG_SYSTEM_INPUT, 0, CHUNK_SYSTEM

    call send_packet


    mov dword [input_direction], 0

    pop_registers
    ret

send_msg_enter_game:
    push_registers

    packer_reset
    send_msg MSG_SYSTEM_ENTERGAME, CHUNKFLAG_VITAL, CHUNK_SYSTEM

    call send_packet

    pop_registers
    ret

