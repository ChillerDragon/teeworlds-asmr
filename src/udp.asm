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
    ; flags
    xor r10, r10
    mov r10, MSG_DONTWAIT
    lea r8, udp_srv_addr
    lea r9, max_sockaddr_read_size
    syscall
    mov [udp_read_len], rax

    ; error checking
    test rax, rax
    ; if recvfrom returned negative
    ; we do not process the udp payload
    js .recv_udp_error

    ; debug print
    print s_received_bytes
    mov rax, [udp_read_len]
    call print_uint32
    call print_newline

    ret
.recv_udp_error:
    print s_udp_error
    call print_newline
    ret

send_udp:
    ; send_udp [rax] [rdi]
    ;  rax = pointer to payload
    ;  rdi = payload length
    ;
    ; sends a udp packet to the `socket`
    ; make sure to fist call open_socket
    push_registers

    ; buffer to send
    mov rsi, rax

    ; buffer size
    mov rdx, rdi

    ; syscall
    mov rax, SYS_SENDTO

    ; socket file descriptor
    xor rdi, rdi ; zero the whole rdi register
    movzx rdi, byte [socket] ; then only set the lowest byte

    ; flags
    xor r10, r10

    ; target socket address
    mov r8, sockaddr_localhost_8303

    ; target socket address size
    mov r9, 16

    syscall

    pop_registers
    ret

