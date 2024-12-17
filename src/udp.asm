str_to_sockaddr:
    ; str_to_sockaddr [rax] [rdi]
    ;  rax = input string in the format "127.0.0.1:8303"
    ;  rdi = output buffer for sockaddr struct
    push_registers

    ; r9 output buffer
    mov r9, rdi

    ; two byte family
    mov byte [r9+0], AF_INET
    mov byte [r9+1], 0x00

    ; 4 byte addr
    mov rdi, rax
    call str_to_int_seek_rdi
    inc rdi ; skip dot
    mov byte [r9+4], al
    call str_to_int_seek_rdi
    inc rdi ; skip dot
    mov byte [r9+5], al
    call str_to_int_seek_rdi
    inc rdi ; skip dot
    mov byte [r9+6], al
    call str_to_int_seek_rdi
    inc rdi ; skip colon
    mov byte [r9+7], al

    ; two byte port
    call str_to_int_seek_rdi
    ; swap bytes (host to network i guess)
    mov word [swap_buffer_16], ax
    mov r8b, byte [swap_buffer_16+1]
    mov byte [swap_buffer_8+0], r8b
    mov r8b, byte [swap_buffer_16+0]
    mov byte [swap_buffer_8+1], r8b
    mov r8w, word [swap_buffer_8]
    mov word [r9+2], r8w

    ; 8 byte watafak padding
    mov byte [r9+8], 0x00
    mov byte [r9+9], 0x00
    mov byte [r9+10], 0x00
    mov byte [r9+11], 0x00
    mov byte [r9+12], 0x00
    mov byte [r9+13], 0x00
    mov byte [r9+14], 0x00
    mov byte [r9+15], 0x00

    pop_registers
    ret

sockaddr_to_str:
    ; sockaddr_to_str [rax] [rdi]
    ;  rax = pointer to sockaddr struct
    ;  rdi = output buffer
    push_registers

    ; ****
    ; addr
    ; ****

    mov r8, 0
    mov r8b, byte [rax+SOCKADDR_ADDR_OFFSET+0]
    push rax
    mov rax, r8
    call uint32_to_str_seek_rdi
    ; rdi outout
    pop rax
    mov byte [rdi], '.'
    inc rdi


    mov r8, 0
    mov r8b, byte [rax+SOCKADDR_ADDR_OFFSET+1]
    push rax
    mov rax, r8
    call uint32_to_str_seek_rdi
    ; rdi outout
    pop rax
    mov byte [rdi], '.'
    inc rdi


    mov r8, 0
    mov r8b, byte [rax+SOCKADDR_ADDR_OFFSET+2]
    push rax
    mov rax, r8
    call uint32_to_str_seek_rdi
    ; rdi outout
    pop rax
    mov byte [rdi], '.'
    inc rdi


    mov r8, 0
    mov r8b, byte [rax+SOCKADDR_ADDR_OFFSET+3]
    push rax
    mov rax, r8
    call uint32_to_str_seek_rdi
    ; rdi outout
    pop rax
    mov byte [rdi], ':'
    inc rdi

    ; ****
    ; port
    ; ****

    ; we have to swap the endianness first
    ; from network to host i guess
    mov r8, 0
    mov r8b, byte [rax+SOCKADDR_PORT_OFFSET+1]
    mov byte [swap_buffer_16+0], r8b
    mov r8b, byte [rax+SOCKADDR_PORT_OFFSET+0]
    mov byte [swap_buffer_16+1], r8b
    mov r8w, word [swap_buffer_16]

    ; the sockaddr port is a uint16_t
    ; but we have no int to str helper for that
    ; so we cut it off and use it as a uint32
    push rax
    mov rax, r8
    call uint32_to_str_seek_rdi
    ; rdi outout
    pop rax

    pop_registers
    ret

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
    ; recv_udp [rax]
    ;  rax = buffer to write to
    ;
    ; example call:
    ;
    ; mov rax, udp_recv_buf
    ; call recv_udp
    ;
    ; listens for udp packet on the
    ; `socket` and fills the buffer in rax
    ; which usually is `udp_recv_buf` or `udp_recv6_buf`
    push_registers
    ; output buffer
    mov r9, rax

    mov rax, SYS_RECVFROM
    movzx rdi, byte [socket] ; then only set the lowest byte
    mov rsi, r9 ; pointer to buffer `udp_recv_buf` or `udp_recv6_buf`
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

    ; ; debug print
    ; print_label s_received_bytes
    ; mov rax, [udp_read_len]
    ; call println_uint32
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
    mov r8, sockaddr_server

    ; target socket address size
    mov r9, 16

    syscall

    pop_registers
    ret

