on_ctrl_msg_token:
    mov rax, [udp_recv_buf + 8]
    mov [peer_token], rax

    print s_got_peer_token
    mov rax, peer_token
    mov rdi, 4
    call print_hexdump
    call print_newline

    call send_ctrl_msg_connect

    jmp on_ctrl_message_end

on_ctrl_msg_accept:
    mov rax, [udp_recv_buf + 8]
    mov [peer_token], rax

    print s_got_accept

    mov rax, PAYLOAD_SEND_INFO
    mov rdi, PAYLOAD_SEND_INFO_LEN
    call send_packet_with_payload

    jmp on_ctrl_message_end

on_ctrl_message:
    push_registers ; popped in on_ctrl_message_end

    print s_got_ctrl_msg

    mov al, [udp_recv_buf + PACKET_HEADER_LEN]
    call print_uint32

    cmp al, MSG_CTRL_TOKEN
    jz on_ctrl_msg_token
    cmp al, MSG_CTRL_ACCEPT
    jz on_ctrl_msg_accept

    print s_unknown_ctrl_msg
    call print_uint32

on_ctrl_message_end:
    pop_registers ; pushed in on_ctrl_message
    ret

