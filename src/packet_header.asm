%macro is_packet_in_flag 1
    ; is_packet_in_flag [PACKETFLAG_CONSTANT]
    ;
    ; example:
    ;
    ;  is_packet_in_flag PACKETFLAG_CONTROL
    ;  je on_ctrl_message
    ;
    push rax
    mov al, [in_packet_header_flags]
    is_rax_flag %1
    pop rax
%endmacro

unpack_packet_header:
    ; unpack_packet_header [rax]
    ;  rax = buffer to unpack
    push_registers

    ; dereference pointer
    mov rcx, [rax]
    ; move 1 byte at offset 0
    mov byte [in_packet_header_flags], cl

    ; dereference pointer
    mov rcx, [rax + 2]
    ; move 1 byte at offset 2
    mov byte [in_packet_header_num_chunks], cl

    ; dereference pointer
    mov rcx, [rax + 3]
    ; move 4 bytes at offset 3
    mov [in_packet_header_token], ecx

    pop_registers
    ret

