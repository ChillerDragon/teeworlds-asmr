queue_chunk:
    ; queue_chunk [rax] [rdi] [rsi] [rdx] [r10]
    ;  rax = flags (vital & resend)
    ;  rdi = payload
    ;  rsi = payload size
    ;  rdx = msg id
    ;  r10 = system (CHUNK_SYSTEM or CHUNK_GAME)
    ; supports both 0.6 and 0.7

    ; resend flag is not supported yet

    push_registers

    ; r8 is packet header len depending on connection version
    ; do not overwrite this anywhere in this function!
    mov r8d, PACKET_HEADER_LEN

    push rax
    mov al, byte [connection_version]
    cmp al, 7
    je .version7
    mov r8d, PACKET6_HEADER_LEN
    .version7:
    ._: ; clear label for debugger
    pop rax

    ; increment num chunks
    push rax
    mov byte al, [out_packet_header_num_chunks]
    inc al
    mov byte [out_packet_header_num_chunks], al
    pop rax

    ; only if vital increment sequence
    is_rax_flag CHUNKFLAG_VITAL
    jne .queue_chunk_pack_header

.queue_chunk_increment_seq: ; not jumped to only here for debugger readability
    push rax
    mov eax, [connection_sequence]
    inc eax
    mov [connection_sequence], eax
    pop rax

.queue_chunk_pack_header:

    push rdi
    push rsi
    ; chunk size
    mov rdi, rsi

    ; hack to solve chicken and egg problem
    ; message ids higher than 31 need 2 bytes to be packed
    ; https://chillerdragon.github.io/teeworlds-protocol/07/packet_layout.html#message_with_header_and_payload
    ; ideally the message id packing would tell us how many bytes were packed
    ; but the header is packed before the message id
    cmp edx, 31
    jng .queue_chunk_pack_header_add_msg_id_to_size

    ; increment size one more time for message ids that take 2 bytes
    add rdi, 1

.queue_chunk_pack_header_add_msg_id_to_size:
    add rdi, 1

    ; set output buffer
    mov dword r11d, [udp_payload_index]
    lea rsi, [udp_send_buf + r8d + r11d]

    ; flags are already in rax
    call pack_chunk_header
    pop rsi
    pop rdi

    ; r11d is still the udp_payload_index
    ; eax is the returned chunk header size written
    add r11d, eax
    mov dword [udp_payload_index], r11d

.queue_chunk_pack_msg_id:

    ; message id and system flag
    push rax
    mov rax, 0
    ;  rdx = msg id
    mov eax, edx
    shl rax, 1
    ;  r10 = system (CHUNK_SYSTEM or CHUNK_GAME)
    or eax, r10d
    packet_packer_pack_int eax

    pop rax

.queue_chunk_pack_payload:

    ; destination buffer
    mov r11, 0
    mov dword r11d, [udp_payload_index]
    lea rax, [udp_send_buf + r8d + r11d]

    ; source buffer is already in rdi
    ; size is already in rsi
    call mem_copy

    ; r11d is still the udp_payload_index
    ; esi is the payload size
    add r11d, esi
    mov dword [udp_payload_index], r11d

    pop_registers
    ret

