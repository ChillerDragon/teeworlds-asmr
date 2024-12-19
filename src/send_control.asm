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

send_ctrl_close:

    packet_pack_byte MSG_CTRL_CLOSE
    packet_pack_byte 'a'
    packet_pack_byte 's'
    packet_pack_byte 'm'
    packet_pack_byte 'r'
    packet_pack_byte 0x00

    mov byte [out_packet_header_flags], PACKETFLAG_CONTROL
    mov byte [out_packet_header_num_chunks], 0
    call send_packet

    ret

send_ctrl_msg_connect6:
    push rax


    packet_pack_byte MSG6_CTRL_CONNECT
    packet_pack_raw MAGIC_TKEN, 4

    mov byte [out_packet_header_flags], PACKETFLAG6_CONTROL
    mov byte [out_packet_header_num_chunks], 0
    call send_packet

    pop rax
    ret

send_ctrl6_msg_ack_accept:
    push rax

    packet_pack_byte MSG6_CTRL_ACCEPT
    ; packet_pack_raw [peer_token], 4

    mov byte [out_packet_header_flags], PACKETFLAG6_CONTROL
    mov byte [out_packet_header_num_chunks], 0
    call send_packet

    pop rax
    ret

send_ctrl_msg_connect:
    push rax
    mov al, byte [connection_version]
    cmp al, 7
    je .connect7
    .connect6:
    call send_ctrl_msg_connect6
    jmp .end
    .connect7:
    call send_ctrl_msg_connect7
    .end:
    pop rax
    ret


send_ctrl_msg_connect7:
    push rax

    packet_pack_byte MSG_CTRL_CONNECT
    packet_pack_raw token, 4

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

    mov byte [out_packet_header_flags], PACKETFLAG_CONTROL
    mov byte [out_packet_header_num_chunks], 0
    call send_packet

    pop rax
    ret

