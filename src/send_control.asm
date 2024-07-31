send_ctrl_msg_token:
    push rax
    push rdi

    mov byte [out_packet_header_flags], PACKETFLAG_CONTROL
    mov byte [out_packet_header_num_chunks], 0
    mov rax, PAYLOAD_CTRL_TOKEN
    mov rdi, PAYLOAD_CTRL_TOKEN_LEN
    call send_packet_with_payload

    pop rdi
    pop rax
    ret

send_ctrl_msg_connect:
    push rax

    pack_byte MSG_CTRL_CONNECT
    pack_raw token, 4

    ; hack to send a bunch of bytes to pass the
    ; anti reflection attack check
    ; those bytes are not set here so their last used values will be sent
    ; this should for the first connection be all zeros
    ; which is exactly what we want
    ;
    ; for later connections it might leak contents of packets we sent before that
    ; the server does not need null bytes it just cares about the size
    ; but we as a client might leak information sent to one server to another
    ;
    ; imagine the following scenario
    ; we send a rcon auth on server a filling the udp_send_buf with our rcon password
    ; and then we connect to another server
    ; where we send 512 bytes of the udp_send_buf which still holds the rcon password
    mov dword [udp_payload_index], 512

    packer_print_size

    mov byte [out_packet_header_flags], PACKETFLAG_CONTROL
    mov byte [out_packet_header_num_chunks], 0
    call send_packet

    pop rax
    ret

