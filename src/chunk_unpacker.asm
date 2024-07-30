%macro is_chunk_flag 1
    ; is_chunk_flag [CHUNKFLAG_CONSTANT]
    ;
    ; example:
    ;
    ;  is_chunk_flag CHUNKFLAG_VITAL
    ;  je on_vital_chunk
    ;
    push rax
    mov al, [chunk_header_flags]
    is_rax_flag %1
    pop rax
%endmacro

unpack_chunk_header:
    ; unpack_chunk_header [rax]
    ;   rax = buffer
    push_registers

    ; flags
    mov dl, [rax]
    and dl, 0b1100_0000
    mov [chunk_header_flags], dl

    ; size
    ; dl still holds the first byte
    ; extract bits from first byte
    and dl, 0b0011_1111
    shl dl, 6
    ; extract bits from second byte
    mov bl, [rax+1]
    and bl, 0b0011_1111
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
    jne .unpack_chunk_header_end

    ; first sequence byte
    mov dl, [rax+1]
    and dl, 0b1100_0000
    shl dl, 2
    ; 2nd sequence byte
    mov bl, [rax+2]
    ; merge
    xor ebx, edx
    mov [chunk_header_sequence], ebx

.unpack_chunk_header_end:

    pop_registers
    ret

