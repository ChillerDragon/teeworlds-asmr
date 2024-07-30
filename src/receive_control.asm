on_ctrl_msg_token:
    mov rax, [udp_recv_buf + 8]
    mov [peer_token], eax

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

    ; mov eax, [connection_sequence]
    ; inc eax
    ; mov [connection_sequence], eax

    mov byte [packet_header_flags], 0x00
    mov byte [packet_header_num_chunks], 0x01
    mov rax, PAYLOAD_SEND_INFO
    mov rdi, PAYLOAD_SEND_INFO_LEN
    call send_packet_with_payload

    jmp on_ctrl_message_end

on_ctrl_msg_close:
    push rax

    mov rax, [packet_payload + 1]
    cmp rax, 0
    je .on_ctrl_msg_close_no_reason

.on_ctrl_msg_close_reason:
    print s_got_disconnect_with_reason
    lea rax, [packet_payload + 1]
    print_c_str rax
    call print_newline
    jmp .on_ctrl_msg_close_end

.on_ctrl_msg_close_no_reason:
    print s_got_disconnect

.on_ctrl_msg_close_end:
    exit 0
    pop rax
    jmp on_ctrl_message_end

on_ctrl_message:
    push_registers ; popped in on_ctrl_message_end

    print s_got_ctrl_msg

    mov al, [udp_recv_buf + PACKET_HEADER_LEN]
    call print_uint32

    cmp al, MSG_CTRL_TOKEN
    je on_ctrl_msg_token
    cmp al, MSG_CTRL_ACCEPT
    je on_ctrl_msg_accept
    cmp al, MSG_CTRL_CLOSE
    je on_ctrl_msg_close

    print s_unknown_ctrl_msg
    call print_uint32

on_ctrl_message_end:
    pop_registers ; pushed in on_ctrl_message
    jmp on_packet_end

