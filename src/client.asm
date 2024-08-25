connect:
    packet_packer_reset
    mov dword [peer_token], 0xFFFFFFFF

    mov rax, sockaddr_server
    mov rdi, generic_buffer_512
    call sockaddr_to_str

    print_label s_connecting_to
    print_c_str rdi
    call print_newline

    call send_ctrl_msg_token
    ret

