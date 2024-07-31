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

    mov byte [out_packet_header_flags], 0
    mov byte [out_packet_header_num_chunks], 0
%endmacro

%macro packet_packer_pack_int 1
    ; packet_packer_pack_int [integer or 32 bit register]
    ; applies teeworlds int compression
    ; and pushes it into the packet payload to be sent
    push_registers

    mov rax, 0
    mov eax, %1

    mov dword edx, [udp_payload_index]
    lea rdi, [udp_send_buf + PACKET_HEADER_LEN + edx]

    mov rax, 0
    ;  rdx = msg id
    mov eax, edx
    ;  r10 = system (CHUNK_SYSTEM or CHUNK_GAME)
    or eax, r10d

    ; _pack_int [rax] [rdi]
    ;  rax = integer
    ;  rdi = buffer to write to
    ; returns offsetted pointer in rax
    call _pack_int

    ; write start
    mov dword edx, [udp_payload_index]
    lea rdi, [udp_send_buf + PACKET_HEADER_LEN + edx]

    ; rax is the returned write end pointer
    ; calculate amount of bytes written
    sub rax, rdi

    ; increment edx which is still the udp payload index
    add edx, eax
    ; bump payload index by bytes packed
    mov dword [udp_payload_index], edx

    pop_registers
%endmacro

