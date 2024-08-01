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
    pack_str password
    pack_int CLIENT_VERSION
    send_msg MSG_SYSTEM_INFO, CHUNKFLAG_VITAL, CHUNK_SYSTEM

    call send_packet

    pop_registers
    ret

