on_system_or_game_messages:
    ; on_system_or_game_messages [rax] [rdi]
    ;  rax = payload buffer
    ;  rdi = chunk callback
    push_registers

    ; payload buffer
    mov r9, rax

    ; chunk callback
    mov r10, rdi

    print s_got_packet_with_chunks

    mov al, [packet_header_num_chunks]
    call print_uint32

    lea rax, [r9+0]
    call unpack_chunk_header
    call print_chunk_header

    ; TODO: int unpacker first before looking at chunk splitting
    ;       we need to read the correct amount of bytes when unpacking the msg id
    ;       it might be more than one byte
    ;       hacking one byte would be a super annoying refactor later

    ; no this is wrong lol
    ; the chunk header size includes the message id
    ; so we can correctly skip over all chunks without a int unpacker
    ; https://chillerdragon.github.io/teeworlds-protocol/07/packet_layout.html#chunk_header_size

    pop_registers
    ret

on_game_message:
    ; on_game_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    print s_got_system_msg_with_id
    call print_uint32
    call print_newline
    ret

on_system_message:
    ; on_system_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    print s_got_game_msg_with_id
    call print_uint32
    call print_newline
    ret

on_message:
    ; on_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = system (CHUNK_SYSTEM or CHUNK_GAME)
    ;  rsi = message payload
    ;
    ; for size and flags check the chunk_header_* labels
    push_registers

    cmp edi, CHUNK_SYSTEM
    je .on_message_system

    jmp .on_message_game

.on_message_system:
    call on_system_message
    jmp .on_message_end

.on_message_game:
    call on_game_message

.on_message_end:
    pop_registers
    ret

on_packet:
    push rax
    mov rax, udp_recv_buf
    call unpack_packet_header
    pop rax

    is_packet_flag PACKETFLAG_CONTROL
    je on_ctrl_message

    mov rax, packet_payload
    mov rdi, on_message
    call on_system_or_game_messages

on_packet_end:
    ret

