unpack_packet_header:
    ; unpack_packet_header [rax]
    ;  rax = buffer to unpack
    push_registers

    ; dereference pointer
    mov rcx, [rax]
    ; move 1 byte at offset 0
    mov byte [packet_header_flags], cl

    ; dereference pointer
    mov rcx, [rax + 3]
    ; move 4 bytes at offset 3
    mov [packet_header_token], ecx

    pop_registers
    ret

