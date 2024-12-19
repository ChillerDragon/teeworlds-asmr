; push bytes directly into the udp buffer
; you can also push bytes into a packer buffer
; see packer.asm for that

%macro packet_packer_reset 0
    mov dword [udp_payload_index], 0

    mov byte [out_packet_header_flags], 0
    mov byte [out_packet_header_num_chunks], 0
%endmacro

%macro hexdump_outgoing_packet 0
    push rax
    push rdi

    print_label s_current_outgoing_packet_bytes
    mov rax, udp_send_buf
    mov dword edi, [udp_payload_index]
    add edi, PACKET_HEADER_LEN
    call print_hexdump
    call print_newline

    pop rdi
    pop rax
%endmacro

; packet_pack_raw [buffer] [buffer size]
%macro packet_pack_raw 2
    push rax
    push rdx
    push rdi
    push rsi
    push r8

    ; r8 is packet header len depending on connection version
    ; do not overwrite this anywhere in this function!
    push rax
    call get_packet_header_len
    mov r8d, eax
    pop rax

    ; copy dest
    mov dword edx, [udp_payload_index]
    lea rax, [udp_send_buf + r8d + edx]
    ; copy source
    mov rdi, %1
    ; copy size
    mov rsi, %2
    call mem_copy

    add dword [udp_payload_index], %2

    pop r8
    pop rsi
    pop rdi
    pop rdx
    pop rax
%endmacro

%macro packet_pack_byte 1
    push rax
    push rdx
    push rdi
    push rcx
    push r8

    ; r8 is packet header len depending on connection version
    ; do not overwrite this anywhere in this function!
    push rax
    call get_packet_header_len
    mov r8d, eax
    pop rax

    ; copy one byte
    mov dword edx, [udp_payload_index]
    lea rdi, [udp_send_buf + r8d + edx]
    mov byte [rdi], %1

    ; increment payload index
    inc edx
    mov dword [udp_payload_index], edx

    pop r8
    pop rcx
    pop rdi
    pop rdx
    pop rax
%endmacro

%macro packet_packer_pack_int 1
    ; packet_packer_pack_int [integer or 32 bit register]
    ; applies teeworlds int compression
    ; and pushes it into the packet payload to be sent
    push_registers

    mov r9d, %1

    mov rax, 0
    mov eax, r9d

    ; r8 is packet header len depending on connection version
    ; do not overwrite this anywhere in this function!
    push rax
    call get_packet_header_len
    mov r8d, eax
    pop rax

    mov dword edx, [udp_payload_index]
    lea rdi, [udp_send_buf + r8d + edx]

    ; _pack_int [rax] [rdi]
    ;  rax = integer
    ;  rdi = buffer to write to
    ; returns offsetted pointer in rax
    call _pack_int

    ; write start
    mov dword edx, [udp_payload_index]
    lea rdi, [udp_send_buf + r8d + edx]

    ; rax is the returned write end pointer
    ; calculate amount of bytes written
    sub rax, rdi

    ; increment edx which is still the udp payload index
    add edx, eax
    ; bump payload index by bytes packed
    mov dword [udp_payload_index], edx

    pop_registers
%endmacro

