on_ctrl6_msg_connect_accept:
    ; in addition to checking the length
    ; we could also check for the "TKEN"
    ; magic in front of the token

    mov eax, dword [udp_read_len]
    cmp eax, 12
    je .len_ok
    mov rax, c_invalid_length_ddnet_only
    call throw_c_str
    .len_ok:

    mov rax, [udp_recv6_buf + PACKET6_HEADER_LEN + 5]
    mov [peer_token], eax
    print_label s_got_peer_token
    mov rax, peer_token
    mov rdi, 4
    call print_hexdump
    call print_newline

    print_label s_got_accept
    call send_ctrl6_msg_ack_accept
    call send_msg6_info

    jmp on_ctrl6_message_end

on_ctrl6_msg_close:
    push rax

    mov rax, [packet6_payload + 1]
    cmp rax, 0
    je .on_ctrl6_msg_close_no_reason

.on_ctrl6_msg_close_reason:
    print_label s_got_disconnect_with_reason
    lea rax, [packet6_payload + 1]
    print_c_str rax
    call print_newline
    jmp .on_ctrl6_msg_close_end

.on_ctrl6_msg_close_no_reason:
    print_label s_got_disconnect

.on_ctrl6_msg_close_end:
    exit 0
    pop rax
    jmp on_ctrl6_message_end

on_ctrl6_message:
    push_registers ; popped in on_ctrl6_message_end

    print_label s_got_ctrl_msg

    mov al, [udp_recv6_buf + PACKET6_HEADER_LEN]
    call println_uint32

    cmp al, MSG6_CTRL_CONNECTACCEPT
    je on_ctrl6_msg_connect_accept
    cmp al, MSG6_CTRL_CLOSE
    je on_ctrl6_msg_close

    print_label s_unknown_ctrl_msg
    call println_uint32

on_ctrl6_message_end:
    pop_registers ; pushed in on_ctrl6_message
    jmp on_packet_end

