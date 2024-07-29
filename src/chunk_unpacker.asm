unpack_chunk_header:
    ; unpack_chunk_header [rax]
    ;   rax = buffer
    push_registers

    ; flags
    mov dl, [rax]
    and dl, 0b1100_0000
    mov [chunk_header_flags], dl

    pop_registers
    ret

