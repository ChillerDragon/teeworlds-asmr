connect:
    call packet_packer_reset
    mov dword [peer_token], 0xFFFFFFFF

    mov rax, sockaddr_server
    mov rdi, generic_buffer_512
    call sockaddr_to_str

    mov al, byte [connection_version]
    cmp al, 7
    je .version7
    .version6:
    print_c_str c_connect6
    print_c_str rdi
    call print_newline
    call send_ctrl_msg_connect
    jmp .end
    .version7:
    print_c_str c_connect7
    print_c_str rdi
    call print_newline
    call send_ctrl_msg_token
    .end:
    ret

