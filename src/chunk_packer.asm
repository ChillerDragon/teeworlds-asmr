%macro send_msg 3
    ; send_msg [MSG_ID] [CHUNKFLAG_VITAL] [CHUNK_SYSTEM]
    ; queues a chunk and also sends a udp packet
    ; the chunk header will be build automatically
    ; the chunk payload will be filled based on the current packer
    ;
    ; example:
    ;
    ;  packer_reset
    ;  pack_str GAME_NETVERSION
    ;  pack_str password
    ;  pack_int CLIENT_VERSION
    ;  send_msg MSG_SYSTEM_INFO, CHUNKFLAG_VITAL, CHUNK_SYSTEM

    ;  rax = flags (vital & resend)
    mov rax, %2

    ;  rdi = payload
    mov rdi, packer_buf

    ;  rsi = payload size
    mov rsi, 0
    mov esi, [packer_size]

    ;  rdx = msg id
    mov rdx, %1

    ;  r10 = system (CHUNK_SYSTEM or CHUNK_GAME)
    mov r10, %3

    call queue_chunk
%endmacro


pack_chunk_header:
    ; pack_chunk_header [rax] [rdi] [rsi]
    ;   rax = flags
    ;   rdi = size
    ;   rsi = output buffer
    ; returns into rax the size written
    ;   will be either 2 for non vital
    ;   or 3 for vital
    ;
    ; example:
    ;
    ;  mov rax, 0
    ;  set_rax_flag CHUNKFLAG_VITAL
    ;  mov rdi, 10
    ;  mov rsi, my_chunk_buffer
    ;  call pack_chunk_header
    ;
    push_registers_keep_rax

    cmp rdi, 63
    jg .pack_chunk_header_error_size

    push rax
    mov eax, [connection_sequence]
    cmp eax, 255
    jg .pack_chunk_header_error_seq
    pop rax

    ; rcx will be used for tmp register holding the return value
    ; in the end it will be written to rax
    ;
    ; return size for non vital chunks
    mov rcx, 2


    ; Chunk header (vital)
    ; +---------+---------+-----------------+--------+-----------------+
    ; | Flags   | Size    | Sequence number | Size   | Sequence number |
    ; | 2 bits  | 6 bits  | 2 bits          | 6 bits | 8 bits          |
    ; +---------+---------+-----------------+--------+-----------------+

    ; flags
    mov [rsi], al
    ; size (only in the 2nd byte for now)
    mov [rsi+1], dil

    ; sequence only included if it is a vital chunk
    is_rax_flag CHUNKFLAG_VITAL
    jne .pack_chunk_header_end

    ; sequence (only in the 3rd byte for now)
    mov byte al, [connection_sequence]
    mov [rsi+2], al

    ; return size for vital chunks
    mov rcx, 3

    jmp .pack_chunk_header_end

.pack_chunk_header_error_seq:
    print s_unsupported_seq_size
    mov rax, [connection_sequence]
    call print_uint32
    exit 1

.pack_chunk_header_error_size:
    print s_unsupported_chunk_size
    mov rax, rdi
    call print_uint32
    exit 1

.pack_chunk_header_end:
    mov rax, rcx
    pop_registers_keep_rax
    ret

queue_chunk:
    ; queue_chunk [rax] [rdi] [rsi] [rdx] [r10]
    ;  rax = flags (vital & resend)
    ;  rdi = payload
    ;  rsi = payload size
    ;  rdx = msg id
    ;  r10 = system (CHUNK_SYSTEM or CHUNK_GAME)

    ; resend flag is not supported yet

    push_registers

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
    lea rsi, [udp_send_buf + PACKET_HEADER_LEN + r11d]

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

    hexdump_outgoing_packet

.queue_chunk_pack_payload:

    ; destination buffer
    mov r11, 0
    mov dword r11d, [udp_payload_index]
    lea rax, [udp_send_buf + PACKET_HEADER_LEN + r11d]

    ; source buffer is already in rdi
    ; size is already in rsi
    call mem_copy

    ; r11d is still the udp_payload_index
    ; esi is the payload size
    add r11d, esi
    mov dword [udp_payload_index], r11d

    pop_registers
    ret

