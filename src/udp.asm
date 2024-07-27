open_socket:
    ; open_socket
    ;
    ; opens a udp socket and stores it in
    ; the variable `socket`
    mov rax, SYS_SOCKET
    mov rsi, AF_INET
    mov rdi, SOCK_DGRAM
    mov rdx, 0 ; flags
    syscall
    mov rdi, rax ; socket file descriptor

    mov [socket], rax
    print s_got_file_desc
    mov rax, [socket]
    call print_uint32
    ret

recv_udp:
    ; recv_udp
    ;
    ; listens for udp packet on the
    ; `socket` and fills the `udp_recv_buf`
    mov rax, SYS_RECVFROM
    xor rdi, rdi ; zero the whole rdi register
    movzx rdi, byte [socket] ; then only set the lowest byte
    lea rsi, udp_recv_buf
    mov rdx, NET_MAX_PACKETSIZE
    xor r10, r10
    lea r8, udp_srv_addr
    lea r9, max_sockaddr_read_size
    syscall
    mov [udp_read_len], rax

    ; debug print
    print s_received_bytes
    mov rax, [udp_read_len]
    call print_uint32
    call print_newline

    ret

send_udp:
    ; send_udp
    ;
    ; sends a udp packet to the `socket`
    ; make sure to fist call open_socket
    mov rax, 0x414141 ; debug marker
    mov eax, SYS_SENDTO ; 0x2c

    xor rdi, rdi ; zero the whole rdi register
    movzx rdi, byte [socket] ; then only set the lowest byte

    mov rsi, MSG_CTRL_TOKEN
    mov edx, MSG_CTRL_TOKEN_LEN ; 0x20c
    xor r10, r10 ; flags
    mov r8, sockaddr_localhost_8303
    mov r9, 16 ; sockaddr size
    syscall
    ret
