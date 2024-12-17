set_packet_header:
    push rax
    mov al, byte [connection_version]
    cmp al, 7
    je .version7
    .version6:
    call set_packet_header6
    jmp .end
    .version7:
    call set_packet_header7
    .end:
    pop rax
    ret

set_packet_header6:
    push_registers

    ; flags
    mov al, byte [out_packet_header_flags]
    mov byte [udp_send_buf], al
    ; the highest sequence number we acknowledged
    mov al, byte [connection_ack]
    mov byte [udp_send_buf + 1], al
    ; num chunks
    mov al, byte [out_packet_header_num_chunks]
    mov byte [udp_send_buf + 2], al

    pop_registers
    ret

set_packet_header7:
    push_registers

    ; flags
    mov al, byte [out_packet_header_flags]
    mov byte [udp_send_buf], al
    ; the highest sequence number we acknowledged
    mov al, byte [connection_ack]
    mov byte [udp_send_buf + 1], al
    ; num chunks
    mov al, byte [out_packet_header_num_chunks]
    mov byte [udp_send_buf + 2], al

    ; peer token
    mov al, byte [peer_token]
    mov [udp_send_buf + 3], al
    mov al, byte [peer_token + 1]
    mov [udp_send_buf + 4], al
    mov al, byte [peer_token + 2]
    mov [udp_send_buf + 5], al
    mov al, byte [peer_token + 3]
    mov [udp_send_buf + 6], al

    pop_registers
    ret

send_packet:
    push rax
    mov al, byte [connection_version]
    cmp al, 7
    je .version7
    .version6:
    call send_packet6
    jmp .end
    .version7:
    call send_packet7
    .end:
    pop rax
    ret

send_packet6:
    push rax
    push rdi

    call set_packet_header

    ; append ddnet security token at the end of all packet payloads
    packet6_pack_raw peer_token, 4

    ; buf
    mov rax, udp_send_buf

    ; size
    xor rdi, rdi
    mov edi, [udp_payload_index]
    add rdi, PACKET6_HEADER_LEN

    ; ; dbg print
    ; push rax
    ; print_label s_sending_packet_with_size
    ; mov rax, rdi
    ; call println_uint32
    ; pop rax

    call send_udp

    ; this is for convenience so we can just queue new chunks
    ; and never have to worry about which chunk is the first
    packet_packer_reset

    pop rdi
    pop rax
    ret

send_packet7:
    ; send_packet
    ;  the size will be the PACKET_HEADER_LEN + udp_payload_index
    ;
    ;  if you want to pass in a payload use
    ;  send_packet_with_payload
    ;  otherwise you have to make sure to fill
    ;  `udp_send_buf` starting at offset `PACKET_HEADER_LEN`
    ;  before calling send_packet
    ;
    ;  example:
    ;
    ; lea rax, [udp_send_buf + PACKET_HEADER_LEN]
    ; mov byte [rax], 0xFF
    ; lea rax, [udp_send_buf + PACKET_HEADER_LEN + 1]
    ; mov byte [rax], 0xFF
    ; call send_packet
    ;
    ;  or use one of the helpers:
    ;
    ; packer_reset
    ; pack_byte 0xFF
    ; pack_byte 0xFF
    ; call send_packet
    ;
    push rax
    push rdi

    call set_packet_header

    ; buf
    mov rax, udp_send_buf

    ; size
    xor rdi, rdi
    mov edi, [udp_payload_index]
    add rdi, PACKET_HEADER_LEN

    ; ; dbg print
    ; push rax
    ; print_label s_sending_packet_with_size
    ; mov rax, rdi
    ; call println_uint32
    ; pop rax


    call send_udp

    ; this is for convenience so we can just queue new chunks
    ; and never have to worry about which chunk is the first
    packet_packer_reset

    pop rdi
    pop rax
    ret

send_packet_with_payload:
    ; send_packet_with_payload [rax] [rdi]
    ;  rax = pointer to payload buffer
    ;  rdi = payload buffer size
    call set_packet_header

    ; push rdi
    ; mov rdi, 6
    ; call print_hexdump
    ; pop rdi

    push rax
    push rdi
    push rsi

    mov rsi, rdi ; copy size
    mov rdi, rax ; copy source
    lea rax, [udp_send_buf + PACKET_HEADER_LEN] ; copy destination
    call mem_copy

    pop rsi
    pop rdi
    pop rax

    mov rax, udp_send_buf
    add rdi, PACKET_HEADER_LEN
    call send_udp

    ; this is for convenience so we can just queue new chunks
    ; and never have to worry about which chunk is the first
    packet_packer_reset

    ret
