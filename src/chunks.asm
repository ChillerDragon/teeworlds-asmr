pack_chunk_header:
    ; pack_chunk_header [rax] [rdi] [rsi]
    ;   rax = flags
    ;   rdi = size
    ;   rsi = output buffer
    ;
    ; example:
    ;
    ;  mov rax, 0
    ;  set_rax_flag CHUNKFLAG_VITAL
    ;  mov rdi, 10
    ;  mov rsi, my_chunk_buffer
    ;  call pack_chunk_header
    ;

    push rax

    cmp rdi, 63
    jg .pack_chunk_header_error_size

    push rax
    mov dword rax, [connection_sequence]
    cmp rax, 255
    jg .pack_chunk_header_error_seq
    pop rax

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
    jz .pack_chunk_header_end

    ; sequence (only in the 3rd byte for now)
    mov byte al, [connection_sequence]
    mov [rsi+2], al

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
    pop rax
    ret

queue_chunk:
    ; queue_chunk [rax] [rdi] [rsi] [rdx]
    ;  rax = system (1=system 0=game)
    ;  rdi = payload
    ;  rsi = payload size

    ; resend flag is not supported yet

    push_registers

    ; increment if vital
    ; connection_sequence

    pop_registers
    ret

