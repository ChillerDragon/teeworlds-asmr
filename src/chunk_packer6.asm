pack_chunk_header6:
    ; pack_chunk_header6 [rax] [rdi] [rsi]
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

    ; Chunk header (vital) 0.6
    ; +---------+---------+-----------------+--------+-----------------+
    ; | Flags   | Size    | Sequence number | Size   | Sequence number |
    ; | 2 bits  | 6 bits  | 4 bits          | 4 bits | 8 bits          |
    ; +---------+---------+-----------------+--------+-----------------+

    ; first byte is 2 bit flags (we or them in)
    ; and the remaining 6 bit are the first part of size
    mov r8, rdi
    shr r8, 4
    and r8b, 0b00111111
    mov byte [rsi], r8b
    or byte [rsi], al

    ; second byte is only the size
    ; the sequence number will also be inserted later if it is vital
    mov r8, rdi
    and r8, 0b00001111
    mov byte [rsi+1], r8b

    ; sequence only included if it is a vital chunk
    is_rax_flag CHUNKFLAG_VITAL
    jne .pack_chunk_header6_end

    ; patch 2 bits in the second byte
    ; if sequence is bigger than 8 bit
    mov r8, 0
    mov r8d, dword [connection_sequence]
    shr r8b, 2
    and r8b, 0b11110000
    ; teeworlds uses 11110000
    ; and ddnet uses 11111100
    or byte [rsi+1], r8b

    ; full 8 bit sequence into third byte
    mov byte al, [connection_sequence]
    mov byte [rsi+2], al

    ; return size for vital chunks
    mov rcx, 3

.pack_chunk_header6_end:
    mov rax, rcx
    pop_registers_keep_rax
    ret
