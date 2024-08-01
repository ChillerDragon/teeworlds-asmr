send_msg_info:
    push_registers

    ; mov byte [packet_header_flags], 0x00
    ; mov byte [packet_header_num_chunks], 0x01
    ; mov rax, PAYLOAD_SEND_INFO
    ; mov rdi, PAYLOAD_SEND_INFO_LEN
    ; call send_packet_with_payload

    packer_reset
    pack_str GAME_NETVERSION
    pack_str password
    pack_int CLIENT_VERSION

    ;  rax = flags (vital & resend)
    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL

    ;  rdi = payload
    mov rdi, packer_buf

    ;  rsi = payload size
    mov rsi, 0
    mov esi, [packer_size]

    ; mov rsi, [packer_size]

    ;  rdx = msg id
    mov rdx, MSG_SYSTEM_INFO

    ;  r10 = system (CHUNK_SYSTEM or CHUNK_GAME)
    mov r10, CHUNK_SYSTEM

    call queue_chunk
    call send_packet

    pop_registers
    ret

