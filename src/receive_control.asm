on_ctrl_msg_token:
    mov rax, [udp_recv_buf + 8]
    mov [peer_token], eax

    print_label s_got_peer_token
    mov rax, peer_token
    mov rdi, 4
    call print_hexdump
    call print_newline

    call send_ctrl_msg_connect

    jmp on_ctrl_message_end

on_ctrl_msg_accept:
    ; ignore cursed token only ddnet servers send
    ; https://github.com/ddnet/ddnet/issues/8805

    ; mov rax, [udp_recv_buf + 8]
    ; mov [peer_token], rax

    print_label s_got_accept
    call send_msg_info

    jmp on_ctrl_message_end

on_ctrl_msg_close:
    push rax

    mov rax, [packet_payload + 1]
    cmp rax, 0
    je .on_ctrl_msg_close_no_reason

.on_ctrl_msg_close_reason:
    print_label s_got_disconnect_with_reason
    lea rax, [packet_payload + 1]
    print_c_str rax
    call print_newline
    jmp .on_ctrl_msg_close_end

.on_ctrl_msg_close_no_reason:
    print_label s_got_disconnect

.on_ctrl_msg_close_end:
    exit 0
    pop rax
    jmp on_ctrl_message_end

on_ctrl_message:
    push_registers ; popped in on_ctrl_message_end

    print_label s_got_ctrl_msg

    mov al, [udp_recv_buf + PACKET_HEADER_LEN]
    call println_uint32

    cmp al, MSG_CTRL_TOKEN
    je on_ctrl_msg_token
    cmp al, MSG_CTRL_ACCEPT
    je on_ctrl_msg_accept
    cmp al, MSG_CTRL_CLOSE
    je on_ctrl_msg_close

    print_label s_unknown_ctrl_msg
    call println_uint32

on_ctrl_message_end:
    pop_registers ; pushed in on_ctrl_message
    jmp on_packet_end

