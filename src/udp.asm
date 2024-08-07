open_socket:
    ; open_socket
    ;
    ; opens a udp socket and stores it in
    ; the variable `socket`
    push_registers

    mov rax, SYS_SOCKET
    mov rsi, AF_INET
    mov rdi, SOCK_DGRAM
    mov rdx, 0 ; flags
    syscall
    mov rdi, rax ; socket file descriptor

    mov [socket], rax
    print_label s_got_file_desc
    mov rax, [socket]
    call println_uint32

    pop_registers
    ret

recv_udp:
    ; recv_udp
    ;
    ; listens for udp packet on the
    ; `socket` and fills the `udp_recv_buf`
    push_registers
    mov rax, SYS_RECVFROM
    movzx rdi, byte [socket] ; then only set the lowest byte
    lea rsi, udp_recv_buf
    mov rdx, NET_MAX_PACKETSIZE
    ; flags
    xor r10, r10
    mov r10, MSG_DONTWAIT
    lea r8, udp_srv_addr
    lea r9, sizeof_sockaddr_struct
    syscall
    mov [udp_read_len], rax

    ; error checking
    test rax, rax
    ; if recvfrom returned negative
    ; we do not process the udp payload
    js .recv_udp_error

    ; debug print
    print_label s_received_bytes
    mov rax, [udp_read_len]
    call println_uint32
    jmp .recv_udp_end
.recv_udp_error:
    neg rax
    cmp rax, EWOULDBLOCK
    je .recv_udp_end
    print_label s_udp_error
    call println_uint32
.recv_udp_end:
    pop_registers
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

