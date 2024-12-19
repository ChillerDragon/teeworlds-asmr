; abstraction layer for supporting both 0.6 and 0.7 at the same time
; basically a bunch of getters that give the right values
; depending on the current version

get_recv_buf:
    ; returns into rax either `udp_recv_buf` or `udp_recv6_buf`
    ; depending on the current connection version
    mov al, byte [connection_version]
    cmp al, 7
    je .version7
    .version6:
    mov rax, udp_recv6_buf
    jmp .end
    .version7:
    mov rax, udp_recv_buf
    .end:
    ret

get_packet_header_len:
    ; returns into rax the packet header length
    ; which is 3 for 0.6 and 7 for 0.7
    ;
    push r8
    mov r8d, PACKET_HEADER_LEN
    mov al, byte [connection_version]
    cmp al, 7
    je .version7
    mov r8d, PACKET6_HEADER_LEN
    .version7:
    ._: ; clear label for debugger
    mov rax, r8
    pop r8
    ret
