; push bytes directly into the udp buffer
; you can also push bytes into a packer buffer
; see packer.asm for that

push_packet_payload_byte:
    ; push_packet_payload_byte [rax]
    ;  rax = (or al) is the byte as value to be pushed into the `udp_send_buf`
    push rcx
    push rdx

    mov dword edx, [udp_payload_index]

    lea rcx, [udp_send_buf + PACKET_HEADER_LEN + edx]
    mov byte [rcx], al

    mov rcx, [udp_payload_index]
    inc rcx
    mov [udp_payload_index], rcx

    pop rdx
    pop rcx
    ret

%macro packet_packer_reset 0
    mov dword [udp_payload_index], 0
%endmacro

