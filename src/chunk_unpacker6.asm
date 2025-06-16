unpack_chunk_header6:
    ; unpack_chunk_header6 [rax]
    ;   rax = buffer
    push_registers

    ; flags
    mov rdx, 0
    mov dl, [rax]
    and dl, 0b1100_0000
    mov [chunk_header_flags], dl

    ; size
    ; extract bits from first byte
    mov rdx, 0
    mov dl, [rax]
    and edx, 0b0011_1111
    shl edx, 4
    ; extract bits from second byte
    mov rbx, 0
    mov bl, [rax+1]
    and ebx, 0b0000_1111
    ; merge them together to one 2 byte integer
    or ebx, edx
    mov [chunk_header_size], ebx

    ; sequence
    ; teeworlds uses -1 to represent a unset sequence
    ; but i am scared of negative numbers so i will use
    ; the ambiguous value zero to represent unset sequence numbers
    ; in non vital chunks
    mov dword [chunk_header_sequence], 0
    is_chunk_flag CHUNKFLAG_VITAL
    jne .unpack_chunk_header6_end

    ; first sequence byte
    mov rdx, 0
    mov dl, [rax+1]
    and edx, 0b1111_0000
    shl edx, 2
    ; 2nd sequence byte
    mov rbx, 0
    mov bl, [rax+2]
    ; merge
    or ebx, edx
    mov [chunk_header_sequence], ebx

.unpack_chunk_header6_end:

    pop_registers
    ret

