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

%macro packer_reset 0
    mov dword [udp_payload_index], 0
%endmacro

; prints something like this
; [packer] amount of bytes packed: 2
%macro packer_print_size 0
    push rax

    print s_packer_size

    mov eax, [udp_payload_index]
    call print_uint32
    call print_newline

    pop rax
%endmacro

; pack_raw [buffer] [buffer size]
%macro pack_raw 2
    push rax
    push rdx
    push rdi
    push rsi

    ; copy dest
    mov dword edx, [udp_payload_index]
    lea rax, [udp_send_buf + PACKET_HEADER_LEN + edx]
    ; copy source
    mov rdi, %1
    ; copy size
    mov rsi, %2
    call mem_copy

    add dword [udp_payload_index], %2

    pop rsi
    pop rdi
    pop rdx
    pop rax
%endmacro

%macro pack_byte 1
    push rax
    mov rax, %1
    call push_packet_payload_byte
    pop rax
%endmacro

%macro pack_int 1
    push rax
    push rdi
    push rdx

    mov rax, %1
    mov dword edx, [udp_payload_index]
    lea rdi, [udp_send_buf + PACKET_HEADER_LEN + edx]
    call _pack_int

    ; increment payload index by bytes packed
    sub rax, rdi
    add edx, eax
    mov [udp_payload_index], edx

    pop rdx
    pop rdi
    pop rax
%endmacro
