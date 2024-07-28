%macro is_packet_flag 1
    ; is_packet_flag [rax]
    ;  rax = flag
    ;
    ; example:
    ;
    ;  is_packet_flag PACKETFLAG_CONTROL
    ;  jnz on_ctrl_message
    ;
    ; no idea if this "if statement" is correct
    push rax
    mov al, [packet_header_flags]
    and al, %1
    cmp al, 0
    pop rax
%endmacro

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

