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
    ;  pack_str cfg_password
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

    ; first byte is 2 bit flags (we or them in)
    ; and the remaining 6 bit are the first part of size
    mov r8, rdi
    shr r8, 6
    and r8b, 0b00111111
    mov byte [rsi], r8b
    or byte [rsi], al

    ; second byte is only the size
    ; the sequence number will also be inserted later if it is vital
    mov r8, rdi
    and r8, 0b00111111
    mov byte [rsi+1], r8b

    ; sequence only included if it is a vital chunk
    is_rax_flag CHUNKFLAG_VITAL
    jne .pack_chunk_header_end

    ; patch 2 bits in the second byte
    ; if sequence is bigger than 8 bit
    mov r8, 0
    mov r8d, dword [connection_sequence]
    shr r8, 2
    and r8, 0b11000000
    or byte [rsi+1], r8b

    ; full 8 bit sequence into third byte
    mov byte al, [connection_sequence]
    mov byte [rsi+2], al

    ; return size for vital chunks
    mov rcx, 3

.pack_chunk_header_end:
    mov rax, rcx
    pop_registers_keep_rax
    ret

